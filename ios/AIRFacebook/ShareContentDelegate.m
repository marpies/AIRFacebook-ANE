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

#import "ShareContentDelegate.h"
#import "AIRFacebookShareType.h"
#import "AIRFacebook.h"
#import "AIRFacebookEvent.h"
#import <AIRExtHelpers/MPStringUtils.h>

static int mAirFBListenerId = -1;
static ShareContentDelegate* airFBShareContentDelegateInstance = nil;

@interface ShareContentDelegate ()
- (void) shareLinkOfType:(AIRFBShareType) type withParameters:(NSDictionary*) parameters;

- (void) sharePhotoOfType:(AIRFBShareType) type withParameters:(NSDictionary*) parameters;

/* Helper method for sharePhotoOfType */
- (void) shareUIImage:(UIImage*) image userGenerated:(BOOL) isUserGenerated withoutUI:(BOOL) withoutUI withMessenger:(BOOL) useMessenger withMessage:(NSString*) message;

- (void) shareOpenGraphWithParameters:(NSDictionary*) parameters;

- (void) showAppInviteDialogWithParameters:(NSDictionary*) parameters;

- (void) showGameRequestDialogWithParameters:(NSDictionary*) parameters;

- (void) shareContent:(NSObject <FBSDKSharingContent>*) content withoutUI:(BOOL) withoutUI withMessenger:(BOOL) useMessenger withMessage:(NSString*) message;
@end

@implementation ShareContentDelegate

+ (ShareContentDelegate*) sharedInstance {
    if( airFBShareContentDelegateInstance == nil ) {
        airFBShareContentDelegateInstance = [[ShareContentDelegate alloc] init];
    }
    return airFBShareContentDelegateInstance;
}

- (void) shareWithParameters:(NSDictionary*) parameters {
    [AIRFacebook log:[NSString stringWithFormat:@"ShareContentDelegate shareWithParameters %@", [parameters valueForKey:@"type"]]];
    
    mAirFBListenerId = [parameters[@"listenerID"] intValue];
    AIRFBShareType shareType = [AIRFacebookShareType valueOf:parameters[@"type"]];
    switch( shareType ) {
        case AIRFBShareType_LINK:
        case AIRFBShareType_MESSAGE_LINK:
            [self shareLinkOfType:shareType withParameters:parameters];
            return;
        case AIRFBShareType_PHOTO:
        case AIRFBShareType_MESSAGE_PHOTO:
            [self sharePhotoOfType:shareType withParameters:parameters];
            return;
        case AIRFBShareType_OPEN_GRAPH:
            [self shareOpenGraphWithParameters:parameters];
            return;
        case AIRFBShareType_APP_INVITE:
            [self showAppInviteDialogWithParameters:parameters];
            return;
        case AIRFBShareType_GAME_REQUEST:
            [self showGameRequestDialogWithParameters:parameters];
            return;
    }
}

- (void) shareLinkOfType:(AIRFBShareType) shareType withParameters:(NSDictionary*) parameters {
    [AIRFacebook log:@"Sharing link."];
    
    id contentURL = parameters[@"contentURL"];
    id withoutUI = parameters[@"withoutUI"];
    id message = parameters[@"message"];
    
    FBSDKShareLinkContent* content = [[FBSDKShareLinkContent alloc] init];
    content.contentURL = [NSURL URLWithString:contentURL];
    
    [self shareContent:content withoutUI:[withoutUI boolValue] withMessenger:shareType == AIRFBShareType_MESSAGE_LINK withMessage:message];
}

- (void) sharePhotoOfType:(AIRFBShareType) shareType withParameters:(NSDictionary*) parameters {
    [AIRFacebook log:@"Sharing photo."];
    
    id photo = parameters[@"photo"];
    id imageURL = parameters[@"imageURL"];
    id withoutUI = parameters[@"withoutUI"];
    id message = parameters[@"message"];
    BOOL isUserGenerated = [parameters[@"isUserGenerated"] boolValue];
    
    /* Create photo from UIImage */
    if( photo ) {
        /* Call the helper method to share UIImage */
        [self shareUIImage:photo
             userGenerated:isUserGenerated
                 withoutUI:[withoutUI boolValue]
             withMessenger:shareType == AIRFBShareType_MESSAGE_PHOTO
               withMessage:message];
    }
    /* Create photo from image URL */
    else if( imageURL ) {
        /*
         * BUG: FBSDKSharePhoto photoWithImageURL does not seem to work.
         * As a workaround we load the image asynchronously, then create
         * UIImage from the loaded data and use that as a source for the photo.
         *
         * todo: might not work for local files
         * */
        [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:imageURL]]
                                           queue:[NSOperationQueue mainQueue]
                               completionHandler:^( NSURLResponse* response, NSData* data, NSError* connectionError ) {
                                   if( !connectionError ) {
                                       /* Call the helper method to share UIImage */
                                       [self shareUIImage:[[UIImage alloc] initWithData:data]
                                            userGenerated:isUserGenerated
                                                withoutUI:[withoutUI boolValue]
                                            withMessenger:shareType == AIRFBShareType_MESSAGE_PHOTO
                                              withMessage:message];
                                   } else {
                                       [AIRFacebook dispatchEvent:SHARE_ERROR withMessage:[MPStringUtils getEventErrorJSONString:mAirFBListenerId errorMessage:connectionError.localizedDescription]];
                                   }
                               }];
    } else {
        [AIRFacebook log:@"Error creating FBSDKSharePhoto"];
        [AIRFacebook dispatchEvent:SHARE_ERROR withMessage:[MPStringUtils getEventErrorJSONString:mAirFBListenerId errorMessage:@"Invalid bitmap data encountered."]];
        return;
    }
}

- (void) shareUIImage:(UIImage*) image userGenerated:(BOOL) isUserGenerated withoutUI:(BOOL) withoutUI withMessenger:(BOOL) useMessenger withMessage:(NSString*) message {
    FBSDKSharePhotoContent* content = [[FBSDKSharePhotoContent alloc] init];
    content.photos = @[[FBSDKSharePhoto photoWithImage:image userGenerated:isUserGenerated]];
    [self shareContent:content withoutUI:withoutUI withMessenger:useMessenger withMessage:message];
}

- (void) shareOpenGraphWithParameters:(NSDictionary*) parameters {
    [AIRFacebook log:@"Sharing Open Graph story."];
    
    /* Create object properties */
    id objectType = parameters[@"objectType"];
    NSMutableDictionary* objectProperties = [@{@"og:type" : objectType, @"og:title" : parameters[@"title"]} mutableCopy];
    id extraProperties = parameters[@"objectProperties"];
    /* Add extra object properties, if any */
    if( extraProperties ) {
        [objectProperties addEntriesFromDictionary:extraProperties];
    }
    
    /* Create an object */
    FBSDKShareOpenGraphObject* object = [FBSDKShareOpenGraphObject objectWithProperties:objectProperties];
    
    /* Add image, if specified */
    UIImage* image = parameters[@"image"];
    id imageURL = parameters[@"imageURL"];
    if( image ) {
        [object setPhoto:[FBSDKSharePhoto photoWithImage:image userGenerated:NO] forKey:@"og:image"];
    } else if( imageURL ) {
        [object setPhoto:[FBSDKSharePhoto photoWithImageURL:[NSURL URLWithString:imageURL] userGenerated:NO] forKey:@"og:image"];
    }
    
    /* Create an action */
    FBSDKShareOpenGraphAction* action = [[FBSDKShareOpenGraphAction alloc] init];
    [action setActionType:parameters[@"actionType"]];
    [action setObject:object forKey:objectType];
    
    /* Create the content */
    FBSDKShareOpenGraphContent* content = [[FBSDKShareOpenGraphContent alloc] init];
    [content setAction:action];
    [content setPreviewPropertyName:objectType];
    
    [self shareContent:content withoutUI:NO withMessenger:NO withMessage:nil];
}

- (void) showAppInviteDialogWithParameters:(NSDictionary*) parameters {
    [AIRFacebook log:@"Showing app invite dialog."];
    
    FBSDKAppInviteContent* content = [[FBSDKAppInviteContent alloc] init];
    [content setAppLinkURL:[NSURL URLWithString:parameters[@"appLinkURL"]]];
    id imageURL = parameters[@"imageURL"];
    if( imageURL ) {
        [content setAppInvitePreviewImageURL:[NSURL URLWithString:imageURL]];
    }
    [FBSDKAppInviteDialog showFromViewController:[[[[UIApplication sharedApplication] delegate] window] rootViewController] withContent:content delegate:self];
}

- (void) showGameRequestDialogWithParameters:(NSDictionary*) parameters {
    [AIRFacebook log:@"Showing GameRequest dialog."];
    
    /* Get request action type from NSString (NONE, SEND, ASKFOR, TURN) */
    FBSDKGameRequestActionType actionType = FBSDKGameRequestActionTypeNone;
    NSString* actionTypeString = parameters[@"actionType"];
    if( actionTypeString ) {
        if( [actionTypeString isEqualToString:@"SEND"] ) {
            actionType = FBSDKGameRequestActionTypeSend;
        } else if( [actionTypeString isEqualToString:@"ASKFOR"] ) {
            actionType = FBSDKGameRequestActionTypeAskFor;
        } else if( [actionTypeString isEqualToString:@"TURN"] ) {
            actionType = FBSDKGameRequestActionTypeTurn;
        }
    }
    
    /* Build content */
    FBSDKGameRequestContent* content = [[FBSDKGameRequestContent alloc] init];
    [content setActionType:actionType];
    [content setMessage:parameters[@"message"]];
    id title = parameters[@"title"];
    if( title ) {
        [content setTitle:title];
    }
    id objectID = parameters[@"objectID"];
    if( objectID ) {
        [content setObjectID:objectID];
    }
    id friendsFilter = parameters[@"friendsFilter"];
    if( friendsFilter ) {
        [AIRFacebook log:[NSString stringWithFormat:@"Setting friends filter to %@", friendsFilter]];
        FBSDKGameRequestFilter filter = [friendsFilter isEqualToString:@"appUsers"] ? FBSDKGameRequestFilterAppUsers : FBSDKGameRequestFilterAppNonUsers;
        [content setFilters:filter];
    }
    id data = parameters[@"data"];
    if( data ) {
        [content setData:data];
    }
    id suggestedFriends = parameters[@"suggestedFriends"];
    if( suggestedFriends ) {
        [content setRecipientSuggestions:suggestedFriends];
    }
    id recipients = parameters[@"recipients"];
    if( recipients ) {
        [AIRFacebook log:[NSString stringWithFormat:@"Setting request recipients to %@", recipients]];
        [content setRecipients:recipients];
    }
    
    [FBSDKGameRequestDialog showWithContent:content delegate:self];
}

- (void) shareContent:(NSObject <FBSDKSharingContent>*) content withoutUI:(BOOL) withoutUI withMessenger:(BOOL) useMessenger withMessage:(NSString*) message {
    if( withoutUI ) {
        /* Share with explicit message */
        if( message ) {
            FBSDKShareAPI* shareAPI = [[FBSDKShareAPI alloc] init];
            [shareAPI setMessage:message];
            [shareAPI setShareContent:content];
            [shareAPI setDelegate:self];
            [shareAPI share];
        }
        /* Share without message */
        else {
            [FBSDKShareAPI shareWithContent:content delegate:self];
        }
    } else {
        UIViewController* rootViewController = [[[[UIApplication sharedApplication] delegate] window] rootViewController];
        if( !rootViewController ) {
            [AIRFacebook log:@"Error getting root view controller to share Facebook content."];
            return;
        }
        if( useMessenger ) {
            [FBSDKMessageDialog showWithContent:content delegate:self];
        } else {
            [FBSDKShareDialog showFromViewController:rootViewController withContent:content delegate:self];
        }
    }
}

/**
 *
 *
 * Delegate implementations
 *
 *
 */

# pragma mark - Content Share callbacks

- (void) sharer:(id <FBSDKSharing>) sharer didCompleteWithResults:(NSDictionary*) results {
    [AIRFacebook log:[NSString stringWithFormat:@"Content sharing result - success %@", results]];
    id postID = results[@"postId"];
    if( postID ) {
        [AIRFacebook dispatchEvent:SHARE_SUCCESS withMessage:[MPStringUtils getSingleValueJSONString:mAirFBListenerId key:@"postID" value:postID]];
    } else {
        [AIRFacebook dispatchEvent:SHARE_SUCCESS withMessage:[MPStringUtils getListenerJSONString:mAirFBListenerId]];
    }
}

- (void) sharer:(id <FBSDKSharing>) sharer didFailWithError:(NSError*) error {
    [AIRFacebook log:[NSString stringWithFormat: @"Content sharing result - error: %@", error.localizedDescription]];
    [AIRFacebook dispatchEvent:SHARE_ERROR withMessage:[MPStringUtils getEventErrorJSONString:mAirFBListenerId errorMessage:error.localizedDescription]];
}

- (void) sharerDidCancel:(id <FBSDKSharing>) sharer {
    [AIRFacebook log:@"Content sharing result - cancelled"];
    [AIRFacebook dispatchEvent:SHARE_CANCEL withMessage:[MPStringUtils getListenerJSONString:mAirFBListenerId]];
}

# pragma mark - App Invite callbacks

- (void) appInviteDialog:(FBSDKAppInviteDialog*) appInviteDialog didCompleteWithResults:(NSDictionary*) results {
    /* If the dialog is cancelled results contains 'completionGesture',
     * otherwise it contains only 'didComplete' Boolean */
    NSString* completionGesture = results[@"completionGesture"];
    if( completionGesture && [completionGesture isEqualToString:@"cancel"] ) {
        [AIRFacebook log:@"App invite result - cancelled"];
        [AIRFacebook dispatchEvent:SHARE_CANCEL withMessage:[MPStringUtils getSingleValueJSONString:mAirFBListenerId key:@"appInvite" value:@"true"]];
    } else {
        [AIRFacebook log:@"App invite result - success"];
        [AIRFacebook dispatchEvent:SHARE_SUCCESS withMessage:[MPStringUtils getSingleValueJSONString:mAirFBListenerId key:@"appInvite" value:@"true"]];
    }
}

- (void) appInviteDialog:(FBSDKAppInviteDialog*) appInviteDialog didFailWithError:(NSError*) error {
    [AIRFacebook log:[NSString stringWithFormat: @"App invite result - error: %@", error.localizedDescription]];
    [AIRFacebook dispatchEvent:SHARE_ERROR
                   withMessage:[NSString stringWithFormat:@"{ \"listenerID\": %d, \"errorMessage\": \"%@\", \"appInvite\": \"true\" }", mAirFBListenerId, error.localizedDescription]];
}

#pragma mark - Game Request callbacks

- (void) gameRequestDialog:(FBSDKGameRequestDialog*) gameRequestDialog didCompleteWithResults:(NSDictionary*) results {
    /* Create recipients array */
    NSMutableArray* recipients = results[@"to"];
    /* Create NSDictionary with request ID and the recipients */
    NSMutableDictionary* result = [[NSMutableDictionary alloc] init];
    if( recipients ) {
        result[@"recipients"] = recipients;
    }
    id requestID = results[@"request"];
    if( requestID ) {
        result[@"request_id"] = requestID;
    }
    result[@"listenerID"] = @(mAirFBListenerId);
    /* Try to parse JSON from the result NSDictionary */
    NSError* parseError = nil;
    NSData* jsonData = [NSJSONSerialization dataWithJSONObject:result options:0 error:&parseError];
    /* Error parsing */
    if( !jsonData ) {
        [AIRFacebook log:[NSString stringWithFormat:@"GameRequest result - error: %@", parseError.localizedDescription]];
        [AIRFacebook dispatchEvent:GAME_REQUEST_ERROR withMessage:[MPStringUtils getEventErrorJSONString:mAirFBListenerId errorMessage:parseError.localizedDescription]];
    }
    /* Successfully parsed */
    else {
        NSString* jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
        [AIRFacebook log:@"GameRequest result - success"];
        [AIRFacebook dispatchEvent:GAME_REQUEST_SUCCESS withMessage:jsonString];
    }
}

- (void) gameRequestDialog:(FBSDKGameRequestDialog*) gameRequestDialog didFailWithError:(NSError*) error {
    [AIRFacebook log:[NSString stringWithFormat: @"GameRequest result - error: %@", error.localizedDescription]];
    [AIRFacebook dispatchEvent:GAME_REQUEST_ERROR withMessage:[MPStringUtils getEventErrorJSONString:mAirFBListenerId errorMessage:error.localizedDescription]];
}

- (void) gameRequestDialogDidCancel:(FBSDKGameRequestDialog*) gameRequestDialog {
    [AIRFacebook log:@"GameRequest result - cancelled"];
    [AIRFacebook dispatchEvent:GAME_REQUEST_CANCEL withMessage:[MPStringUtils getListenerJSONString:mAirFBListenerId]];
}


@end
