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

import com.facebook.Profile;
import com.facebook.ProfileTracker;
import com.marpies.ane.facebook.AIRFacebookExtensionContext;
import com.marpies.ane.facebook.data.AIRFacebookEvent;
import org.json.JSONException;
import org.json.JSONObject;

public class AIRFacebookProfileTracker {

	private static ProfileTracker mProfileTracker;

	public static void startTracking() {
		if( mProfileTracker == null ) {
			mProfileTracker = new ProfileTracker() {
				@Override
				protected void onCurrentProfileChanged( Profile oldProfile, Profile currentProfile ) {
					onProfileChanged( oldProfile, currentProfile );
				}
			};
		}
		/* isTracking is checked internally, no need to do that here */
		mProfileTracker.startTracking();
	}

	public static void stopTracking() {
		/* !isTracking is checked internally, no need to do that here */
		mProfileTracker.stopTracking();
	}

	private static void onProfileChanged( Profile oldProfile, Profile currentProfile ) {
		if( currentProfile != null ) {
			AIRFacebookExtensionContext context = AIR.getContext();
			if( context != null ) {
				JSONObject jsonObject = new JSONObject();
				try {
					jsonObject.put( "id", currentProfile.getId() );
					jsonObject.put( "first_name", currentProfile.getFirstName() );
					jsonObject.put( "middle_name", currentProfile.getMiddleName() );
					jsonObject.put( "last_name", currentProfile.getLastName() );
					jsonObject.put( "name", currentProfile.getName() );
					if( currentProfile.getLinkUri() != null ) {
						jsonObject.put( "link_uri", currentProfile.getLinkUri().toString() );
					}
					context.dispatchStatusEventAsync( AIRFacebookEvent.BASIC_PROFILE_READY, jsonObject.toString() );
				} catch( JSONException e ) {
					e.printStackTrace();
					AIR.log( "Error parsing basic user profile." );
				}
				stopTracking();
			} else {
				AIR.log( "ANE CONTEXT IS NULL WHEN TRACKING PROFILE CHANGE" );
			}
		}
	}

}
