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

#import "FetchDeferredAppLinkFunction.h"
#import <AIRExtHelpers/MPFREObjectUtils.h>
#import "AIRFacebook.h"
#import <AIRExtHelpers/MPStringUtils.h>
#import "AIRFacebookEvent.h"

#import <Bolts/Bolts.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>

NSDictionary* parametersDictionaryFromQueryString( NSString* queryString ) {
    NSMutableDictionary *md = [NSMutableDictionary dictionary];
    NSArray *queryComponents = [queryString componentsSeparatedByString:@"&"];

    for( NSString *s in queryComponents ) {
        NSArray *pair = [s componentsSeparatedByString:@"="];
        if([pair count] != 2) continue;

        NSString *key = pair[0];
        NSString *value = pair[1];

        md[key] = value;
    }

    return md;
}

NSString* parametersFromQuery(NSString* queryString) {
    NSMutableString * result = [NSMutableString string];
    NSArray *queryComponents = [queryString componentsSeparatedByString:@"&"];
    BOOL isFirst = YES;

    for( NSString *s in queryComponents ) {
        NSArray *pair = [s componentsSeparatedByString:@"="];
        if([pair count] != 2) continue;

        /* Add comma after previous value */
        if( !isFirst ) [result appendString:@","];
        isFirst = NO;

        [result appendFormat:@"%@,", pair[0]]; // name
        [result appendString:pair[1]]; // value
    }

    return result;
}

FREObject fb_fetchDeferredAppLink( FREContext context, void *functionData, uint32_t argc, FREObject *argv ) {
    int listenerID = [MPFREObjectUtils getInt:argv[0]];
    
    [FBSDKAppLinkUtility fetchDeferredAppLink:^(NSURL *url, NSError *error) {
        if (error) {
            [AIRFacebook log:[NSString stringWithFormat:@"Received error while fetching deferred app link %@", error]];
            [AIRFacebook dispatchEvent:DEFERRED_APP_LINK withMessage:[MPStringUtils getEventErrorJSONString:listenerID errorMessage:error.localizedDescription]];
        } else if (url) {
            [AIRFacebook log:[NSString stringWithFormat:@"Received deferred app link %@", url]];
            NSMutableDictionary* result = [NSMutableDictionary dictionary];
            result[@"listenerID"] = @(listenerID);
            result[@"targetURL"] = url.absoluteString;
            NSString* query = url.query;
            if( query ) {
                NSString* urlParams = parametersFromQuery( query );
                [AIRFacebook log:[NSString stringWithFormat:@"Deferred app link parsed URL params %@", urlParams]];
                result[@"parameters"] = urlParams;
            }
            [AIRFacebook log:[NSString stringWithFormat:@"Final result %@", result]];
            /* Get JSON string from the result */
            NSString* jsonString = [MPStringUtils getJSONString:result];
            if( jsonString ) {
                [AIRFacebook dispatchEvent:DEFERRED_APP_LINK withMessage:jsonString];
            } else {
                [AIRFacebook dispatchEvent:DEFERRED_APP_LINK withMessage:[MPStringUtils getEventErrorJSONString:listenerID errorMessage:@"Error creating deferred app link data."]];
            }
        } else {
            [AIRFacebook log:@"No deferred app link data found."];
            [AIRFacebook dispatchEvent:DEFERRED_APP_LINK withMessage:
                    [MPStringUtils getSingleValueJSONString:listenerID key:@"notFound" value:@"true"]
            ];
        }
    }];

    return nil;
}