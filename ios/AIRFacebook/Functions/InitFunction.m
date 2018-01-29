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
 
#import "InitFunction.h"
#import "AIRFacebookEvent.h"
#import "AIRFacebook.h"
#import <AIRExtHelpers/MPFREObjectUtils.h>
#import "CachedAccessTokenLoader.h"
#import "ProfileTracker.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>
#import <AIRExtHelpers/MPUIApplicationDelegate.h>

FREObject fb_init( FREContext context, void *functionData, uint32_t argc, FREObject *argv ) {
    NSString* appID = [MPFREObjectUtils getNSString:argv[0]];
    NSString* urlSchemeSuffix = (argv[1] == nil) ? nil : [MPFREObjectUtils getNSString:argv[1]];
    BOOL showLogs = [MPFREObjectUtils getBOOL:argv[2]];
    int listenerID = [MPFREObjectUtils getInt:argv[3]];

    [[AIRFacebook sharedInstance] initWithAppID:appID urlSchemeSuffix:urlSchemeSuffix showLogs:showLogs];
    [AIRFacebook dispatchEvent:SDK_INIT];

    /* Start manual profile tracking */
    [ProfileTracker startTracking];
    /* Enable profile updates on access token change */
    [FBSDKProfile enableUpdatesOnAccessTokenChange:YES];
    /* Simulate didFinishLaunch notification so that a cached access token is loaded */
    [[FBSDKApplicationDelegate sharedInstance] application:[UIApplication sharedApplication] didFinishLaunchingWithOptions:[MPUIApplicationDelegate launchOptions]];
    /* Check cached access token */
    [CachedAccessTokenLoader checkAccessToken:listenerID];
    
    return nil;
}
