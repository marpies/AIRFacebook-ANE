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

#import "AIRFacebook.h"
#import <AIRExtHelpers/MPFREObjectUtils.h>
#import "LogoutConfirmDialogDelegate.h"

#import "Functions/InitFunction.h"
#import "Functions/GetSDKVersionFunction.h"
#import "Functions/IsUserLoggedInFunction.h"
#import "Functions/LoginWithPermissionsFunction.h"
#import "Functions/ApplicationOpenURLFunction.h"
#import "Functions/IsAccessTokenExpiredFunction.h"
#import "Functions/LogoutFunction.h"
#import "Functions/GetUserProfilePictureUriFunction.h"
#import "Functions/GetAccessTokenFunction.h"
#import "Functions/IsPermissionGrantedFunction.h"
#import "Functions/GetGrantedPermissionsFunction.h"
#import "Functions/GetDeniedPermissionsFunction.h"
#import "Functions/RequestExtendedUserProfileFunction.h"
#import "Functions/RequestUserFriendsFunction.h"
#import "Functions/CanShareContentFunction.h"
#import "Functions/GetExpirationTimestampFunction.h"
#import "Functions/ShareLinkFunction.h"
#import "Functions/SharePhotoFunction.h"
#import "Functions/ShareOpenGraphStoryFunction.h"
#import "Functions/CanShowAppInviteDialogFunction.h"
#import "Functions/ShowAppInviteDialogFunction.h"
#import "Functions/CanShowGameRequestDialogFunction.h"
#import "Functions/ShowGameRequestDialogFunction.h"
#import "Functions/SendOpenGraphRequestFunction.h"
#import "Functions/LogEventFunction.h"
#import "Functions/ActivateAppFunction.h"
#import "Functions/DeactivateAppFunction.h"
#import "Functions/FetchDeferredAppLinkFunction.h"
#import "Functions/RequestAppRequestsFunction.h"
#import "Functions/IsInitializedFunction.h"
#import "Functions/IsSupportedFunction.h"

#import <FBSDKCoreKit/FBSDKCoreKit.h>

FREContext airFacebookContext = nil;
static AIRFacebook* airFacebookInstance = nil;
static BOOL airFacebookLogEnabled = NO;
static BOOL isAIRFacebookInit = NO;

@implementation AIRFacebook

@synthesize appID = mAppID;
@synthesize isInitialized = mInitialized;
@synthesize urlSchemeSuffix = mURLSchemeSuffix;

/**
*
* Initialization
*
**/

- (void) initWithAppID:(NSString*) appID urlSchemeSuffix:(NSString*) urlSchemeSuffix showLogs:(BOOL) showLogs {
    if( mInitialized ) return;

    mInitialized = YES;
    mAppID = appID;
    mURLSchemeSuffix = urlSchemeSuffix;
    airFacebookLogEnabled = showLogs;
    isAIRFacebookInit = YES;

    NSMutableString* logMessage = [NSMutableString stringWithString:@"Facebook SDK initialized"];
    [FBSDKSettings setAppID:mAppID];
    if( mURLSchemeSuffix ) {
        [FBSDKSettings setAppURLSchemeSuffix:mURLSchemeSuffix];
        [logMessage appendFormat:@" with URL scheme suffix %@", mURLSchemeSuffix];
    }
    [logMessage appendFormat:@" | v%@", FBSDK_VERSION_STRING];
    [AIRFacebook log:logMessage];
}

/**
*
* Static
*
**/

+ (id) sharedInstance {
    if( airFacebookInstance == nil ) {
        airFacebookInstance = [[AIRFacebook alloc] init];
    }
    return airFacebookInstance;
}

+ (void) dispatchEvent:(const NSString*) eventName {
    [self dispatchEvent:eventName withMessage:@""];
}

+ (void) dispatchEvent:(const NSString*) eventName withMessage:(NSString*) message {
    NSString* messageText = message ? message : @"";
    FREDispatchStatusEventAsync( airFacebookContext, (const uint8_t*) [eventName UTF8String], (const uint8_t*) [messageText UTF8String] );
}

+ (void) log:(const NSString*) message {
    if( airFacebookLogEnabled ) {
        NSLog( @"[AIRFacebook-iOS] %@", message );
    }
}

+ (BOOL) isInitialized {
    return isAIRFacebookInit;
}

@end


/**
*
*
* Context initialization
*
*
**/

void AIRFacebookAddFunction( FRENamedFunction* array, const char* name, FREFunction function, uint32_t* index ) {
    array[(*index)].name = (const uint8_t*) name;
    array[(*index)].functionData = NULL;
    array[(*index)].function = function;
    (*index)++;
}

void AIRFacebookContextInitializer( void* extData,
                                    const uint8_t* ctxType,
                                    FREContext ctx,
                                    uint32_t* numFunctionsToSet,
                                    const FRENamedFunction** functionsToSet ) {
    
    static FRENamedFunction airFacebookExtFunctions[] = {
        { (const uint8_t*) "init", 0, fb_init },
        /* Log (in|out) / tokens */
        { (const uint8_t*) "isUserLoggedIn", 0, fb_isUserLoggedIn },
        { (const uint8_t*) "getAccessToken", 0, fb_getAccessToken },
        { (const uint8_t*) "isAccessTokenExpired", 0, fb_isAccessTokenExpired },
        { (const uint8_t*) "getExpirationTimestamp", 0, fb_getExpirationTimestamp },
        { (const uint8_t*) "loginWithPermissions", 0, fb_loginWithPermissions },
        { (const uint8_t*) "logout", 0, fb_logout },
        /* Permissions */
        { (const uint8_t*) "isPermissionGranted", 0, fb_isPermissionGranted },
        { (const uint8_t*) "getGrantedPermissions", 0, fb_getGrantedPermissions },
        { (const uint8_t*) "getDeniedPermissions", 0, fb_getDeniedPermissions },
        /* User profiles */
        { (const uint8_t*) "getUserProfilePictureUri", 0, fb_getUserProfilePictureUri },
        { (const uint8_t*) "requestExtendedUserProfile", 0, fb_requestExtendedUserProfile },
        /* Graph */
        { (const uint8_t*) "requestUserFriends", 0, fb_requestUserFriends },
        { (const uint8_t*) "sendOpenGraphRequest", 0, fb_sendOpenGraphRequest },
        { (const uint8_t*) "requestAppRequests", 0, fb_requestAppRequests },
        /* Sharing */
        { (const uint8_t*) "canShareContent", 0, fb_canShareContent },
        { (const uint8_t*) "shareLink", 0, fb_shareLink },
        { (const uint8_t*) "sharePhoto", 0, fb_sharePhoto },
        { (const uint8_t*) "shareMessageWithLink", 0, fb_shareLink },
        { (const uint8_t*) "shareMessageWithPhoto", 0, fb_sharePhoto },
        { (const uint8_t*) "shareOpenGraphStory", 0, fb_shareOpenGraphStory },
        { (const uint8_t*) "canShowAppInviteDialog", 0, fb_canShowAppInviteDialog },
        { (const uint8_t*) "showAppInviteDialog", 0, fb_showAppInviteDialog },
        { (const uint8_t*) "canShowGameRequestDialog", 0, fb_canShowGameRequestDialog },
        { (const uint8_t*) "showGameRequestDialog", 0, fb_showGameRequestDialog },
        /* Misc */
        { (const uint8_t*) "logEvent", 0, fb_logEvent },
        { (const uint8_t*) "activateApp", 0, fb_activateApp },
        { (const uint8_t*) "deactivateApp", 0, fb_deactivateApp },
        { (const uint8_t*) "getSDKVersion", 0, fb_getSDKVersion },
        { (const uint8_t*) "fetchDeferredAppLink", 0, fb_fetchDeferredAppLink },
        { (const uint8_t*) "applicationOpenURL", 0, fb_applicationOpenURL },
        { (const uint8_t*) "isInitialized", 0, fb_isInitialized },
        { (const uint8_t*) "isSupported", 0, fb_isSupported }
    };
    
    *numFunctionsToSet = sizeof( airFacebookExtFunctions ) / sizeof( FRENamedFunction );

    *functionsToSet = airFacebookExtFunctions;

    airFacebookContext = ctx;
}

void AIRFacebookContextFinalizer( FREContext ctx ) { }

void AIRFacebookInitializer( void** extDataToSet, FREContextInitializer* ctxInitializerToSet, FREContextFinalizer* ctxFinalizerToSet ) {
    *extDataToSet = NULL;
    *ctxInitializerToSet = &AIRFacebookContextInitializer;
    *ctxFinalizerToSet = &AIRFacebookContextFinalizer;
}

void AIRFacebookFinalizer( void* extData ) { }


