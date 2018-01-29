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

#import "LoginWithPermissionsFunction.h"
#import <Foundation/Foundation.h>
#import <AIRExtHelpers/MPFREObjectUtils.h>
#import "AIRFacebook.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>
#import "AIRFacebookEvent.h"
#import "ProfileTracker.h"
#import <AIRExtHelpers/MPStringUtils.h>

void loginManagerCallback( FBSDKLoginManagerLoginResult* result, NSError* error, int i );

FREObject fb_loginWithPermissions( FREContext context, void *functionData, uint32_t argc, FREObject *argv ) {
    NSArray* permissions = (argv[0] == nil) ? nil : [MPFREObjectUtils getNSArray:argv[0]];
    NSString* permissionType = [MPFREObjectUtils getNSString:argv[1]]; // Either READ or PUBLISH
    int listenerID = [MPFREObjectUtils getInt:argv[2]];

    NSMutableString* logMessage = [NSMutableString stringWithFormat:@"Logging in with type %@", permissionType];
    if( permissions ) {
        [logMessage appendFormat:@" with permissions %@", permissions];
    } else {
        [logMessage appendString:@" without specified permissions"];
    }
    [AIRFacebook log:logMessage];

    /* Start profile tracking */
    [ProfileTracker startTracking];

    FBSDKLoginManager* loginManager = [[FBSDKLoginManager alloc] init];
    /* Login with Read */
    if( [permissionType isEqualToString:@"READ"] ) {
        [loginManager logInWithReadPermissions:permissions
                            fromViewController:[[[[UIApplication sharedApplication] delegate] window] rootViewController]
                                       handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                                           loginManagerCallback( result, error, listenerID );
                                       }];
    }
    /* Login with Publish */
    else {
        [loginManager logInWithPublishPermissions:permissions
                               fromViewController:[[[[UIApplication sharedApplication] delegate] window] rootViewController]
                                          handler:^(FBSDKLoginManagerLoginResult *result, NSError *error) {
                                              loginManagerCallback( result, error, listenerID );
                                          }];
    }

    return nil;
}

void loginManagerCallback( FBSDKLoginManagerLoginResult* result, NSError* error, int listenerID ) {
    if( error ) {
        [AIRFacebook log:[NSString stringWithFormat:@"Login callback - error %@", error.localizedDescription]];
        [AIRFacebook dispatchEvent:LOGIN_ERROR withMessage:[MPStringUtils getEventErrorJSONString:listenerID errorMessage:error.localizedDescription]];
    } else if( result.isCancelled ) {
        [AIRFacebook log:@"Login callback - cancelled"];
        [AIRFacebook dispatchEvent:LOGIN_CANCEL withMessage:[MPStringUtils getListenerJSONString:listenerID]];
    } else {
        [AIRFacebook log:@"Login callback - successful"];
        NSArray* grantedPermissions = [[result grantedPermissions] allObjects];
        NSArray* declinedPermissions = [[result declinedPermissions] allObjects];
        [AIRFacebook dispatchEvent:LOGIN_SUCCESS withMessage:[NSString stringWithFormat:
                @"{ \"granted_permissions\": \"%@\", \"denied_permissions\": \"%@\", \"access_token\": \"%@\", \"listenerID\": %d }",
                [NSString stringWithFormat:@"[%@]", [grantedPermissions componentsJoinedByString:@","]],
                [NSString stringWithFormat:@"[%@]", [declinedPermissions componentsJoinedByString:@","]],
                [[FBSDKAccessToken currentAccessToken] tokenString],
                listenerID
        ]];
    }
}
