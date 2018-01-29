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

#import "LogoutConfirmDialogDelegate.h"
#import "AIRFacebook.h"
#import "AIRFacebookEvent.h"
#import "LogoutFunction.h"
#import <AIRExtHelpers/MPStringUtils.h>

static int mListenerID = -1;

@implementation LogoutConfirmDialogDelegate

+ (void) showConfirmDialogWithTitle:(NSString*) title
                            message:(NSString*) message
                       confirmLabel:(NSString*) confirmLabel
                        cancelLabel:(NSString*) cancelLabel
                         listenerID:(int) listenerID {
    mListenerID = listenerID;

    [AIRFacebook log:@"Showing log out confirmation dialog."];
    
    /* iOS 8+ alert */
    if( NSFoundationVersionNumber > NSFoundationVersionNumber_iOS_7_1 ) {
        UIAlertController* ac = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];
        [ac addAction:[UIAlertAction actionWithTitle:cancelLabel style:UIAlertActionStyleCancel handler:^(UIAlertAction *action) {
            [AIRFacebook log:@"Log out cancelled."];
            [AIRFacebook dispatchEvent:LOGOUT_CANCEL withMessage:[MPStringUtils getListenerJSONString:mListenerID]];
        }]];
        [ac addAction:[UIAlertAction actionWithTitle:confirmLabel style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
            performLogout( mListenerID );
        }]];
        [[[[[UIApplication sharedApplication] delegate] window] rootViewController]presentViewController:ac animated:YES completion:nil];
    }
    /* iOS 7 alert */
    else {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:title
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:cancelLabel
                                              otherButtonTitles:confirmLabel, nil];
        [alert show];
    }
}

+ (void) alertView:(UIAlertView *) alertView clickedButtonAtIndex:(NSInteger) buttonIndex {
    BOOL logoutConfirmed = buttonIndex == 1;
    if( logoutConfirmed ) {
        performLogout( mListenerID );
    } else {
        [AIRFacebook log:@"Log out cancelled."];
        [AIRFacebook dispatchEvent:LOGOUT_CANCEL withMessage:[MPStringUtils getListenerJSONString:mListenerID]];
    }
}

@end
