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

package com.marpies.ane.facebook.utils;

import android.os.Handler;
import com.facebook.AccessToken;
import com.facebook.Profile;
import com.marpies.ane.facebook.data.AIRFacebookEvent;

public class CachedAccessTokenLoader {

	private static final int NUMBER_OF_CHECKS = 10;
	private static int checkCount = 0;
	private static int mListenerID;

	public static void load( int listenerID ) {
		mListenerID = listenerID;
		load( false );
	}

	private static void load( boolean force ) {
		checkCount++;
		if( !force && (checkCount > NUMBER_OF_CHECKS) ) {
			AIR.dispatchEvent( AIRFacebookEvent.CACHED_ACCESS_TOKEN_LOADED,
					StringUtils.getSingleValueJSONString( mListenerID, "found", "false" )
			);
			return;
		}

		new Handler().postDelayed( new Runnable() {
			@Override
			public void run() {

				AccessToken accessToken = AccessToken.getCurrentAccessToken();
				/* Dispatch event about basic user's profile being ready */
				if( accessToken != null ) {
					Profile profile = Profile.getCurrentProfile();
					if( !accessToken.isExpired() ) {
						if( profile != null ) {
							AIR.dispatchEvent( AIRFacebookEvent.CACHED_ACCESS_TOKEN_LOADED,
									StringUtils.getSingleValueJSONString( mListenerID, "found", "true" )
							);
						} else {
							load( true );
						}
					}
					/* Token is expired */
					else {
						AIR.dispatchEvent( AIRFacebookEvent.CACHED_ACCESS_TOKEN_LOADED,
								StringUtils.getSingleValueJSONString( mListenerID, "found", "false" )
						);
					}
				}
				/* Try again */
				else {
					load( false );
				}

			}
		}, 2 );
	}

}
