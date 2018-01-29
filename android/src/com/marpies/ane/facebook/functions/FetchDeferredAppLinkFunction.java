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

import android.net.Uri;
import android.text.TextUtils;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREObject;
import com.facebook.FacebookSdk;
import com.facebook.applinks.AppLinkData;
import com.marpies.ane.facebook.data.AIRFacebookEvent;
import com.marpies.ane.facebook.utils.AIR;
import com.marpies.ane.facebook.utils.FREObjectUtils;
import com.marpies.ane.facebook.utils.StringUtils;
import org.json.JSONException;
import org.json.JSONObject;

import java.net.URL;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

public class FetchDeferredAppLinkFunction extends BaseFunction {

	@Override
	public FREObject call( FREContext context, FREObject[] args ) {
		super.call( context, args );

		final int listenerID = FREObjectUtils.getIntFromFREObject( args[0] );

		AppLinkData.fetchDeferredAppLinkData( AIR.getContext().getActivity(), FacebookSdk.getApplicationId(), new AppLinkData.CompletionHandler() {
			@Override
			public void onDeferredAppLinkDataFetched( AppLinkData appLinkData ) {
				Uri targetUri = (appLinkData != null) ? appLinkData.getTargetUri() : null;
				if( targetUri != null ) {
					AIR.log( "Deferred app link: Target url " + targetUri );
					try {
						JSONObject json = new JSONObject();
						json.put( "targetURL", targetUri.toString() );
						/* Try to get query parameters */
						String query = targetUri.getQuery();
						if( query != null ) {
							json.put( "parameters", parametersFromQuery( query ) );
						}
						json.put( "listenerID", listenerID );
						AIR.dispatchEvent( AIRFacebookEvent.DEFERRED_APP_LINK, json.toString() );
					} catch( JSONException e ) {
						e.printStackTrace();
						AIR.dispatchEvent( AIRFacebookEvent.DEFERRED_APP_LINK, StringUtils.getEventErrorJSON(
								listenerID, "Error creating deferred app link data."
						) );
					}
				} else {
					AIR.log( "No deferred app link data found." );
					AIR.dispatchEvent( AIRFacebookEvent.DEFERRED_APP_LINK,
							String.format( StringUtils.locale, "{ \"listenerID\": %d, \"notFound\": \"true\" }", listenerID )
					);
				}
			}
		} );

		return null;
	}

	/**
	 * Gets query parameters separated by comma.
	 * @param query
	 * @return
	 */
	private String parametersFromQuery( String query ) {
		String[] params = query.split( "&" );
		StringBuilder builder = new StringBuilder();
		boolean isFirst = true;
		for( String param : params ) {
			String[] pair = param.split( "=" );
			if( pair.length != 2 ) continue;

        	/* Add comma after previous value */
			if( !isFirst ) builder.append( "," );
			isFirst = false;

			builder.append( pair[0] ); // name
			builder.append( "," );
			builder.append( pair[1] ); // value
		}
		return builder.toString();
	}

}
