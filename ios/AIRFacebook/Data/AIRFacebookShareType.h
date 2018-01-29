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

#ifndef AIRFacebook_AIRFacebookShareType____FILEEXTENSION___
#define AIRFacebook_AIRFacebookShareType____FILEEXTENSION___

#import <Foundation/Foundation.h>

typedef enum {
    AIRFBShareType_LINK,
    AIRFBShareType_PHOTO,
    AIRFBShareType_MESSAGE_LINK,
    AIRFBShareType_MESSAGE_PHOTO,
    AIRFBShareType_OPEN_GRAPH,
    AIRFBShareType_APP_INVITE,
    AIRFBShareType_GAME_REQUEST
} AIRFBShareType;

@interface AIRFacebookShareType : NSObject

+ (AIRFBShareType) valueOf:(NSString*) value;
+ (NSString*) toString:(AIRFBShareType) value;

@end

#endif
