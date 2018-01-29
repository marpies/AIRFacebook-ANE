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
 
#import "SharePhotoFunction.h"
#import <Foundation/Foundation.h>
#import <AIRExtHelpers/MPFREObjectUtils.h>
#import "AIRFacebookShareType.h"
#import "AIRFacebook.h"
#import "ShareContentDelegate.h"
#import <AIRExtHelpers/MPBitmapDataUtils.h>

FREObject fb_sharePhoto( FREContext context, void *functionData, uint32_t argc, FREObject *argv ) {
    BOOL isUserGenerated = [MPFREObjectUtils getBOOL:argv[1]];
    BOOL withoutUI = [MPFREObjectUtils getBOOL:argv[2]];
    BOOL useMessengerApp = [MPFREObjectUtils getBOOL:argv[3]];
    NSString* message = (argv[4] == nil ) ? nil : [MPFREObjectUtils getNSString:argv[4]];
    int listenerID = [MPFREObjectUtils getInt:argv[5]];

    /* Create parameters for the delegate */
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    AIRFBShareType shareType = useMessengerApp ? AIRFBShareType_MESSAGE_PHOTO : AIRFBShareType_PHOTO;
    params[@"type"] = [AIRFacebookShareType toString:shareType];
    params[@"withoutUI"] = @(withoutUI);
    params[@"isUserGenerated"] = @(isUserGenerated);
    params[@"listenerID"] = @(listenerID);

    FREObject imageObject = argv[0];
    FREBitmapData2 bitmapData;
    NSString* imageURL = nil;
    /* Check if passed object is BitmapData or String */
    if( FREAcquireBitmapData2( imageObject, &bitmapData ) == FRE_OK ) {
        params[@"photo"] = [MPBitmapDataUtils getUIImageFromFREBitmapData:bitmapData];
        FREReleaseBitmapData( imageObject );
    } else {
        imageURL = [MPFREObjectUtils getNSString:imageObject];
        params[@"imageURL"] = imageURL;
    }
    if( message ) {
        params[@"message"] = message;
    }

    /* Call the delegate */
    [[ShareContentDelegate sharedInstance] shareWithParameters:params];

    return nil;
}
