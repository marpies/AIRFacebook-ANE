package com.marpies.demo.facebook.screens {

    import com.marpies.ane.facebook.AIRFacebook;
    import com.marpies.ane.facebook.data.ExtendedUserProfile;
    import com.marpies.ane.facebook.events.AIRFacebookExtendedUserProfileEvent;
    import com.marpies.ane.facebook.events.AIRFacebookOpenGraphEvent;
    import com.marpies.ane.facebook.events.AIRFacebookUserFriendsEvent;
    import com.marpies.ane.facebook.listeners.IAIRFacebookExtendedUserProfileListener;
    import com.marpies.ane.facebook.listeners.IAIRFacebookOpenGraphListener;
    import com.marpies.ane.facebook.listeners.IAIRFacebookUserFriendsListener;
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

    public class OpenGraphRequestScreen extends BaseScreen implements
            IAIRFacebookOpenGraphListener,
            IAIRFacebookExtendedUserProfileListener,
            IAIRFacebookUserFriendsListener {

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
        private var mPostScoreButton:Button;
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

            /* Post score button */
            mPostScoreButton = new Button();
            mPostScoreButton.label = "Post score (random 50-5000)";
            mPostScoreButton.isEnabled = isUserLoggedIn;
            mPostScoreButton.addEventListener( Event.TRIGGERED, onPostScoreButtonTriggered );
            addChild( mPostScoreButton );

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
            /* This screen implements 'IAIRFacebookOpenGraphListener', no need for event listener */
            //AIRFacebook.addEventListener( AIRFacebookOpenGraphEvent.REQUEST_RESULT, onRequestResult );

            const method:String = mMethodDropdown.selectedItem.text;
            var params:Object = null;
            switch( method ) {
                case "GET":
                    if( mParametersKeyInput.text != "" ) {
                        params = { };
                        params[mParametersKeyInput.text] = mParametersValueInput.text;
                    }
                    AIRFacebook.sendOpenGraphGETRequest( mGraphPathInput.text, params, this );
                    break;
                case "POST":
                    if( mParametersKeyInput.text != "" ) {
                        params = { };
                        params[mParametersKeyInput.text] = mParametersValueInput.text;
                        params["place"] = "110843418940484";    // Seattle
                    }
                    AIRFacebook.sendOpenGraphPOSTRequest( mGraphPathInput.text, params, this );
                    break;
                case "DELETE":
                    AIRFacebook.sendOpenGraphDELETERequest( mGraphPathInput.text, this );
                    break;
            }
        }

        private function onExtendedProfileButtonTriggered():void {
            /* This screen implements 'IAIRFacebookExtendedUserProfileListener', no need for event listener */
            //AIRFacebook.addEventListener( AIRFacebookExtendedUserProfileEvent.PROFILE_LOADED, onExtendedProfileRequestResult );

            /* Set the user's profile properties you wish to read */
            const params:Vector.<String> = new <String>[ "name", "birthday", "link", "picture.width(200).height(200)" ];
            const userProfile:ExtendedUserProfile = AIRFacebook.requestExtendedUserProfile( params, false, this );   // Add 'true' param to force refresh
            /* If a profile instance is returned then no request will be made */
            if( userProfile != null ) {
                /* If we added event listener then we should remove it here */
                //AIRFacebook.removeEventListener( AIRFacebookExtendedUserProfileEvent.PROFILE_LOADED, onExtendedProfileRequestResult );

                Logger.log( "Using cached extended profile" );
                printExtendedProfile( userProfile );
            }
        }

        private function onFriendListButtonTriggered():void {
            /* This screen implements 'IAIRFacebookUserFriendsListener', no need for event listener */
            //AIRFacebook.addEventListener( AIRFacebookUserFriendsEvent.REQUEST_RESULT, onUserFriendsRequestResult );

            /* Set the friends' profile properties you wish to read */
            const params:Vector.<String> = new <String>[ "name", "link" ];
            AIRFacebook.requestUserFriends( params, this );
        }

        private function onRequestScoreButtonTriggered():void {
            /* This screen implements 'IAIRFacebookOpenGraphListener', no need for event listener */
            //AIRFacebook.addEventListener( AIRFacebookOpenGraphEvent.REQUEST_RESULT, onRequestResult );

            AIRFacebook.requestScores( this );
        }

        private function onPostScoreButtonTriggered():void {
            /* This screen implements 'IAIRFacebookOpenGraphListener', no need for event listener */
            //AIRFacebook.addEventListener( AIRFacebookOpenGraphEvent.REQUEST_RESULT, onRequestResult );

            const score:int = int( Math.random() * 4950 + 50 );
            Logger.log( "Posting score of: " + score );
            AIRFacebook.postScore( score, this );
        }

        /**
         *
         *
         * AIRFacebook handlers (methods defined by IAIRFacebook******* interfaces)
         *
         *
         */

        /**
         * User friends
         */

        public function onFacebookUserFriendsSuccess( friends:Vector.<ExtendedUserProfile> ):void {
            Logger.log( "User friends loaded, printing out friends" );
            const length:uint = friends.length;
            for( var i:uint = 0; i < length; i++ ) {
                printExtendedProfile( friends[i] );
            }
        }

        public function onFacebookUserFriendsError( errorMessage:String ):void {
            Logger.log( "User friends request error: " + errorMessage );
        }

        /**
         * Open graph queries
         */

        public function onFacebookOpenGraphSuccess( jsonResponse:Object, rawResponse:String ):void {
            Logger.log( "Open Graph request success\n" + "raw response: " + rawResponse );

            Logger.log( "Open Graph request parsed JSON:" );
            for( var key:String in jsonResponse ) {
                Logger.log( "\t" + key + "->" + jsonResponse[key] );
            }
        }

        public function onFacebookOpenGraphError( errorMessage:String ):void {
            Logger.log( "Open Graph request error: " + errorMessage );
        }

        /**
         * Extended user profile
         */

        public function onFacebookExtendedUserProfileSuccess( user:ExtendedUserProfile ):void {
            Logger.log( "Extended user profile loaded, printing" );
            printExtendedProfile( user );
        }

        public function onFacebookExtendedUserProfileError( errorMessage:String ):void {
            Logger.log( "Extended user profile error: " + errorMessage );
        }

        /**
         * Event handlers (just for demonstration purposes)
         */

        private function onRequestResult( event:AIRFacebookOpenGraphEvent ):void {
            AIRFacebook.removeEventListener( AIRFacebookOpenGraphEvent.REQUEST_RESULT, onRequestResult );
            if( event.errorMessage ) {
                Logger.log( "[EventHandler] Open Graph request error: " + event.errorMessage );
                return;
            }

            Logger.log( "[EventHandler] Open Graph request success" );
        }

        private function onExtendedProfileRequestResult( event:AIRFacebookExtendedUserProfileEvent ):void {
            AIRFacebook.removeEventListener( AIRFacebookExtendedUserProfileEvent.PROFILE_LOADED, onExtendedProfileRequestResult );
            if( event.errorMessage ) {
                Logger.log( "[EventHandler] Extended user profile error: " + event.errorMessage );
                return;
            }

            Logger.log( "[EventHandler] Extended user profile loaded" );
        }

        private function onUserFriendsRequestResult( event:AIRFacebookUserFriendsEvent ):void {
            AIRFacebook.removeEventListener( AIRFacebookUserFriendsEvent.REQUEST_RESULT, onUserFriendsRequestResult );
            if( event.errorMessage ) {
                Logger.log( "[EventHandler] User friends request error: " + event.errorMessage );
                return;
            }
            Logger.log( "[EventHandler] User friends loaded " + event.friends.length );
        }

        /**
         *
         *
         * Private API
         *
         *
         */

        private function printExtendedProfile( userProfile:ExtendedUserProfile ):void {
            const props:Vector.<String> = new <String>[ "name", "birthday", "link", "picture" ];
            for each( var prop:String in props ) {
                const propVal:Object = userProfile.getProperty( prop );
                if( propVal ) {
                    Logger.log( "\t" + prop + " -> " + propVal );
                } else {
                    Logger.log( "\tProfile does not have property '" + prop + "' available" );
                }
            }
        }

    }

}
