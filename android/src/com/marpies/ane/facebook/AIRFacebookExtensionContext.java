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

package com.marpies.ane.facebook;

import com.adobe.fre.FREContext;
import com.adobe.fre.FREFunction;
import com.marpies.ane.facebook.functions.*;
import com.marpies.ane.facebook.utils.AIR;

import java.util.HashMap;
import java.util.Map;

public class AIRFacebookExtensionContext extends FREContext {

	@Override
	public Map<String, FREFunction> getFunctions() {
		Map<String, FREFunction> functions = new HashMap<String, FREFunction>();

		functions.put( "init", new InitFunction() );

		/* Log (in|out) / tokens */
		functions.put( "isUserLoggedIn", new IsUserLoggedInFunction() );
		functions.put( "getAccessToken", new GetAccessTokenFunction() );
		functions.put( "isAccessTokenExpired", new IsAccessTokenExpiredFunction() );
		functions.put( "getExpirationTimestamp", new GetExpirationTimestampFunction() );
		functions.put( "loginWithPermissions", new LoginWithPermissionsFunction() );
		functions.put( "logout", new LogoutFunction() );
		/* Permissions */
		functions.put( "isPermissionGranted", new IsPermissionGrantedFunction() );
		functions.put( "getGrantedPermissions", new GetGrantedPermissionsFunction() );
		functions.put( "getDeniedPermissions", new GetDeniedPermissionsFunction() );
		/* User profiles */
		functions.put( "getUserProfilePictureUri", new GetUserProfilePictureUriFunction() );
		functions.put( "requestExtendedUserProfile", new RequestExtendedUserProfileFunction() );
		/* Graph */
		functions.put( "requestUserFriends", new RequestUserFriendsFunction() );
		functions.put( "sendOpenGraphRequest", new SendOpenGraphRequestFunction() );
		functions.put( "requestAppRequests", new RequestAppRequestsFunction() );
		/* Sharing */
		functions.put( "canShareContent", new CanShareContentFunction() );
		functions.put( "shareLink", new ShareLinkFunction() );
		functions.put( "sharePhoto", new SharePhotoFunction() );
		functions.put( "shareMessageWithLink", new ShareLinkFunction() );
		functions.put( "shareMessageWithPhoto", new SharePhotoFunction() );
		functions.put( "shareOpenGraphStory", new ShareOpenGraphStoryFunction() );
		functions.put( "canShowAppInviteDialog", new CanShowAppInviteDialogFunction() );
		functions.put( "showAppInviteDialog", new ShowAppInviteDialogFunction() );
		functions.put( "canShowGameRequestDialog", new CanShowGameRequestDialogFunction() );
		functions.put( "showGameRequestDialog", new ShowGameRequestDialogFunction() );
		/* Misc */
		functions.put( "logEvent", new LogEventFunction() );
		functions.put( "activateApp", new ActivateAppFunction() );
		functions.put( "deactivateApp", new DeactivateAppFunction() );
		functions.put( "fetchDeferredAppLink", new FetchDeferredAppLinkFunction() );
		functions.put( "getSDKVersion", new GetSDKVersionFunction() );
		functions.put( "isInitialized", new IsInitializedFunction() );

		return functions;
	}

	@Override
	public void dispose() {
		AIR.setContext( null );
	}
}
