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
 
#import "RequestUserFriendsFunction.h"
#import <Foundation/Foundation.h>
#import <AIRExtHelpers/MPFREObjectUtils.h>
#import "AIRFacebook.h"
#import "AIRFacebookEvent.h"
#import <AIRExtHelpers/MPStringUtils.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>

FREObject fb_requestUserFriends( FREContext context, void *functionData, uint32_t argc, FREObject *argv ) {
    [AIRFacebook log:@"requestUserFriends"];

    int listenerID = [MPFREObjectUtils getInt:argv[1]];

    FBSDKAccessToken* accessToken = [FBSDKAccessToken currentAccessToken];
    /* Request the profile only if we have valid access token */
    if( accessToken ) {
        NSArray* fields = (argv[0] == nil) ? nil : [MPFREObjectUtils getNSArray:argv[0]];
        NSDictionary* params = nil;
        if( fields && fields.count > 0 ) {
            params = @{@"fields" : [fields componentsJoinedByString:@","]};
        }
        FBSDKGraphRequest* request = [[FBSDKGraphRequest alloc] initWithGraphPath:@"me/friends" parameters:params];
        [request startWithCompletionHandler:^( FBSDKGraphRequestConnection* connection, id result, NSError* error ) {
            /* Request error */
            if( error ) {
                [AIRFacebook log:[NSString stringWithFormat:@"User friends request - error: %@", error.localizedDescription]];
                [AIRFacebook dispatchEvent:USER_FRIENDS_REQUEST_ERROR withMessage:
                        [MPStringUtils getEventErrorJSONString:listenerID errorMessage:error.localizedDescription]
                ];
            }
            /* Request success */
            else {
                /* Get the 'data' value from the NSDictionary */
                id data = [result valueForKey:@"data"];
                /* Only interested in the 'data' value which is NSArray of friends */
                if( data ) {
                    /* Try to parse JSON from the result NSArray */
                    NSError* parseError = nil;
                    /* Create dictionary with the listenerID and the array of friends, then create JSON out of that */
                    NSMutableDictionary* resultJSON = [NSMutableDictionary dictionaryWithDictionary:result];
                    resultJSON[@"listenerID"] = @(listenerID);
                    resultJSON[@"friends"] = data;
                    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:resultJSON options:nil error:&parseError];
                    /* Error parsing */
                    if( !jsonData ) {
                        [AIRFacebook log:[NSString stringWithFormat:@"User friends request - error: %@", parseError.localizedDescription]];
                        [AIRFacebook dispatchEvent:USER_FRIENDS_REQUEST_ERROR withMessage:
                                [MPStringUtils getEventErrorJSONString:listenerID errorMessage:parseError.localizedDescription]
                        ];
                    }
                    /* Successfully parsed */
                    else {
                        NSString* jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                        [AIRFacebook log:@"User friends request - success"];
                        [AIRFacebook dispatchEvent:USER_FRIENDS_LOADED withMessage:jsonString];
                    }
                }
                /* Value for key 'data' is missing which is unexpected */
                else {
                    [AIRFacebook log:@"User friends request - error: Facebook SDK returned unexpected data."];
                    [AIRFacebook dispatchEvent:USER_FRIENDS_REQUEST_ERROR withMessage:
                            [MPStringUtils getEventErrorJSONString:listenerID errorMessage:@"Facebook SDK returned unexpected data."]
                    ];
                }
            }
        }];
    }
    /* Otherwise dispatch error event that user is not logged in */
    else {
        [AIRFacebook log:@"User must be logged in to request friends."];
        [AIRFacebook dispatchEvent:USER_FRIENDS_REQUEST_ERROR withMessage:
                [MPStringUtils getEventErrorJSONString:listenerID errorMessage:@"User is not logged in."]
        ];
    }

    return nil;
}