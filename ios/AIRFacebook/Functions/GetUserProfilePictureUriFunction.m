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
 
#import "GetUserProfilePictureUriFunction.h"
#import <Foundation/Foundation.h>
#import <AIRExtHelpers/MPFREObjectUtils.h>
#import <FBSDKCoreKit/FBSDKCoreKit.h>

FREObject fb_getUserProfilePictureUri( FREContext context, void *functionData, uint32_t argc, FREObject *argv ) {
    FBSDKProfile* profile = [FBSDKProfile currentProfile];
    if( profile ) {
        int32_t width = [MPFREObjectUtils getInt:argv[0]];
        int32_t height = [MPFREObjectUtils getInt:argv[1]];
        NSString* openGraphPath = [profile imageURLForPictureMode:FBSDKProfilePictureModeNormal size:CGSizeMake(width, height)].absoluteString;
        return [MPFREObjectUtils getFREObjectFromNSString:openGraphPath];
    }
    return nil;
}