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
 
#import "ShareOpenGraphStoryFunction.h"
#import <Foundation/Foundation.h>
#import <AIRExtHelpers/MPFREObjectUtils.h>
#import "AIRFacebookShareType.h"
#import "AIRFacebook.h"
#import "ShareContentDelegate.h"
#import <AIRExtHelpers/MPBitmapDataUtils.h>

FREObject fb_shareOpenGraphStory( FREContext context, void *functionData, uint32_t argc, FREObject *argv ) {
    NSString* actionType = [MPFREObjectUtils getNSString:argv[0]];
    NSString* objectType = [MPFREObjectUtils getNSString:argv[1]];
    NSString* title = [MPFREObjectUtils getNSString:argv[2]];
    NSDictionary* objectProperties = (argv[4] == nil) ? nil : [MPFREObjectUtils getNSDictionary:argv[4]];
    int listenerID = [MPFREObjectUtils getInt:argv[5]];

    /* Create parameters for the delegate */
    NSMutableDictionary * params = [[NSMutableDictionary alloc] init];
    params[@"type"] = [AIRFacebookShareType toString:AIRFBShareType_OPEN_GRAPH];
    params[@"actionType"] = actionType;
    params[@"objectType"] = objectType;
    params[@"title"] = title;
    params[@"listenerID"] = @(listenerID);
    if( objectProperties ) {
        params[@"objectProperties"] = objectProperties;
    }

    FREObject imageObject = argv[3];
    if( imageObject != nil ) {
        FREBitmapData2 bitmapData;
        NSString* imageURL = nil;
        /* Check if passed object is BitmapData or String */
        if( FREAcquireBitmapData2( imageObject, &bitmapData ) == FRE_OK ) {
            params[@"image"] = [MPBitmapDataUtils getUIImageFromFREBitmapData:bitmapData];
            FREReleaseBitmapData( imageObject );
        } else {
            imageURL = [MPFREObjectUtils getNSString:imageObject];
            params[@"imageURL"] = imageURL;
        }
    }

    /* Call the delegate */
    [[ShareContentDelegate sharedInstance] shareWithParameters:params];

    return nil;
}