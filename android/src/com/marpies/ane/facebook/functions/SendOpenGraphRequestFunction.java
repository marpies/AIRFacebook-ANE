/*
 * Copyright (c) 2018 Marcel Piestansky
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.marpies.ane.facebook.functions;

import android.os.Bundle;
import com.adobe.fre.FREArray;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREObject;
import com.facebook.AccessToken;
import com.facebook.GraphRequest;
import com.facebook.GraphResponse;
import com.facebook.HttpMethod;
import com.marpies.ane.facebook.data.AIRFacebookEvent;
import com.marpies.ane.facebook.utils.AIR;
import com.marpies.ane.facebook.utils.FREObjectUtils;
import com.marpies.ane.facebook.utils.StringUtils;
import org.json.JSONObject;

public class SendOpenGraphRequestFunction extends BaseFunction {

	private static GraphRequest.Callback mGraphRequestCallback;

	/**
	 *
	 *
	 * Public API
	 *
	 *
	 */

	@Override
	public FREObject call( FREContext context, FREObject[] args ) {
		super.call( context, args );

		AccessToken accessToken = AccessToken.getCurrentAccessToken();

		HttpMethod method = HttpMethod.valueOf( FREObjectUtils.getStringFromFREObject( args[0] ) );
		String graphPath = FREObjectUtils.getStringFromFREObject( args[1] );
		mListenerID = FREObjectUtils.getIntFromFREObject( args[3] );

		GraphRequest request = null;
		switch( method ) {
			case GET:
				request = GraphRequest.newGraphPathRequest( accessToken, graphPath, getCallback() );
				AIR.log( "Sending Open Graph GET request with path " + graphPath + "." );
				if( args.length > 2 && args[2] != null ) {
					Bundle parameters = FREObjectUtils.getBundleFromFREArray( (FREArray) args[2] );
					request.setParameters( parameters );
				}
				break;
			case POST:
				JSONObject object = null;
				if( args.length > 2 && args[2] != null ) {
					object = FREObjectUtils.getJSONObjectFromFREArray( (FREArray) args[2] );
				}
				request = GraphRequest.newPostRequest( accessToken, graphPath, object, getCallback() );
				String logMessage = "Sending Open Graph POST request with path " + graphPath;
				if( object != null ) {
					logMessage += " and parameters " + object.toString();
				}
				AIR.log( logMessage );
				break;
			case DELETE:
				request = GraphRequest.newDeleteObjectRequest( accessToken, graphPath, getCallback() );
				AIR.log( "Sending Open Graph DELETE request with ID " + graphPath + "." );
				break;
		}
		if( request != null ) {
			request.executeAsync();
		} else {
			AIR.dispatchEvent( AIRFacebookEvent.OPEN_GRAPH_ERROR,
					StringUtils.getEventErrorJSON( mListenerID, "Error creating Open Graph request." )
			);
		}

		return null;
	}

	/**
	 *
	 *
	 * Private API
	 *
	 *
	 */

	private void onGraphRequestResult( GraphResponse response ) {
		if( response.getError() != null ) {
			AIR.log( "Open Graph request error: " + response.getError().getErrorMessage() );
			AIR.dispatchEvent( AIRFacebookEvent.OPEN_GRAPH_ERROR,
					StringUtils.getEventErrorJSON( mListenerID, response.getError().getErrorMessage() )
			);
			return;
		}
		if( AIR.getContext() != null ) {
			String jsonResult = "{}";
			if( response.getJSONObject() != null ) {
				jsonResult = response.getJSONObject().toString();
			} else if( response.getJSONArray() != null ) {
				jsonResult = response.getJSONArray().toString();
			}
			AIR.dispatchEvent(
					AIRFacebookEvent.OPEN_GRAPH_SUCCESS,
					String.format( StringUtils.locale, "%d||%s||%s", mListenerID, jsonResult, response.getRawResponse() )
			);
		} else {
			AIR.log( "ANE CONTEXT IS NULL WHEN REQUESTING OPEN GRAPH" );
		}
	}

	private GraphRequest.Callback getCallback() {
		if( mGraphRequestCallback == null ) {
			mGraphRequestCallback = new GraphRequest.Callback() {
				@Override
				public void onCompleted( GraphResponse response ) {
					onGraphRequestResult( response );
				}
			};
		}
		return mGraphRequestCallback;
	}

}
