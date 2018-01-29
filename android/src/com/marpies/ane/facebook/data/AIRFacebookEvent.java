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

package com.marpies.ane.facebook.data;

public class AIRFacebookEvent {

	public static final String LOGIN_SUCCESS = "loginSuccess";
	public static final String LOGIN_ERROR = "loginError";
	public static final String LOGIN_CANCEL = "loginCancel";

	public static final String LOGOUT_ERROR = "logoutError";
	public static final String LOGOUT_CANCEL = "logoutCancel";
	public static final String LOGOUT_SUCCESS = "logoutSuccess";

	public static final String BASIC_PROFILE_READY = "basicProfileReady";
	public static final String EXTENDED_PROFILE_LOADED = "extendedProfileLoaded";
	public static final String EXTENDED_PROFILE_REQUEST_ERROR = "extendedProfileRequestError";

	public static final String USER_FRIENDS_LOADED = "userFriendsLoaded";
	public static final String USER_FRIENDS_REQUEST_ERROR = "userFriendsRequestError";

	public static final String SHARE_SUCCESS = "shareSuccess";
	public static final String SHARE_ERROR = "shareError";
	public static final String SHARE_CANCEL = "shareCancel";

	public static final String GAME_REQUEST_SUCCESS = "gameRequestSuccess";
	public static final String GAME_REQUEST_ERROR = "gameRequestError";
	public static final String GAME_REQUEST_CANCEL = "gameRequestCancel";

	public static final String OPEN_GRAPH_SUCCESS = "openGraphSuccess";
	public static final String OPEN_GRAPH_ERROR = "openGraphError";

	public static final String APP_REQUESTS_ERROR = "appRequestsError";
	public static final String APP_REQUESTS_SUCCESS = "appRequestsSuccess";

	public static final String CACHED_ACCESS_TOKEN_LOADED = "cachedAccessTokenLoaded";

	public static final String DEFERRED_APP_LINK = "deferredAppLink";

	public static final String SDK_INIT = "sdkInit";

}
