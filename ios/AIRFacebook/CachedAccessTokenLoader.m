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

#import "CachedAccessTokenLoader.h"
#import "IsAccessTokenExpiredFunction.h"
#import "AIRFacebook.h"
#import "AIRFacebookEvent.h"
#import <AIRExtHelpers/MPStringUtils.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>

@implementation CachedAccessTokenLoader

+ (void) checkAccessToken:(int) listenerID {
    FBSDKAccessToken* accessToken = [FBSDKAccessToken currentAccessToken];
    /* Check if token is not expired */
    if( accessToken && !isAccessTokenExpiredBOOL() ) {
        [AIRFacebook log:@"CachedAccessTokenLoader - access token found."];
        [AIRFacebook dispatchEvent:CACHED_ACCESS_TOKEN_LOADED withMessage:
                     [MPStringUtils getSingleValueJSONString:listenerID key:@"found" value:@"true"]
        ];
    }
    /* Access token is either expired or not cached */
    else {
        [AIRFacebook log:@"CachedAccessTokenLoader - access token not found."];
        [AIRFacebook dispatchEvent:CACHED_ACCESS_TOKEN_LOADED withMessage:
                [MPStringUtils getSingleValueJSONString:listenerID key:@"found" value:@"false"]
        ];
    }
}

@end
