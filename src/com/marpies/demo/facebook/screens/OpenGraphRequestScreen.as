package com.marpies.demo.facebook.screens {

    import com.marpies.ane.facebook.AIRFacebook;
    import com.marpies.ane.facebook.data.ExtendedUserProfile;
    import com.marpies.ane.facebook.events.AIRFacebookExtendedUserProfileEvent;
    import com.marpies.ane.facebook.events.AIRFacebookOpenGraphEvent;
    import com.marpies.ane.facebook.events.AIRFacebookUserFriendsEvent;
    import com.marpies.utils.Constants;
    import com.marpies.utils.Logger;
    import com.marpies.utils.VerticalLayoutBuilder;

    import feathers.controls.Button;
    import feathers.controls.Label;
    import feathers.controls.PickerList;
    import feathers.controls.TextInput;
    import feathers.data.ListCollection;
    import feathers.layout.VerticalLayout;

    import starling.display.DisplayObject;
    import starling.events.Event;

    public class OpenGraphRequestScreen extends BaseScreen {

        private var mMethodLabel:Label;
        private var mMethodDropdown:PickerList;
        private var mGraphPathLabel:Label;
        private var mGraphPathInput:TextInput;
        private var mParametersKeyLabel:Label;
        private var mParametersKeyInput:TextInput;
        private var mParametersValueLabel:Label;
        private var mParametersValueInput:TextInput;
        private var mSendButton:Button;
        private var mRequestScoresButton:Button;
        private var mExtendedProfileButton:Button;
        private var mFriendListButton:Button;

        public function OpenGraphRequestScreen() {
            super();
        }

        override protected function initialize():void {
            super.initialize();

            layout = new VerticalLayoutBuilder()
                    .setGap( 10 )
                    .setPadding( 10 )
                    .setHorizontalAlign( VerticalLayout.HORIZONTAL_ALIGN_CENTER )
                    .build();

            title = "Open Graph requests";
            width = Constants.stageWidth;
            height = Constants.stageHeight;

            /* HTTP method */
                /* Label */
            mMethodLabel = new Label();
            mMethodLabel.text = "HTTP method:";
            addChild( mMethodLabel );
                /* Dropdown */
            mMethodDropdown = new PickerList();
            mMethodDropdown.dataProvider = new ListCollection(
                    [
                        { text: "GET" },
                        { text: "POST" },
                        { text: "DELETE" }
                    ]
            );
            mMethodDropdown.typicalItem = "DELETE";
            mMethodDropdown.labelField = "text";
            mMethodDropdown.listProperties.@itemRendererProperties.labelField = "text";
            addChild( mMethodDropdown );

            /* Request path */
                /* Label */
            mGraphPathLabel = new Label();
            mGraphPathLabel.text = "Request path/Node ID:";
            addChild( mGraphPathLabel );
                /* Input */
            mGraphPathInput = new TextInput();
            mGraphPathInput.width = Constants.stageWidth >> 1;
            mGraphPathInput.text = "/me";
            addChild( mGraphPathInput );

            /* Parameters key */
                /* Label */
            mParametersKeyLabel = new Label();
            mParametersKeyLabel.text = "Parameters key:";
            addChild( mParametersKeyLabel );
                /* Input */
            mParametersKeyInput = new TextInput();
            mParametersKeyInput.width = Constants.stageWidth >> 2;
            mParametersKeyInput.text = "fields";
            addChild( mParametersKeyInput );

            /* Parameters value */
                /* Label */
            mParametersValueLabel = new Label();
            mParametersValueLabel.text = "Parameters values:";
            addChild( mParametersValueLabel );
                /* Input */
            mParametersValueInput = new TextInput();
            mParametersValueInput.width = Constants.stageWidth >> 1;
            mParametersValueInput.text = "id,name,link";
            addChild( mParametersValueInput );

            const isUserLoggedIn:Boolean = AIRFacebook.isUserLoggedIn;
            /* Extended profile button */
            mExtendedProfileButton = new Button();
            mExtendedProfileButton.label = "Request extended profile";
            mExtendedProfileButton.isEnabled = isUserLoggedIn;
            mExtendedProfileButton.addEventListener( Event.TRIGGERED, onExtendedProfileButtonTriggered );
            addChild( mExtendedProfileButton );

            /* Friend list button */
            mFriendListButton = new Button();
            mFriendListButton.label = "Request user friends";
            mFriendListButton.isEnabled = isUserLoggedIn;
            mFriendListButton.addEventListener( Event.TRIGGERED, onFriendListButtonTriggered );
            addChild( mFriendListButton );

            /* Request score button */
            mRequestScoresButton = new Button();
            mRequestScoresButton.label = "Request scores";
            mRequestScoresButton.isEnabled = isUserLoggedIn;
            mRequestScoresButton.addEventListener( Event.TRIGGERED, onRequestScoreButtonTriggered );
            addChild( mRequestScoresButton );

            /* Send button on the right of the header */
            mSendButton = new Button();
            mSendButton.label = "SEND REQUEST";
            mSendButton.isEnabled = AIRFacebook.isSupported;
            mSendButton.styleNameList.add( Button.ALTERNATE_STYLE_NAME_FORWARD_BUTTON );
            mSendButton.addEventListener( Event.TRIGGERED, onSendButtonTriggered );
            headerProperties.rightItems = new <DisplayObject> [
                mSendButton
            ];
        }

        /**
         *
         *
         * Button handlers
         *
         *
         */

        private function onSendButtonTriggered( event:Event ):void {
            AIRFacebook.addEventListener( AIRFacebookOpenGraphEvent.REQUEST_RESULT, onRequestResult );
            const method:String = mMethodDropdown.selectedItem.text;
            var params:Object = null;
            switch( method ) {
                case "GET":
                    if( mParametersKeyInput.text != "" ) {
                        params = { };
                        params[mParametersKeyInput.text] = mParametersValueInput.text;
                    }
                    AIRFacebook.sendOpenGraphGETRequest( mGraphPathInput.text, params );
                    break;
                case "POST":
                    if( mParametersKeyInput.text != "" ) {
                        params = { };
                        params[mParametersKeyInput.text] = mParametersValueInput.text;
                        params["place"] = "110843418940484";    // Seattle
                    }
                    AIRFacebook.sendOpenGraphPOSTRequest( mGraphPathInput.text, params );
                    break;
                case "DELETE":
                    AIRFacebook.sendOpenGraphDELETERequest( mGraphPathInput.text );
                    break;
            }
        }

        private function onExtendedProfileButtonTriggered():void {
            AIRFacebook.addEventListener( AIRFacebookExtendedUserProfileEvent.PROFILE_LOADED, onExtendedProfileRequestResult );
            /* Set the user's profile properties you wish to read */
            const params:Vector.<String> = new <String>[ "name", "birthday", "link", "picture.width(200).height(200)" ];
            const userProfile:ExtendedUserProfile = AIRFacebook.requestExtendedUserProfile( params );   // Add 'true' param to force refresh
            /* If a profile instance is returned then no request will be made */
            if( userProfile != null ) {
                AIRFacebook.removeEventListener( AIRFacebookExtendedUserProfileEvent.PROFILE_LOADED, onExtendedProfileRequestResult );
                Logger.log( "Using cached extended profile" );
                printExtendedProfile( userProfile );
            }
        }

        private function onFriendListButtonTriggered():void {
            AIRFacebook.addEventListener( AIRFacebookUserFriendsEvent.REQUEST_RESULT, onUserFriendsRequestResult );
            /* Set the friends' profile properties you wish to read */
            const params:Vector.<String> = new <String>[ "name", "link" ];
            AIRFacebook.requestUserFriends( params );
        }

        private function onRequestScoreButtonTriggered():void {
            AIRFacebook.addEventListener( AIRFacebookOpenGraphEvent.REQUEST_RESULT, onRequestResult );
            AIRFacebook.requestScores();
        }

        /**
         *
         *
         * Request results
         *
         *
         */

        private function onRequestResult( event:AIRFacebookOpenGraphEvent ):void {
            AIRFacebook.removeEventListener( AIRFacebookOpenGraphEvent.REQUEST_RESULT, onRequestResult );
            if( event.errorMessage ) {
                Logger.log( "Open Graph request error: " + event.errorMessage );
                return;
            }

            Logger.log( "Open Graph request success\n" + "raw response: " + event.rawResponse );

            const json:Object = event.jsonResponse;
            Logger.log( "Open Graph request parsed JSON:" );
            for( var key:String in json ) {
                Logger.log( "\t" + key + "->" + json[key] );
            }
        }

        private function onExtendedProfileRequestResult( event:AIRFacebookExtendedUserProfileEvent ):void {
            AIRFacebook.removeEventListener( AIRFacebookExtendedUserProfileEvent.PROFILE_LOADED, onExtendedProfileRequestResult );
            if( event.errorMessage ) {
                Logger.log( "Extended user profile error: " + event.errorMessage );
                return;
            }

            Logger.log( "Extended user profile loaded, printing" );
            printExtendedProfile( event.extendedUserProfile );
        }

        private function onUserFriendsRequestResult( event:AIRFacebookUserFriendsEvent ):void {
            AIRFacebook.removeEventListener( AIRFacebookUserFriendsEvent.REQUEST_RESULT, onUserFriendsRequestResult );
            if( event.errorMessage ) {
                Logger.log( "User friends request error: " + event.errorMessage );
                return;
            }

            Logger.log( "User friends loaded, printing out friends" );
            const length:uint = event.friends.length;
            for( var i:uint = 0; i < length; i++ ) {
                printExtendedProfile( event.friends[i] );
            }
        }

        private function printExtendedProfile( userProfile:ExtendedUserProfile ):void {
            for( var key:String in userProfile ) {
                Logger.log( "\t" + key + " -> " + userProfile.getProperty( key ) );
            }
        }

    }

}
