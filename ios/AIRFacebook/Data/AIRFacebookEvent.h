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

#ifndef AIRFacebook_AIRFacebookEvent_h
#define AIRFacebook_AIRFacebookEvent_h

#import <Foundation/Foundation.h>

static const NSString* LOGIN_ERROR = @"loginError";
static const NSString* LOGIN_CANCEL = @"loginCancel";
static const NSString* LOGIN_SUCCESS = @"loginSuccess";

static const NSString* LOGOUT_ERROR = @"logoutError";
static const NSString* LOGOUT_CANCEL = @"logoutCancel";
static const NSString* LOGOUT_SUCCESS = @"logoutSuccess";

static const NSString* BASIC_PROFILE_READY = @"basicProfileReady";
static const NSString* EXTENDED_PROFILE_LOADED = @"extendedProfileLoaded";
static const NSString* EXTENDED_PROFILE_REQUEST_ERROR = @"extendedProfileRequestError";

static const NSString* USER_FRIENDS_LOADED = @"userFriendsLoaded";
static const NSString* USER_FRIENDS_REQUEST_ERROR = @"userFriendsRequestError";

static const NSString* SHARE_ERROR = @"shareError";
static const NSString* SHARE_CANCEL = @"shareCancel";
static const NSString* SHARE_SUCCESS = @"shareSuccess";

static const NSString* GAME_REQUEST_ERROR = @"gameRequestError";
static const NSString* GAME_REQUEST_CANCEL = @"gameRequestCancel";
static const NSString* GAME_REQUEST_SUCCESS = @"gameRequestSuccess";

static const NSString* OPEN_GRAPH_ERROR = @"openGraphError";
static const NSString* OPEN_GRAPH_SUCCESS = @"openGraphSuccess";

static const NSString* APP_REQUESTS_ERROR = @"appRequestsError";
static const NSString* APP_REQUESTS_SUCCESS = @"appRequestsSuccess";

static const NSString* CACHED_ACCESS_TOKEN_LOADED = @"cachedAccessTokenLoaded";

static const NSString* DEFERRED_APP_LINK = @"deferredAppLink";

static const NSString* SDK_INIT = @"sdkInit";

#endif
