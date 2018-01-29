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
 
#import "ShareLinkFunction.h"
#import <Foundation/Foundation.h>
#import <AIRExtHelpers/MPFREObjectUtils.h>
#import "AIRFacebookShareType.h"
#import "AIRFacebook.h"
#import "ShareContentDelegate.h"

FREObject fb_shareLink( FREContext context, void *functionData, uint32_t argc, FREObject *argv ) {
    NSString* contentURL = [MPFREObjectUtils getNSString:argv[0]];
    BOOL withoutUI = [MPFREObjectUtils getBOOL:argv[1]];
    BOOL useMessengerApp = [MPFREObjectUtils getBOOL:argv[2]];
    NSString* message = (argv[3] == nil ) ? nil : [MPFREObjectUtils getNSString:argv[3]];
    int listenerID = [MPFREObjectUtils getInt:argv[4]];

    /* Create parameters for the delegate */
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    AIRFBShareType shareType = useMessengerApp ? AIRFBShareType_MESSAGE_LINK : AIRFBShareType_LINK;
    params[@"type"] = [AIRFacebookShareType toString:shareType];
    params[@"contentURL"] = contentURL;
    params[@"withoutUI"] = @(withoutUI);
    params[@"listenerID"] = @(listenerID);
    if( message ) {
        params[@"message"] = message;
    }

    /* Call the delegate */
    [[ShareContentDelegate sharedInstance] shareWithParameters:params];

    return nil;
}
