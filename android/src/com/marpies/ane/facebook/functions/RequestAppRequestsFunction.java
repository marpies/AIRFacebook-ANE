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
import android.text.TextUtils;
import com.adobe.fre.FREArray;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREObject;
import com.facebook.AccessToken;
import com.facebook.GraphRequest;
import com.facebook.GraphResponse;
import com.marpies.ane.facebook.AIRFacebookExtensionContext;
import com.marpies.ane.facebook.data.AIRFacebookEvent;
import com.marpies.ane.facebook.utils.AIR;
import com.marpies.ane.facebook.utils.FREObjectUtils;
import com.marpies.ane.facebook.utils.StringUtils;
import org.json.JSONArray;
import org.json.JSONException;
import org.json.JSONObject;

import java.util.List;

public class RequestAppRequestsFunction extends BaseFunction {

	private static GraphRequest.Callback mAppRequestsCallback;

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
		/* Request the app requests only if we have valid access token */
		if( accessToken != null && !accessToken.isExpired() ) {
			GraphRequest request = GraphRequest.newGraphPathRequest( accessToken, "/me/apprequests/", getCallback() );
			List<String> fields = (args[0] == null) ? null : FREObjectUtils.getListOfStringFromFREArray( (FREArray) args[0] );
			mListenerID = FREObjectUtils.getIntFromFREObject( args[1] );
			if( fields != null && fields.size() > 0 ) {
				Bundle params = new Bundle();
				params.putString( "fields", TextUtils.join( ",", fields ) );
				request.setParameters( params );
			}
			request.executeAsync();
		} else {
			AIR.log( "User must be logged in to request Game Requests." );
			AIR.dispatchEvent( AIRFacebookEvent.APP_REQUESTS_ERROR, StringUtils.getEventErrorJSON( mListenerID, "User is not logged in." ) );
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

	private void onAppRequestsResult( GraphResponse response ) {
		AIRFacebookExtensionContext context = AIR.getContext();
		if( response.getError() != null ) {
			AIR.log( "Error requesting user's Game Requests: " + response.getError().getErrorMessage() );
			context.dispatchStatusEventAsync( AIRFacebookEvent.APP_REQUESTS_ERROR,
					StringUtils.getEventErrorJSON( mListenerID, response.getError().getErrorMessage() )
			);
			return;
		}
		/* Only interested in the 'data' value which is JSONArray of app requests */
		JSONArray data = null;
		JSONObject result = null;
		try {
			data = response.getJSONObject().getJSONArray( "data" );
			result = new JSONObject();
			result.put( "gameRequests", data );
			result.put( "listenerID", mListenerID );
		} catch( JSONException e ) {
			AIR.log( "Facebook SDK returned unexpected data for Game Requests request." );
		}
		if( result != null && data != null ) {
			context.dispatchStatusEventAsync( AIRFacebookEvent.APP_REQUESTS_SUCCESS, result.toString() );
		}
		/* Value for key 'data' is missing which is unexpected */
		else {
			context.dispatchStatusEventAsync( AIRFacebookEvent.APP_REQUESTS_ERROR,
					StringUtils.getEventErrorJSON( mListenerID, "Facebook SDK returned unexpected data: " + response.getRawResponse() )
			);
		}
	}

	private GraphRequest.Callback getCallback() {
		if( mAppRequestsCallback == null ) {
			mAppRequestsCallback = new GraphRequest.Callback() {
				@Override
				public void onCompleted( GraphResponse response ) {
					onAppRequestsResult( response );
				}
			};
		}
		return mAppRequestsCallback;
	}

}
