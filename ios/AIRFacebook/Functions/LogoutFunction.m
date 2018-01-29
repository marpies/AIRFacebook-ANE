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
 
#import "LogoutFunction.h"
#import <AIRExtHelpers/MPFREObjectUtils.h>
#import "AIRFacebook.h"
#import "AIRFacebookEvent.h"
#import "LogoutConfirmDialogDelegate.h"
#import <AIRExtHelpers/MPStringUtils.h>
#import <FBSDKLoginKit/FBSDKLoginKit.h>

FREObject fb_logout( FREContext context, void *functionData, uint32_t argc, FREObject *argv ) {
    BOOL confirmDialog = [MPFREObjectUtils getBOOL:argv[0]];
    int listenerID = [MPFREObjectUtils getInt:argv[5]];
    
    if( confirmDialog ) {
        [LogoutConfirmDialogDelegate showConfirmDialogWithTitle:[MPFREObjectUtils getNSString:argv[1]]
                                                        message:[MPFREObjectUtils getNSString:argv[2]]
                                                   confirmLabel:[MPFREObjectUtils getNSString:argv[3]]
                                                    cancelLabel:[MPFREObjectUtils getNSString:argv[4]]
                                                     listenerID:listenerID];
    } else {
        performLogout( listenerID );
    }

    return nil;
}

void performLogout( int listenerID ) {
    [AIRFacebook log:@"Logging out..."];
    FBSDKLoginManager* loginManager = [[FBSDKLoginManager alloc] init];
    [loginManager logOut];
    [AIRFacebook dispatchEvent:LOGOUT_SUCCESS withMessage:[MPStringUtils getListenerJSONString:listenerID]];
}