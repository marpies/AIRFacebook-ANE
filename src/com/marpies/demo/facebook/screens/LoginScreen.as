package com.marpies.demo.facebook.screens {

    import com.marpies.ane.facebook.AIRFacebook;
    import com.marpies.ane.facebook.data.AIRFacebookLinkParameter;
    import com.marpies.ane.facebook.data.BasicUserProfile;
    import com.marpies.ane.facebook.events.AIRFacebookBasicUserProfileEvent;
    import com.marpies.ane.facebook.events.AIRFacebookCachedAccessTokenEvent;
    import com.marpies.ane.facebook.events.AIRFacebookDeferredAppLinkEvent;
    import com.marpies.ane.facebook.events.AIRFacebookEvent;
    import com.marpies.ane.facebook.events.AIRFacebookLoginEvent;
    import com.marpies.ane.facebook.events.AIRFacebookLogoutEvent;
    import com.marpies.ane.facebook.events.AIRFacebookUserProfilePictureEvent;
    import com.marpies.ane.facebook.listeners.IAIRFacebookBasicUserProfileListener;
    import com.marpies.ane.facebook.listeners.IAIRFacebookCachedAccessTokenListener;
    import com.marpies.ane.facebook.listeners.IAIRFacebookDeferredAppLinkListener;
    import com.marpies.ane.facebook.listeners.IAIRFacebookGameRequestInvokeListener;
    import com.marpies.ane.facebook.listeners.IAIRFacebookLoginListener;
    import com.marpies.ane.facebook.listeners.IAIRFacebookLogoutListener;
    import com.marpies.ane.facebook.listeners.IAIRFacebookSDKInitListener;
    import com.marpies.ane.facebook.listeners.IAIRFacebookUserProfilePictureListener;
    import com.marpies.utils.AlertManager;
    import com.marpies.utils.Constants;
    import com.marpies.utils.Logger;
    import com.marpies.utils.VerticalLayoutBuilder;

    import feathers.controls.Button;
    import feathers.controls.Label;
    import feathers.controls.PickerList;
    import feathers.data.ListCollection;
    import feathers.layout.VerticalLayout;

    import flash.display.Bitmap;
    import flash.net.URLVariables;

    import starling.display.DisplayObject;
    import starling.display.Image;
    import starling.events.Event;

    public class LoginScreen extends BaseScreen implements
            IAIRFacebookCachedAccessTokenListener,
            IAIRFacebookBasicUserProfileListener,
            IAIRFacebookDeferredAppLinkListener,
            IAIRFacebookUserProfilePictureListener,
            IAIRFacebookLoginListener,
            IAIRFacebookLogoutListener,
            IAIRFacebookGameRequestInvokeListener,
            IAIRFacebookSDKInitListener {

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

            /* We could add listeners to these events here but this screen implements
             * 'IAIRFacebookCachedAccessTokenListener', 'IAIRFacebookBasicUserProfileListener', 'IAIRFacebookSDKInitListener' */
            //AIRFacebook.addEventListener( AIRFacebookCachedAccessTokenEvent.RESULT, onCachedAccessTokenResult );
            //AIRFacebook.addEventListener( AIRFacebookBasicUserProfileEvent.PROFILE_READY, onBasicUserProfileReady );
//            AIRFacebook.addEventListener( AIRFacebookEvent.SDK_INIT, onFacebookSDKInit );

            /* Setting 'cached token', 'basic user profile' and 'sdk init' listeners during initialization */
            if( AIRFacebook.init( FACEBOOK_APP_ID, false, null, true, this, this, this ) ) {
                /* We want to know when app is invoked from a Facebook Game Request notification */
                AIRFacebook.addGameRequestInvokeListener( this );   // Or we could use the standard event listener wth AIRFacebookGameRequestInvokeEvent.INVOKE
                Logger.log( "Initialized extension context" );
            } else {
                Logger.log( "Failed to initialize extension context for AIRFacebook" );
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
                } else {
                    mUserLabel.text = "Not logged in.";
                    if( mProfilePicture ) {
                        mProfilePicture.removeFromParent( true );
                        mProfilePicture.texture.dispose();
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

            /* We could add listener to LOGIN_RESULT event but this screen implements 'IAIRFacebookLoginListener'.
             * By passing 'this' to login methods, one of the methods defined by that interface will be called after login */
            //AIRFacebook.addEventListener( AIRFacebookLoginEvent.LOGIN_RESULT, onLoginResult );

            /* READ selected in the PickerList */
            if( mLoginTypeList.selectedIndex == 0 ) {
                AIRFacebook.loginWithReadPermissions( mPermissions, this );
            }
            /* PUBLISH selected in the PickerList */
            else {
                AIRFacebook.loginWithPublishPermissions( mPermissions, this );
            }
        }

        private function onLogoutButtonTriggered():void {
            /* We could add listener to LOGOUT_RESULT event but this screen implements 'IAIRFacebookLogoutListener'.
             * By passing 'this' to logout method, one of the methods defined by that interface will be called after logout */
            //AIRFacebook.addEventListener( AIRFacebookLogoutEvent.LOGOUT_RESULT, onLogoutResult );

            AIRFacebook.logout( true, "Log out from Facebook?", "You will not be able to connect with friends!", "Log out", "Cancel", this );
        }

        private function onPermissionsButtonTriggered():void {
            dispatchEventWith( "show" + Screens.PERMISSIONS );
        }

        /**
         *
         *
         * AIRFacebook handlers (methods defined by IAIRFacebook******* interfaces)
         *
         *
         */

        /**
         * Facebook SDK init
         */

        public function onFacebookSDKInitialized():void {
            Logger.log( "Facebook SDK initialized " + AIRFacebook.sdkVersion );
        }

        /**
         * Cached access token
         */

        public function onFacebookCachedAccessTokenLoaded():void {
            /* This screen implements 'IAIRFacebookDeferredAppLinkListener', no need for event listener */
            //AIRFacebook.addEventListener( AIRFacebookDeferredAppLinkEvent.REQUEST_RESULT, onDeferredAppLinkResult );

            Logger.log( "Access token was loaded from cache - fetching deferred app link" );
            AIRFacebook.fetchDeferredAppLink( this );
            refreshUI();
        }

        public function onFacebookCachedAccessTokenNotLoaded():void {
            Logger.log( "Access token was NOT found" );
        }

        /**
         * Deferred app link
         */

        public function onFacebookDeferredAppLinkSuccess( targetURL:String, parameters:Vector.<AIRFacebookLinkParameter> ):void {
            Logger.log( "Deferred app link success | targetURL: " + targetURL + " | parameters: " + parameters );
        }

        public function onFacebookDeferredAppLinkNotFound():void {
            Logger.log( "Deferred app link not found" );
        }

        public function onFacebookDeferredAppLinkError( errorMessage:String ):void {
            Logger.log( "Deferred app link error: " + errorMessage );
        }

        /**
         * Basic user profile ready
         */

        public function onFacebookBasicUserProfileReady( user:BasicUserProfile ):void {
            Logger.log( "Basic user profile ready" );

            /* This screen implements 'IAIRFacebookUserProfilePictureListener', no need for event listener */
            //AIRFacebook.addEventListener( AIRFacebookUserProfilePictureEvent.RESULT, onProfilePictureResult );

            /* Load the profile picture */
            AIRFacebook.requestUserProfilePicture( 200, 200, true, this );

            refreshUI();
        }

        /**
         * Login
         */

        public function onFacebookLoginSuccess( deniedPermissions:Vector.<String>, grantedPermissions:Vector.<String> ):void {
            Logger.log( "Login successful \ndenied permissions:" + deniedPermissions + "\ngranted permissions: " + grantedPermissions + "\nfetching deferred app link" );
            AIRFacebook.fetchDeferredAppLink( this );
            if( !mProfilePicture ) {
                if( AIRFacebook.isBasicUserProfileReady ) {
                    /* This screen implements 'IAIRFacebookUserProfilePictureListener', no need for event listener */
                    //AIRFacebook.addEventListener( AIRFacebookUserProfilePictureEvent.RESULT, onProfilePictureResult );

                    /* Ignoring the returned URL as we want to have it auto loaded */
                    AIRFacebook.requestUserProfilePicture( 200, 200, true, this );
                }
            }

            refreshUI();
        }

        public function onFacebookLoginCancel():void {
            Logger.log( "Login cancelled" );
        }

        public function onFacebookLoginError( errorMessage:String ):void {
            Logger.log( "Login error: " + errorMessage );
        }

        /**
         * User profile picture
         */

        public function onFacebookUserProfilePictureSuccess( picture:Bitmap ):void {
            Logger.log( "Profile picture loaded" );
            mProfilePicture = Image.fromBitmap( picture, false, Constants.scaleFactor );
            addChildAt( mProfilePicture, 0 );
        }

        public function onFacebookUserProfilePictureError( errorMessage:String ):void {
            Logger.log( "Profile picture error: " + errorMessage );
        }

        /**
         * Logout
         */

        public function onFacebookLogoutSuccess():void {
            /* If user logs in again then we will want to know when the user profile is ready
             * (the listener that we added using AIRFacebook.init() call is only called once).
             * Adding the listener using this method it will be called until the moment we remove it. */
            AIRFacebook.addBasicUserProfileListener( this );

            Logger.log( "Log out success" );
            refreshUI();
        }

        public function onFacebookLogoutCancel():void {
            Logger.log( "Log out cancelled" );
        }

        public function onFacebookLogoutError( errorMessage:String ):void {
            Logger.log( "Log out error: " + errorMessage );
        }

        /**
         * Game Request Invoke
         */

        public function onFacebookGameRequestInvoke( requestIDs:Vector.<String>, URLVars:URLVariables, arguments:Array, fullURL:String, reason:String ):void {
            /* We can remove this listener, if no longer needed */
            //AIRFacebook.removeGameRequestInvokeListener( this );

            Logger.log( "Game request invoke: " + requestIDs );

            /* Now we could load Game Requests for current user using AIRFacebook.requestUserGameRequests()
             * and see which Game Requests the app was invoked with and do further processing. */
        }




        /**
         * Event handlers (just for demonstration purposes)
         */

        private function onCachedAccessTokenResult( event:AIRFacebookCachedAccessTokenEvent ):void {
            AIRFacebook.removeEventListener( AIRFacebookCachedAccessTokenEvent.RESULT, onCachedAccessTokenResult );
            Logger.log( "[EventHandler] Access token from cache: " + event.wasLoaded );
        }

        private function onLoginResult( event:AIRFacebookLoginEvent ):void {
            AIRFacebook.removeEventListener( AIRFacebookLoginEvent.LOGIN_RESULT, onLoginResult );

            if( event.errorMessage ) {
                Logger.log( "[EventHandler] Login error: " + event.errorMessage );
            } else if( event.wasCancelled ) {
                Logger.log( "[EventHandler] Login cancelled" );
            } else {
                Logger.log( "[EventHandler] Login successful" );
            }
        }

        private function onLogoutResult( event:AIRFacebookLogoutEvent ):void {
            AIRFacebook.removeEventListener( AIRFacebookLogoutEvent.LOGOUT_RESULT, onLogoutResult );

            if( event.errorMessage ) {
                Logger.log( "[EventHandler] Logout error: " + event.errorMessage );
            } else if( event.wasCancelled ) {
                Logger.log( "[EventHandler] Logout cancelled" );
            } else {
                Logger.log( "[EventHandler] Logout success" );
            }
        }

        private function onBasicUserProfileReady( event:AIRFacebookBasicUserProfileEvent ):void {
            AIRFacebook.removeEventListener( AIRFacebookBasicUserProfileEvent.PROFILE_READY, onBasicUserProfileReady );
            Logger.log( "[EventHandler] basic user profile ready" );
        }

        private function onProfilePictureResult( event:AIRFacebookUserProfilePictureEvent ):void {
            AIRFacebook.removeEventListener( AIRFacebookUserProfilePictureEvent.RESULT, onProfilePictureResult );
            if( event.errorMessage ) {
                Logger.log( "[EventHandler] Error loading profile picture: " + event.errorMessage );
                return;
            }
            Logger.log( "[EventHandler] Profile picture loaded" );
        }

        private function onDeferredAppLinkResult( event:AIRFacebookDeferredAppLinkEvent ):void {
            AIRFacebook.removeEventListener( AIRFacebookDeferredAppLinkEvent.REQUEST_RESULT, onDeferredAppLinkResult );
            if( event.linkNotFound ) {
                Logger.log( "[EventHandler] Deferred app link was not found" );
            } else {
                Logger.log( "[EventHandler] Deferred app link: " + event.targetURL + " | parameters: " + event.parameters );
            }
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
