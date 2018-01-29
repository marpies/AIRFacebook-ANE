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

#import "ProfileTracker.h"
#import "AIRFacebook.h"
#import "AIRFacebookEvent.h"
#import <FBSDKCoreKit/FBSDKCoreKit.h>

static BOOL mAddedObserver = NO;

@implementation ProfileTracker

+ (void)startTracking {
    if( !mAddedObserver ) {
        mAddedObserver = YES;
        /* Listen to profile changes so we can dispatch profile ready event */
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onFacebookProfileChange:) name:FBSDKProfileDidChangeNotification object:nil];
    }
}

+ (void)stopTracking {
    if( mAddedObserver ) {
        mAddedObserver = NO;
        /* Remove observer */
        [[NSNotificationCenter defaultCenter] removeObserver:self];
    }
}

+ (void) onFacebookProfileChange:(NSNotification*) notification {
    id newProfile = [[notification userInfo] valueForKey:FBSDKProfileChangeNewKey];
    if( newProfile ) {
        /* Build profile JSON */
        NSString* json = [NSString stringWithFormat:
                @"{ \
                      \"id\": \"%@\", \
                      \"first_name\": \"%@\", \
                      \"middle_name\": \"%@\", \
                      \"last_name\": \"%@\", \
                      \"name\": \"%@\", \
                      \"link_uri\": \"%@\" \
                      }",
                [newProfile userID],
                [newProfile firstName],
                [newProfile middleName],
                [newProfile lastName],
                [newProfile name],
                [[newProfile linkURL] absoluteString]
        ];
        [AIRFacebook dispatchEvent:BASIC_PROFILE_READY withMessage:json];
    }

    [self stopTracking];
}

@end
