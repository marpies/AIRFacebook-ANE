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
 
#import "LogEventFunction.h"
#import <Foundation/Foundation.h>
#import <AIRExtHelpers/MPFREObjectUtils.h>
#import "AIRFacebook.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>

FREObject fb_logEvent( FREContext context, void *functionData, uint32_t argc, FREObject *argv ) {
    NSString* eventName = [MPFREObjectUtils getNSString:argv[0]];
    NSDictionary* params = (argv[1] == nil) ? nil : [MPFREObjectUtils getNSDictionary:argv[1]];
    double valueToSum = [MPFREObjectUtils getDouble:argv[2]];

    if( params != nil ) {
        if( valueToSum == 0.0 ) {
            [AIRFacebook log:[NSString stringWithFormat:@"Logging event %@ with params %@", eventName, params]];
            [FBSDKAppEvents logEvent:eventName parameters:params];
        } else {
            [AIRFacebook log:[NSString stringWithFormat:@"Logging event %@ with params %@ and valueToSum %f", eventName, params, valueToSum]];
            [FBSDKAppEvents logEvent:eventName valueToSum:valueToSum parameters:params];
        }
    } else {
        if( valueToSum == 0.0 ) {
            [AIRFacebook log:[NSString stringWithFormat:@"Logging event %@", eventName]];
            [FBSDKAppEvents logEvent:eventName];
        } else {
            [AIRFacebook log:[NSString stringWithFormat:@"Logging event %@ and valueToSum %f", eventName, valueToSum]];
            [FBSDKAppEvents logEvent:eventName valueToSum:valueToSum];
        }
    }

    [FBSDKAppEvents flush];

    return nil;
}