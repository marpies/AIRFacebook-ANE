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

#import <Foundation/Foundation.h>

@interface AIRFacebook : NSObject

@property (nonatomic, readonly) NSString* appID;
@property (nonatomic, readonly) BOOL isInitialized;
@property (nonatomic, readonly) NSString* urlSchemeSuffix;

- (void) initWithAppID:(NSString*) appID urlSchemeSuffix:(NSString*) suffix showLogs:(BOOL) showLogs;

+ (id) sharedInstance;
+ (void) dispatchEvent:(const NSString*) eventName;
+ (void) dispatchEvent:(const NSString*) eventName withMessage:(NSString *) message;
+ (void) log:(const NSString*) message;
+ (BOOL) isInitialized;

@end