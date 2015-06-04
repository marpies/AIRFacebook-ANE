package com.marpies.demo.facebook.screens {

    import com.marpies.ane.facebook.AIRFacebook;
    import com.marpies.ane.facebook.events.AIRFacebookBasicUserProfileEvent;
    import com.marpies.ane.facebook.events.AIRFacebookCachedAccessTokenEvent;
    import com.marpies.ane.facebook.events.AIRFacebookLoginEvent;
    import com.marpies.ane.facebook.events.AIRFacebookLogoutEvent;
    import com.marpies.ane.facebook.events.AIRFacebookUserProfilePictureEvent;
    import com.marpies.utils.AlertManager;
    import com.marpies.utils.Constants;
    import com.marpies.utils.Logger;
    import com.marpies.utils.VerticalLayoutBuilder;

    import feathers.controls.Button;
    import feathers.controls.Label;
    import feathers.controls.PickerList;
    import feathers.data.ListCollection;
    import feathers.layout.VerticalLayout;

    import starling.display.DisplayObject;

    import starling.display.Image;
    import starling.events.Event;

    public class LoginScreen extends BaseScreen {

        private var mPermissions:Vector.<String>;

        private var mProfilePicture:Image;
        private var mUserLabel:Label;

        private var mLoginTypeList:PickerList;
        private var mLoginButton:Button;
        private var mLogoutButton:Button;
        private var mPermissionsButton:Button;

        /**
         * ====================================
         * ===== SET YOUR FACEBOOK APP ID =====
         * ====================================
         */
        private const FACEBOOK_APP_ID:String = null; // Set your Facebook app ID here

        public function LoginScreen() {
            super();

            if( !FACEBOOK_APP_ID ) {
                throw new Error( "Set your Facebook app ID in LoginScreen.as" );
            }
            if( AIRFacebook.init( FACEBOOK_APP_ID, false, null, true ) ) {
                AIRFacebook.addEventListener( AIRFacebookCachedAccessTokenEvent.RESULT, onCachedAccessTokenResult );
                Logger.log( "Initialized Facebook SDK " + AIRFacebook.sdkVersion );
            } else {
                Logger.log( "Failed to initialize Facebook SDK" );
            }
        }

        override protected function initialize():void {
            super.initialize();

            title = "Log in/out";
            layout = new VerticalLayoutBuilder()
                    .setGap( 10 )
                    .setVerticalAlign( VerticalLayout.VERTICAL_ALIGN_MIDDLE )
                    .setHorizontalAlign( VerticalLayout.HORIZONTAL_ALIGN_CENTER )
                    .build();

            /* Permissions button in header */
            mPermissionsButton = new Button();
            mPermissionsButton.label = "PERMISSIONS";
            mPermissionsButton.addEventListener( Event.TRIGGERED, onPermissionsButtonTriggered );
            mPermissionsButton.styleNameList.add( Button.ALTERNATE_STYLE_NAME_FORWARD_BUTTON );
            addChild( mPermissionsButton );
            headerProperties.rightItems = new <DisplayObject>[
                mPermissionsButton
            ];

            /* User label */
            mUserLabel = new Label();
            addChild( mUserLabel );

            /* Login type list */
            mLoginTypeList = new PickerList();
            mLoginTypeList.dataProvider = new ListCollection(
                    [
                        {value: "READ"},
                        {value: "PUBLISH"}
                    ]
            );
            mLoginTypeList.prompt = "SELECT PERMISSION TYPE";
            mLoginTypeList.labelField = "value";
            mLoginTypeList.typicalItem = "SELECT PERMISSION TYPE";
            mLoginTypeList.selectedIndex = -1;
            mLoginTypeList.listProperties.@itemRendererProperties.labelField = "value";
            addChild( mLoginTypeList );

            /* Log in button */
            mLoginButton = new Button();
            mLoginButton.label = "Log in";
            mLoginButton.addEventListener( Event.TRIGGERED, onLoginButtonTriggered );
            mLoginButton.styleNameList.add( Button.ALTERNATE_STYLE_NAME_CALL_TO_ACTION_BUTTON );
            addChild( mLoginButton );

            /* Log out button */
            mLogoutButton = new Button();
            mLogoutButton.label = "Log out";
            mLogoutButton.addEventListener( Event.TRIGGERED, onLogoutButtonTriggered );
            mLogoutButton.styleNameList.add( Button.ALTERNATE_STYLE_NAME_DANGER_BUTTON );
            addChild( mLogoutButton );

            refreshUI();
        }

        /**
         *
         *
         * Private API
         *
         *
         */

        private function refreshUI():void {
            if( AIRFacebook.isSupported ) {
                const isUserLoggedIn:Boolean = AIRFacebook.isUserLoggedIn;
                mLoginButton.isEnabled = !isUserLoggedIn;
                mLogoutButton.isEnabled = isUserLoggedIn;
                /* Show user name, if logged in and the profile is ready to be accessed */
                if( isUserLoggedIn ) {
                    if( AIRFacebook.isBasicUserProfileReady ) {
                        mUserLabel.text = AIRFacebook.basicUserProfile.name;
                    }
                    /* Otherwise wait for the profile to be ready */
                    else {
                        AIRFacebook.addEventListener( AIRFacebookBasicUserProfileEvent.PROFILE_READY, onBasicUserProfileReady );
                    }
                } else {
                    mUserLabel.text = "Not logged in.";
                    if( mProfilePicture ) {
                        mProfilePicture.removeFromParent( true );
                        mProfilePicture = null;
                    }
                }
            } else {
                mUserLabel.text = "AIRFacebook is not supported.";
                mLoginButton.isEnabled = false;
                mLogoutButton.isEnabled = false;
                mLoginTypeList.isEnabled = false;
            }
        }

        /**
         *
         *
         * UI handlers
         *
         *
         */

        private function onLoginButtonTriggered():void {
            /* Login permission type is not selected, show alert */
            if( mLoginTypeList.selectedIndex == -1 ) {
                AlertManager.show( "alert", "AIRFacebook", "Select a login permission type.",
                        new ListCollection( [
                            { label: "Will do!" }
                        ] )
                );
                return;
            }

            AIRFacebook.addEventListener( AIRFacebookLoginEvent.LOGIN_RESULT, onLoginResult );
            /* READ selected in the PickerList */
            if( mLoginTypeList.selectedIndex == 0 ) {
                AIRFacebook.loginWithReadPermissions( mPermissions );
            }
            /* PUBLISH selected in the PickerList */
            else {
                AIRFacebook.loginWithPublishPermissions( mPermissions );
            }
        }

        private function onLogoutButtonTriggered():void {
            AIRFacebook.addEventListener( AIRFacebookLogoutEvent.LOGOUT_RESULT, onLogoutResult );
            AIRFacebook.logout( true );
        }

        private function onPermissionsButtonTriggered():void {
            dispatchEventWith( "show" + Screens.PERMISSIONS );
        }

        /**
         *
         *
         * AIRFacebook handlers
         *
         *
         */

        private function onCachedAccessTokenResult( event:AIRFacebookCachedAccessTokenEvent ):void {
            AIRFacebook.removeEventListener( AIRFacebookCachedAccessTokenEvent.RESULT, onCachedAccessTokenResult );
            if( event.wasLoaded ) {
                Logger.log( "Access token was loaded from cache." );
                refreshUI();
            }
        }

        private function onLoginResult( event:AIRFacebookLoginEvent ):void {
            AIRFacebook.removeEventListener( AIRFacebookLoginEvent.LOGIN_RESULT, onLoginResult );

            if( event.errorMessage ) {
                Logger.log( "Login error: " + event.errorMessage );
            } else if( event.wasCancelled ) {
                Logger.log( "Login cancelled" );
            } else {
                Logger.log( "Login successful" );
                if( !mProfilePicture ) {
                    if( AIRFacebook.isBasicUserProfileReady ) {
                        AIRFacebook.addEventListener( AIRFacebookUserProfilePictureEvent.RESULT, onProfilePictureResult );
                        /* Ignoring the returned URL as we want to have it auto loaded */
                        AIRFacebook.requestUserProfilePicture( 200, 200, true );
                    }
                }
            }

            refreshUI();
        }

        private function onLogoutResult( event:AIRFacebookLogoutEvent ):void {
            AIRFacebook.removeEventListener( AIRFacebookLogoutEvent.LOGOUT_RESULT, onLogoutResult );

            if( event.errorMessage ) {
                Logger.log( "Logout error: " + event.errorMessage );
            } else if( event.wasCancelled ) {
                Logger.log( "Logout cancelled" );
            } else {
                Logger.log( "Logout success" );
            }

            refreshUI();
        }

        private function onBasicUserProfileReady( event:AIRFacebookBasicUserProfileEvent ):void {
            AIRFacebook.removeEventListener( AIRFacebookBasicUserProfileEvent.PROFILE_READY, onBasicUserProfileReady );
            /* Load the profile picture */
            AIRFacebook.addEventListener( AIRFacebookUserProfilePictureEvent.RESULT, onProfilePictureResult );
            AIRFacebook.requestUserProfilePicture( 200, 200, true );

            refreshUI();
        }

        private function onProfilePictureResult( event:AIRFacebookUserProfilePictureEvent ):void {
            AIRFacebook.removeEventListener( AIRFacebookUserProfilePictureEvent.RESULT, onProfilePictureResult );
            if( event.errorMessage ) {
                Logger.log( "Error loading profile picture: " + event.errorMessage );
                return;
            }

            Logger.log( "Profile picture loaded" );
            mProfilePicture = Image.fromBitmap( event.profilePicture, false, Constants.scaleFactor );
            addChildAt( mProfilePicture, 0 );
        }

        /**
         *
         *
         * Getters / Setters
         *
         *
         */

        public function get permissions():Vector.<String> {
            return mPermissions;
        }

        public function set permissions( value:Vector.<String> ):void {
            mPermissions = value;
        }

    }

}
