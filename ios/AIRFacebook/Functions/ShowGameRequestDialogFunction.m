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
 
#import "ShowGameRequestDialogFunction.h"
#import <Foundation/Foundation.h>
#import <AIRExtHelpers/MPFREObjectUtils.h>
#import "AIRFacebook.h"
#import "AIRFacebookShareType.h"
#import "ShareContentDelegate.h"

FREObject fb_showGameRequestDialog( FREContext context, void *functionData, uint32_t argc, FREObject *argv ) {
    NSString* message = [MPFREObjectUtils getNSString:argv[0]];
    NSString* actionType = (argv[1] == nil ) ? nil : [MPFREObjectUtils getNSString:argv[1]];
    NSString* title = (argv[2] == nil ) ? nil : [MPFREObjectUtils getNSString:argv[2]];
    NSString* objectID = (argv[3] == nil ) ? nil : [MPFREObjectUtils getNSString:argv[3]];
    NSString* friendsFilter = (argv[4] == nil ) ? nil : [MPFREObjectUtils getNSString:argv[4]];
    NSString* data = (argv[5] == nil ) ? nil : [MPFREObjectUtils getNSString:argv[5]];
    NSArray* suggestedFriends = (argv[6] == nil ) ? nil : [MPFREObjectUtils getNSArray:argv[6]];
    NSArray* recipients = (argv[7] == nil ) ? nil : [MPFREObjectUtils getNSArray:argv[7]];
    int listenerID = [MPFREObjectUtils getInt:argv[8]];

    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    params[@"type"] = [AIRFacebookShareType toString:AIRFBShareType_GAME_REQUEST];
    params[@"message"] = message;
    params[@"listenerID"] = @(listenerID);
    if( actionType ) {
        params[@"actionType"] = actionType;
    }
    if( title ) {
        params[@"title"] = title;
    }
    if( objectID ) {
        params[@"objectID"] = objectID;
    }
    if( friendsFilter ) {
        params[@"friendsFilter"] = friendsFilter;
    }
    if( data ) {
        params[@"data"] = data;
    }
    if( suggestedFriends ) {
        params[@"suggestedFriends"] = suggestedFriends;
    }
    if( recipients ) {
        params[@"recipients"] = recipients;
    }

    /* Call the delegate */
    [[ShareContentDelegate sharedInstance] shareWithParameters:params];

    return nil;
}