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
 
#import "SendOpenGraphRequestFunction.h"
#import <Foundation/Foundation.h>
#import <AIRExtHelpers/MPFREObjectUtils.h>
#import "AIRFacebook.h"
#import "AIRFacebookEvent.h"
#import <AIRExtHelpers/MPStringUtils.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>

FREObject fb_sendOpenGraphRequest( FREContext context, void *functionData, uint32_t argc, FREObject *argv ) {
    [AIRFacebook log:@"sendOpenGraphRequest"];

    NSString* method = [MPFREObjectUtils getNSString:argv[0]];
    NSString* path = [MPFREObjectUtils getNSString:argv[1]];
    NSDictionary* params = nil;
    /* Additional parameters are only applicable to GET and POST requests */
    if( ![method isEqualToString:@"DELETE"] && argc > 2 ) {
        params = (argv[2] == nil) ? nil : [MPFREObjectUtils getNSDictionary:argv[2]];
    }
    /* Listener ID */
    int listenerID = [MPFREObjectUtils getInt:argv[3]];

    NSMutableString* logMessage = [NSMutableString stringWithFormat:@"Sending open graph request '%@' w/ method '%@'", path, method];
    if( params ) {
        [logMessage appendFormat:@" and parameters %@", params];
    }
    [AIRFacebook log:logMessage];

    FBSDKGraphRequest* request = [[FBSDKGraphRequest alloc] initWithGraphPath:path
                                                                   parameters:params
                                                                   HTTPMethod:method];
    [request startWithCompletionHandler:^( FBSDKGraphRequestConnection* connection, id result, NSError* error ) {
        /* Request error */
        if( error ) {
            [AIRFacebook dispatchEvent:OPEN_GRAPH_ERROR
                           withMessage:[MPStringUtils getEventErrorJSONString:listenerID errorMessage:error.localizedDescription]];
        }
        /* Request success */
        else {
            /* Try to parse JSON from the result NSArray/NSDictionary */
            NSError* parseError = nil;
            NSData* jsonData = [NSJSONSerialization dataWithJSONObject:result options:0 error:&parseError];
            /* Error parsing */
            if( !jsonData ) {
                [AIRFacebook log:[NSString stringWithFormat:@"Open Graph request error: %@", parseError.localizedDescription]];
                [AIRFacebook dispatchEvent:OPEN_GRAPH_ERROR
                               withMessage:[MPStringUtils getEventErrorJSONString:listenerID errorMessage:parseError.localizedDescription]];
            }
            /* Successfully parsed */
            else {
                NSString* jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
                [AIRFacebook log:@"Open Graph request success"];
                [AIRFacebook dispatchEvent:OPEN_GRAPH_SUCCESS
                               withMessage:[NSString stringWithFormat:@"%d||%@||%@", listenerID, jsonString, [NSString stringWithFormat:@"%@", result]]];
            }
        }
    }];

    return nil;
}