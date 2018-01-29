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

#import "AIRFacebookShareType.h"

@implementation AIRFacebookShareType : NSObject

+ (AIRFBShareType) valueOf:(NSString*) value {
    if( [value isEqualToString:@"LINK"] ) {
        return AIRFBShareType_LINK;
    }
    if( [value isEqualToString:@"PHOTO"] ) {
        return AIRFBShareType_PHOTO;
    }
    if( [value isEqualToString:@"MESSAGE_LINK"] ) {
        return AIRFBShareType_MESSAGE_LINK;
    }
    if( [value isEqualToString:@"MESSAGE_PHOTO"] ) {
        return AIRFBShareType_MESSAGE_PHOTO;
    }
    if( [value isEqualToString:@"OPEN_GRAPH"] ) {
        return AIRFBShareType_OPEN_GRAPH;
    }
    if( [value isEqualToString:@"APP_INVITE"] ) {
        return AIRFBShareType_APP_INVITE;
    }
    if( [value isEqualToString:@"GAME_REQUEST"] ) {
        return AIRFBShareType_GAME_REQUEST;
    }
    return AIRFBShareType_LINK;
}

+ (NSString*) toString:(AIRFBShareType) value {
    switch( value ) {
        case AIRFBShareType_LINK:
            return @"LINK";
        case AIRFBShareType_PHOTO:
            return @"PHOTO";
        case AIRFBShareType_MESSAGE_LINK:
            return @"MESSAGE_LINK";
        case AIRFBShareType_MESSAGE_PHOTO:
            return @"MESSAGE_PHOTO";
        case AIRFBShareType_OPEN_GRAPH:
            return @"OPEN_GRAPH";
        case AIRFBShareType_APP_INVITE:
            return @"APP_INVITE";
        case AIRFBShareType_GAME_REQUEST:
            return @"GAME_REQUEST";
    }
    return @"";
}


@end
