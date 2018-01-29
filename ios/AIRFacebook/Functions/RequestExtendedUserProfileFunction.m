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
 
#import "RequestExtendedUserProfileFunction.h"
#import <Foundation/Foundation.h>
#import <AIRExtHelpers/MPFREObjectUtils.h>
#import "AIRFacebook.h"
#import "AIRFacebookEvent.h"
#import <AIRExtHelpers/MPStringUtils.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>

FREObject fb_requestExtendedUserProfile( FREContext context, void *functionData, uint32_t argc, FREObject *argv ) {
    int listenerID = [MPFREObjectUtils getInt:argv[1]];

    FBSDKAccessToken* accessToken = [FBSDKAccessToken currentAccessToken];
    /* Request the profile only if we have valid access token */
    if( accessToken ) {
        NSArray* fields = (argv[0] == nil) ? nil : [MPFREObjectUtils getNSArray:argv[0]];
        NSDictionary* params = nil;
        if( fields && fields.count > 0 ) {
            params = @{@"fields" : [fields componentsJoinedByString:@","]};
        }
        FBSDKGraphRequest* request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me" parameters:params];
        [request startWithCompletionHandler:^( FBSDKGraphRequestConnection* connection, id result, NSError* error ) {
            /* Request error */
            if( error ) {
                [AIRFacebook log:[NSString stringWithFormat:@"Extended profile request - callback error: %@", error.localizedDescription]];
                [AIRFacebook dispatchEvent:EXTENDED_PROFILE_REQUEST_ERROR withMessage:
                        [MPStringUtils getEventErrorJSONString:listenerID errorMessage:error.localizedDescription]
                ];
            }
            /* Request success */
            else {
                /* Try to parse JSON from the result NSDictionary */
                NSError* parseError = nil;
                /* Add listener ID to the JSON */
                NSMutableDictionary* resultJSON = [NSMutableDictionary dictionaryWithDictionary:result];
                resultJSON[@"listenerID"] = @(listenerID);
                NSData* jsonData = [NSJSONSerialization dataWithJSONObject:resultJSON options:0 error:&parseError];
                /* Error parsing */
                if( !jsonData ) {
                    [AIRFacebook log:[NSString stringWithFormat:@"Extended profile request - error: %@", parseError.localizedDescription]];
                    [AIRFacebook dispatchEvent:EXTENDED_PROFILE_REQUEST_ERROR withMessage:
                            [MPStringUtils getEventErrorJSONString:listenerID errorMessage:@"Error parsing returned user data."]
                    ];
                }
                /* Successfully parsed */
                else {
                    NSString* jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                    [AIRFacebook log:@"Extended profile request - success"];
                    [AIRFacebook dispatchEvent:EXTENDED_PROFILE_LOADED withMessage:jsonString];
                }
            }
        }];
    }
    /* Otherwise dispatch error event that user is not logged in */
    else {
        [AIRFacebook log:@"User must be logged in to request extended user info."];
        [AIRFacebook dispatchEvent:EXTENDED_PROFILE_REQUEST_ERROR withMessage:
                [MPStringUtils getEventErrorJSONString:listenerID errorMessage:@"User is not logged in."]
        ];
    }

    return nil;
}