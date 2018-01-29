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

package com.marpies.ane.facebook {

	import com.marpies.ane.facebook.data.AIRFacebookLinkParameter;
	import com.marpies.ane.facebook.data.BasicUserProfile;
	import com.marpies.ane.facebook.data.ExtendedUserProfile;
	import com.marpies.ane.facebook.events.AIRFacebookBasicUserProfileEvent;
	import com.marpies.ane.facebook.events.AIRFacebookCachedAccessTokenEvent;
	import com.marpies.ane.facebook.events.AIRFacebookDeferredAppLinkEvent;
	import com.marpies.ane.facebook.events.AIRFacebookEvent;
	import com.marpies.ane.facebook.events.AIRFacebookExtendedUserProfileEvent;
	import com.marpies.ane.facebook.events.AIRFacebookLoginEvent;
	import com.marpies.ane.facebook.events.AIRFacebookLogoutEvent;
	import com.marpies.ane.facebook.events.AIRFacebookUserFriendsEvent;
	import com.marpies.ane.facebook.events.AIRFacebookUserProfilePictureEvent;
	import com.marpies.ane.facebook.games.AIRFacebookGameRequests;
	import com.marpies.ane.facebook.games.IAIRFacebookGameRequests;
	import com.marpies.ane.facebook.graph.AIRFacebookOpenGraph;
	import com.marpies.ane.facebook.graph.IAIRFacebookOpenGraph;
	import com.marpies.ane.facebook.listeners.IAIRFacebookBasicUserProfileListener;
	import com.marpies.ane.facebook.listeners.IAIRFacebookCachedAccessTokenListener;
	import com.marpies.ane.facebook.listeners.IAIRFacebookDeferredAppLinkListener;
	import com.marpies.ane.facebook.listeners.IAIRFacebookExtendedUserProfileListener;
	import com.marpies.ane.facebook.listeners.IAIRFacebookLoginListener;
	import com.marpies.ane.facebook.listeners.IAIRFacebookLogoutListener;
	import com.marpies.ane.facebook.listeners.IAIRFacebookSDKInitListener;
	import com.marpies.ane.facebook.listeners.IAIRFacebookUserFriendsListener;
	import com.marpies.ane.facebook.listeners.IAIRFacebookUserProfilePictureListener;
	import com.marpies.ane.facebook.share.AIRFacebookShare;
	import com.marpies.ane.facebook.share.IAIRFacebookShare;

	import flash.display.Bitmap;
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.StatusEvent;
	import flash.external.ExtensionContext;
	import flash.net.URLRequest;

	/**
	 * @private
	 */
	internal class BaseAIRFacebook extends AIRFacebookListenerMap implements IAIRFacebook {

		protected static const TAG:String = "[AIRFacebook]";
		protected static const EXTENSION_ID:String = "com.marpies.ane.facebook";

		// Event codes
		protected const LOGIN_ERROR:String = "loginError";
		protected const LOGIN_CANCEL:String = "loginCancel";
		protected const LOGIN_SUCCESS:String = "loginSuccess";

		protected const LOGOUT_ERROR:String = "logoutError";
		protected const LOGOUT_CANCEL:String = "logoutCancel";
		protected const LOGOUT_SUCCESS:String = "logoutSuccess";

		protected const BASIC_PROFILE_READY:String = "basicProfileReady";
		protected const EXTENDED_PROFILE_LOADED:String = "extendedProfileLoaded";
		protected const EXTENDED_PROFILE_REQUEST_ERROR:String = "extendedProfileRequestError";

		protected const USER_FRIENDS_LOADED:String = "userFriendsLoaded";
		protected const USER_FRIENDS_REQUEST_ERROR:String = "userFriendsRequestError";

		protected const CACHED_ACCESS_TOKEN_LOADED:String = "cachedAccessTokenLoaded";

		protected const DEFERRED_APP_LINK:String = "deferredAppLink";

		protected const SDK_INIT:String = "sdkInit";

		// Listeners
		protected var _initBasicUserProfileListener:IAIRFacebookBasicUserProfileListener; // Used only for init() call
		protected var _sdkInitListener:IAIRFacebookSDKInitListener; // Used only for init() call
		protected var _basicUserProfileListeners:Vector.<IAIRFacebookBasicUserProfileListener>;

		// Facebook
		protected var _share:IAIRFacebookShare;
		protected var _openGraph:IAIRFacebookOpenGraph;
		protected var _gameRequests:IAIRFacebookGameRequests;
		protected var _basicProfile:BasicUserProfile;
		protected var _extendedProfile:ExtendedUserProfile;
		protected var _applicationId:String;

		// Misc
		protected var _settings:AIRFacebookSettings;
		protected var _context:ExtensionContext;
		protected var _logEnabled:Boolean;

		public function BaseAIRFacebook() {
			super();

			_settings = new AIRFacebookSettings();

			// Initialize context
			try {
				_context = ExtensionContext.createExtensionContext( EXTENSION_ID, null );
				if( _context == null ) {
					log( "Error creating extension context for " + EXTENSION_ID );
				}
			} catch( e:Error ) {
				log( "Error creating extension: " + e.message );
			}

			// Initialize Game Requests API here to get any invoke notifications
			_gameRequests = new AIRFacebookGameRequests( this, _context );
		}

		/**
		 *
		 *
		 * Public API
		 *
		 *
		 */

		/**
		 * @inheritDoc
		 */
		public function init( applicationId:String,
							  cachedAccessTokenListener:IAIRFacebookCachedAccessTokenListener = null,
							  basicUserProfileListener:IAIRFacebookBasicUserProfileListener = null,
							  sdkInitListener:IAIRFacebookSDKInitListener = null ):Boolean {
			if( _context == null ) {
				return false;
			}

			if( isInitialized ) {
				return true;
			}

			// Listen for native library events
			_context.addEventListener( StatusEvent.STATUS, onStatus );

			_logEnabled = settings.showLogs;

			// Store application id in case it is needed by some of the API calls
			_applicationId = applicationId;

			// Set basic user profile listener
			_initBasicUserProfileListener = basicUserProfileListener;

			// Set SDK init listener
			_sdkInitListener = sdkInitListener;

			// Call init
			_context.call(
					"init",
					applicationId,
					settings.urlSchemeSuffix,
					settings.showLogs,
					registerListener( cachedAccessTokenListener )
			);

			return true;
		}

		/**
		 * @inheritDoc
		 */
		public function addBasicUserProfileListener( listener:IAIRFacebookBasicUserProfileListener ):void {
			if( !listener ) return;
			if( _initBasicUserProfileListener == listener ) return;

			if( !_basicUserProfileListeners ) {
				_basicUserProfileListeners = new <IAIRFacebookBasicUserProfileListener>[];
			}
			if( _basicUserProfileListeners.indexOf( listener ) == -1 ) {
				_basicUserProfileListeners[_basicUserProfileListeners.length] = listener;
			}
		}

		/**
		 * @inheritDoc
		 */
		public function removeBasicUserProfileListener( listener:IAIRFacebookBasicUserProfileListener ):void {
			if( !listener ) return;
			if( !_basicUserProfileListeners ) return;

			const index:int = _basicUserProfileListeners.indexOf( listener );
			if( index != -1 ) {
				_basicUserProfileListeners.splice( index, 1 );
			}
		}

		/**
		 * @inheritDoc
		 */
		public function logout( confirm:Boolean = false,
									   title:String = "Log out from Facebook?",
									   message:String = "You will not be able to connect with friends!",
									   confirmLabel:String = "Log out",
									   cancelLabel:String = "Cancel",
									   listener:IAIRFacebookLogoutListener = null ):void {
			if( !isSupported ) {
				return;
			}

			if( confirm ) {
				if( !title ) {
					throw new ArgumentError( "Parameter title cannot be null when requesting confirmation dialog." );
				}

				if( !message ) {
					throw new ArgumentError( "Parameter message cannot be null when requesting confirmation dialog." );
				}

				if( !confirmLabel ) {
					throw new ArgumentError( "Parameter confirmLabel cannot be null when requesting confirmation dialog." );
				}

				if( !cancelLabel ) {
					throw new ArgumentError( "Parameter cancelLabel cannot be null when requesting confirmation dialog." );
				}
			}

			_context.call( "logout", confirm, title, message, confirmLabel, cancelLabel, registerListener( listener ) );
		}

		/**
		 * @inheritDoc
		 */
		public function requestUserProfilePicture( width:int, height:int, autoLoad:Boolean = false, listener:IAIRFacebookUserProfilePictureListener = null ):String {
			if( !isSupported ) {
				return null;
			}

			if( width < 1 || height < 1 ) throw new ArgumentError( "Invalid width and height specified - width (" + width + ") height (" + height + ")" );

			// Load the picture if requested
			var profilePictureURI:String = String( _context.call( "getUserProfilePictureUri", width, height ) );
			if( autoLoad && profilePictureURI ) {
				loadUserProfilePicture( profilePictureURI, listener );
			}
			return profilePictureURI;
		}

		/**
		 * @inheritDoc
		 */
		public function requestExtendedUserProfile( fields:Vector.<String> = null, forceRefresh:Boolean = false, listener:IAIRFacebookExtendedUserProfileListener = null ):ExtendedUserProfile {
			if( !isSupported ) {
				return null;
			}

			// Load the profile from server if we do not want to use cached
			// version or the cached version of the profile is not available
			if( forceRefresh || !_extendedProfile || !_extendedProfile.id ) {
				if( !fields ) {
					fields = new <String>["id", "name", "link"];
				}
				_context.call( "requestExtendedUserProfile", fields, registerListener( listener ) );
				return null;
			}

			// Cached version is available and we want to use it
			return _extendedProfile;
		}

		/**
		 * @inheritDoc
		 */
		public function requestUserFriends( fields:Vector.<String> = null, listener:IAIRFacebookUserFriendsListener = null ):void {
			if( !isSupported ) {
				return;
			}


			if( !fields ) {
				fields = new <String>["id", "name", "link"];
			}

			_context.call( "requestUserFriends", fields, registerListener( listener ) );
		}

		/**
		 * @inheritDoc
		 */
		public function isPermissionGranted( permission:String ):Boolean {
			if( !isSupported ) {
				return false;
			}

			if( !permission ) {
				throw new ArgumentError( "Parameter permission cannot be null." );
			}

			return _context.call( "isPermissionGranted", permission ) as Boolean;
		}

		/**
		 * @inheritDoc
		 */
		public function loginWithReadPermissions( permissions:Vector.<String> = null, listener:IAIRFacebookLoginListener = null ):void {
			if( !isSupported ) {
				return;
			}

			_context.call( "loginWithPermissions", permissions, "READ", registerListener( listener ) );
		}

		/**
		 * @inheritDoc
		 */
		public function loginWithPublishPermissions( permissions:Vector.<String> = null, listener:IAIRFacebookLoginListener = null ):void {
			if( !isSupported ) {
				return;
			}

			_context.call( "loginWithPermissions", permissions, "PUBLISH", registerListener( listener ) );
		}

		/**
		 * @inheritDoc
		 */
		public function logEvent( eventName:String, parameters:Object = null, valueToSum:Number = 0.0 ):void {
			if( !isSupported ) {
				return;
			}

			// List of object properties
			var params:Vector.<String> = getVectorFromObject( parameters );

			_context.call( "logEvent", eventName, params, valueToSum );
		}

		/**
		 * @inheritDoc
		 */
		public function fetchDeferredAppLink( listener:IAIRFacebookDeferredAppLinkListener = null ):void {
			if( !isSupported ) {
				return;
			}

			_context.call( "fetchDeferredAppLink", registerListener( listener ) );
		}

		/**
		 * @inheritDoc
		 */
		override public function dispose():void {
			if( !isSupported ) {
				return;
			}

			_context.removeEventListener( StatusEvent.STATUS, onStatus );
			_context.dispose();
			_context = null;

			if( _basicUserProfileListeners ) {
				_basicUserProfileListeners.length = 0;
				_basicUserProfileListeners = null;
			}

			super.dispose();
		}

		/**
		 *
		 *
		 * Getters / Setters
		 *
		 *
		 */

		/**
		 * @inheritDoc
		 */
		public function get openGraph():IAIRFacebookOpenGraph {
			if( _openGraph == null ) {
				_openGraph = new AIRFacebookOpenGraph( this, _context );
			}
			return _openGraph;
		}

		/**
		 * @inheritDoc
		 */
		public function get gameRequests():IAIRFacebookGameRequests {
			return _gameRequests;
		}

		/**
		 * @inheritDoc
		 */
		public function get share():IAIRFacebookShare {
			if( _share == null ) {
				_share = new AIRFacebookShare( this, _context );
			}
			return _share;
		}

		/**
		 * @inheritDoc
		 */
		public function get settings():AIRFacebookSettings {
			return _settings;
		}

		/**
		 * @inheritDoc
		 */
		public function get applicationId():String {
			return _applicationId;
		}

		/**
		 * @inheritDoc
		 */
		public function get isSupported():Boolean {
			return false;
		}

		/**
		 * @inheritDoc
		 */
		public function get isInitialized():Boolean {
			return isSupported && (_context != null) && (_context.call( "isInitialized" ) as Boolean);
		}

		/**
		 * @inheritDoc
		 */
		public function get isBasicUserProfileReady():Boolean {
			if( !isSupported ) {
				return false;
			}
			return _basicProfile != null;
		}

		/**
		 * @inheritDoc
		 */
		public function get basicUserProfile():BasicUserProfile {
			return _basicProfile;
		}

		/**
		 * @inheritDoc
		 */
		public function get isUserLoggedIn():Boolean {
			if( !isSupported ) {
				return false;
			}

			return _context.call( "isUserLoggedIn" ) as Boolean;
		}

		/**
		 * @inheritDoc
		 */
		public function get accessToken():String {
			if( !isSupported ) {
				return null;
			}

			return _context.call( "getAccessToken" ) as String;
		}

		/**
		 * @inheritDoc
		 */
		public function get accessTokenExpirationTimestamp():Number {
			if( !isSupported ) {
				return 0;
			}

			return _context.call( "getExpirationTimestamp" ) as Number;
		}

		/**
		 * @inheritDoc
		 */
		public function get isAccessTokenExpired():Boolean {
			if( !isSupported ) {
				return true;
			}

			return _context.call( "isAccessTokenExpired" ) as Boolean;
		}

		/**
		 * @inheritDoc
		 */
		public function get grantedPermissions():Vector.<String> {
			if( !isSupported ) {
				return null;
			}

			return _context.call( "getGrantedPermissions" ) as Vector.<String>;
		}

		/**
		 * @inheritDoc
		 */
		public function get deniedPermissions():Vector.<String> {
			if( !isSupported ) {
				return null;
			}

			return _context.call( "getDeniedPermissions" ) as Vector.<String>;
		}

		/**
		 * @inheritDoc
		 */
		public function get sdkVersion():String {
			if( !isSupported ) {
				return null;
			}

			return _context.call( "getSDKVersion" ) as String;
		}

		/**
		 *
		 *
		 * Private API
		 *
		 *
		 */

		private function loadUserProfilePicture( pictureURI:String, listener:IAIRFacebookUserProfilePictureListener ):void {
			log( "Auto Loading of profile pic " + pictureURI );
			const loader:Loader = new Loader();
			loader.contentLoaderInfo.addEventListener( Event.INIT, onProfilePictureLoaded );
			loader.contentLoaderInfo.addEventListener( IOErrorEvent.IO_ERROR, onProfilePictureLoadFailed );
			loader.load( new URLRequest( pictureURI ) );

			function onProfilePictureLoaded( event:Event ):void {
				loader.contentLoaderInfo.removeEventListener( Event.INIT, onProfilePictureLoaded );
				loader.contentLoaderInfo.removeEventListener( IOErrorEvent.IO_ERROR, onProfilePictureLoadFailed );

				// Dispatch event
				const profilePictureEvent:AIRFacebookUserProfilePictureEvent = new AIRFacebookUserProfilePictureEvent( AIRFacebookUserProfilePictureEvent.RESULT );
				profilePictureEvent.ns_airfacebook_internal::profilePicture = loader.content as Bitmap;
				dispatchEvent( profilePictureEvent );

				// Listener
				if( listener != null ) {
					listener.onFacebookUserProfilePictureSuccess( profilePictureEvent.profilePicture );
				}
			}

			function onProfilePictureLoadFailed( event:IOErrorEvent ):void {
				loader.contentLoaderInfo.removeEventListener( Event.INIT, onProfilePictureLoaded );
				loader.contentLoaderInfo.removeEventListener( IOErrorEvent.IO_ERROR, onProfilePictureLoadFailed );

				// Dispatch event
				const profilePictureEvent:AIRFacebookUserProfilePictureEvent = new AIRFacebookUserProfilePictureEvent( AIRFacebookUserProfilePictureEvent.RESULT );
				profilePictureEvent.ns_airfacebook_internal::errorMessage = "Error loading user's profile picture: " + event.text;
				dispatchEvent( profilePictureEvent );

				// Listener
				if( listener != null ) {
					listener.onFacebookUserProfilePictureError( "Error loading user's profile picture: " + event.text );
				}
			}
		}

		private function getAppLinkParameters( parameters:Array ):Vector.<AIRFacebookLinkParameter> {
			if( !parameters ) return null;

			const linkParams:Vector.<AIRFacebookLinkParameter> = new <AIRFacebookLinkParameter>[];
			const length:uint = parameters.length;
			for( var i:uint = 0; i < length; ) {
				const param:AIRFacebookLinkParameter = new AIRFacebookLinkParameter();
				param.ns_airfacebook_internal::name = parameters[i++];
				param.ns_airfacebook_internal::value = parameters[i++];
				linkParams[linkParams.length] = param;
			}
			return linkParams;
		}

		/**
		 *
		 *
		 * Native event handling
		 *
		 *
		 */

		private function onStatus( event:StatusEvent ):void {
			switch( event.code ) {
				// Cached access token
				case CACHED_ACCESS_TOKEN_LOADED:
					onCachedAccessTokenHandler( JSON.parse( event.level ) );
					return;

				// Login success - set denied and granted permissions
				case LOGIN_SUCCESS:
					onLoginSuccessHandler( JSON.parse( event.level ) );
					return;

				// Login error - set error message
				case LOGIN_ERROR:
					onLoginErrorHandler( JSON.parse( event.level ) );
					return;

				// Login error - set cancel flag
				case LOGIN_CANCEL:
					onLoginCancelHandler( JSON.parse( event.level ) );
					return;

				// Logout success - no need to set any property
				case LOGOUT_SUCCESS:
					onLogoutSuccessHandler( JSON.parse( event.level ) );
					return;

				// Logout error - set error message
				case LOGOUT_ERROR:
					onLogoutErrorHandler( JSON.parse( event.level ) );
					return;

				// Logout cancel - set cancel flag
				case LOGOUT_CANCEL:
					onLogoutCancelHandler( JSON.parse( event.level ) );
					return;

				// Basic profile ready
				case BASIC_PROFILE_READY:
					onBasicUserProfileHandler( JSON.parse( event.level ) );
					return;

				// Profile request success - set profile instance
				case EXTENDED_PROFILE_LOADED:
					onExtendedUserProfileSuccessHandler( JSON.parse( event.level ) );
					return;

				// Profile request error - set error message
				case EXTENDED_PROFILE_REQUEST_ERROR:
					onExtendedUserProfileErrorHandler( JSON.parse( event.level ) );
					return;

				// User appRequests request success - set friends or error message if data format is unexpected
				case USER_FRIENDS_LOADED:
					onFriendsSuccessHandler( JSON.parse( event.level ) );
					return;

				// User appRequests request error - set error message
				case USER_FRIENDS_REQUEST_ERROR:
					onFriendsErrorHandler( JSON.parse( event.level ) );
					return;

				// Deferred app link data
				case DEFERRED_APP_LINK:
					onDeferredAppLinkHandler( JSON.parse( event.level ) );
					return;

				// Facebook SDK init
				case SDK_INIT:
					onFacebookSDKInit();
					return;
			}

		}

		/**
		 * CACHED ACCESS TOKEN
		 */

		private function onCachedAccessTokenHandler( eventJSON:Object ):void {
			// Dispatch event
			const cachedAccessTokenEvent:AIRFacebookCachedAccessTokenEvent = new AIRFacebookCachedAccessTokenEvent( AIRFacebookCachedAccessTokenEvent.RESULT );
			cachedAccessTokenEvent.ns_airfacebook_internal::wasLoaded = eventJSON.found == "true";
			dispatchEvent( cachedAccessTokenEvent );

			// Listener
			const listenerID:int = eventJSON.listenerID;
			const listener:IAIRFacebookCachedAccessTokenListener = popListener( listenerID ) as IAIRFacebookCachedAccessTokenListener;
			if( listener != null ) {
				if( eventJSON.found == "true" ) {
					listener.onFacebookCachedAccessTokenLoaded();
				} else {
					listener.onFacebookCachedAccessTokenNotLoaded();
				}
			}
		}

		/**
		 * LOGIN
		 */

		private function onLoginSuccessHandler( eventJSON:Object ):void {
			const deniedPermissions:String = eventJSON.denied_permissions;
			const grantedPermissions:String = eventJSON.granted_permissions;

			// Dispatch event
			const event:AIRFacebookLoginEvent = new AIRFacebookLoginEvent( AIRFacebookLoginEvent.LOGIN_RESULT );
			event.ns_airfacebook_internal::deniedPermissions = Vector.<String>( deniedPermissions.slice( 1, deniedPermissions.length - 1 ).split( "," ) as Array );
			event.ns_airfacebook_internal::grantedPermissions = Vector.<String>( grantedPermissions.slice( 1, grantedPermissions.length - 1 ).split( "," ) as Array );
			dispatchEvent( event );

			// Listener
			const listenerID:int = eventJSON.listenerID;
			const listener:IAIRFacebookLoginListener = popListener( listenerID ) as IAIRFacebookLoginListener;
			if( listener != null ) {
				listener.onFacebookLoginSuccess( event.deniedPermissions, event.grantedPermissions );
			}
		}

		private function onLoginErrorHandler( eventJSON:Object ):void {
			// Dispatch event
			const event:AIRFacebookLoginEvent = new AIRFacebookLoginEvent( AIRFacebookLoginEvent.LOGIN_RESULT );
			event.ns_airfacebook_internal::errorMessage = eventJSON.errorMessage;
			dispatchEvent( event );

			// Listener
			const listenerID:int = eventJSON.listenerID;
			const listener:IAIRFacebookLoginListener = popListener( listenerID ) as IAIRFacebookLoginListener;
			if( listener != null ) {
				listener.onFacebookLoginError( eventJSON.errorMessage );
			}
		}

		private function onLoginCancelHandler( eventJSON:Object ):void {
			// Dispatch event
			const event:AIRFacebookLoginEvent = new AIRFacebookLoginEvent( AIRFacebookLoginEvent.LOGIN_RESULT );
			event.ns_airfacebook_internal::wasCancelled = true;
			dispatchEvent( event );

			// Listener
			const listenerID:int = eventJSON.listenerID;
			const listener:IAIRFacebookLoginListener = popListener( listenerID ) as IAIRFacebookLoginListener;
			if( listener != null ) {
				listener.onFacebookLoginCancel();
			}
		}

		/**
		 * LOGOUT
		 */

		private function onLogoutSuccessHandler( eventJSON:Object ):void {
			_basicProfile = null;
			_extendedProfile = null;

			// Dispatch event
			const event:AIRFacebookLogoutEvent = new AIRFacebookLogoutEvent( AIRFacebookLogoutEvent.LOGOUT_RESULT );
			dispatchEvent( event );

			// Listener
			const listenerID:int = eventJSON.listenerID;
			const listener:IAIRFacebookLogoutListener = popListener( listenerID ) as IAIRFacebookLogoutListener;
			if( listener != null ) {
				listener.onFacebookLogoutSuccess();
			}
		}

		private function onLogoutErrorHandler( eventJSON:Object ):void {
			// Dispatch event
			const event:AIRFacebookLogoutEvent = new AIRFacebookLogoutEvent( AIRFacebookLogoutEvent.LOGOUT_RESULT );
			event.ns_airfacebook_internal::errorMessage = eventJSON.errorMessage;
			dispatchEvent( event );

			// Listener
			const listenerID:int = eventJSON.listenerID;
			const listener:IAIRFacebookLogoutListener = popListener( listenerID ) as IAIRFacebookLogoutListener;
			if( listener != null ) {
				listener.onFacebookLogoutError( event.errorMessage );
			}
		}

		private function onLogoutCancelHandler( eventJSON:Object ):void {
			// Dispatch event
			const event:AIRFacebookLogoutEvent = new AIRFacebookLogoutEvent( AIRFacebookLogoutEvent.LOGOUT_RESULT );
			event.ns_airfacebook_internal::wasCancelled = true;
			dispatchEvent( event );

			// Listener
			const listenerID:int = eventJSON.listenerID;
			const listener:IAIRFacebookLogoutListener = popListener( listenerID ) as IAIRFacebookLogoutListener;
			if( listener != null ) {
				listener.onFacebookLogoutCancel();
			}
		}

		/**
		 * BASIC USER PROFILE
		 */

		private function onBasicUserProfileHandler( eventJSON:Object ):void {
			if( !_basicProfile ) {
				_basicProfile = new BasicUserProfile();
			}
			_basicProfile.ns_airfacebook_internal::clear();
			_basicProfile.ns_airfacebook_internal::properties = eventJSON;

			// Dispatch event
			const basicUserProfileEvent:AIRFacebookBasicUserProfileEvent = new AIRFacebookBasicUserProfileEvent( AIRFacebookBasicUserProfileEvent.PROFILE_READY );
			basicUserProfileEvent.ns_airfacebook_internal::basicUserProfile = _basicProfile;
			dispatchEvent( basicUserProfileEvent );

			// Listeners
			if( _basicUserProfileListeners ) {
				const length:uint = _basicUserProfileListeners.length;
				for( var i:uint = 0; i < length; i++ ) {
					_basicUserProfileListeners[i].onFacebookBasicUserProfileReady( _basicProfile );
				}
			}

			// Init only listener
			if( _initBasicUserProfileListener ) {
				_initBasicUserProfileListener.onFacebookBasicUserProfileReady( _basicProfile );
				_initBasicUserProfileListener = null;
			}
		}

		/**
		 * EXTENDED USER PROFILE
		 */

		private function onExtendedUserProfileSuccessHandler( eventJSON:Object ):void {
			if( !_extendedProfile ) {
				_extendedProfile = new ExtendedUserProfile();
			}
			_extendedProfile.ns_airfacebook_internal::clear();
			_extendedProfile.ns_airfacebook_internal::properties = eventJSON;
			// Dispatch event
			const event:AIRFacebookExtendedUserProfileEvent = new AIRFacebookExtendedUserProfileEvent( AIRFacebookExtendedUserProfileEvent.PROFILE_LOADED );
			event.ns_airfacebook_internal::extendedUserProfile = _extendedProfile;
			dispatchEvent( event );

			// Listener
			const listenerID:int = eventJSON.listenerID;
			const listener:IAIRFacebookExtendedUserProfileListener = popListener( listenerID ) as IAIRFacebookExtendedUserProfileListener;
			if( listener != null ) {
				listener.onFacebookExtendedUserProfileSuccess( _extendedProfile );
			}
		}

		private function onExtendedUserProfileErrorHandler( eventJSON:Object ):void {
			// Dispatch event
			const event:AIRFacebookExtendedUserProfileEvent = new AIRFacebookExtendedUserProfileEvent( AIRFacebookExtendedUserProfileEvent.PROFILE_LOADED );
			event.ns_airfacebook_internal::errorMessage = eventJSON.errorMessage;
			dispatchEvent( event );

			// Listener
			const listenerID:int = eventJSON.listenerID;
			const listener:IAIRFacebookExtendedUserProfileListener = popListener( listenerID ) as IAIRFacebookExtendedUserProfileListener;
			if( listener != null ) {
				listener.onFacebookExtendedUserProfileError( event.errorMessage );
			}
		}

		/**
		 * FRIENDS
		 */

		private function onFriendsSuccessHandler( eventJSON:Object ):void {
			const event:AIRFacebookUserFriendsEvent = new AIRFacebookUserFriendsEvent( AIRFacebookUserFriendsEvent.REQUEST_RESULT );
			const listenerID:int = eventJSON.listenerID;
			const listener:IAIRFacebookUserFriendsListener = popListener( listenerID ) as IAIRFacebookUserFriendsListener;

			if( "friends" in eventJSON && eventJSON.friends is Array ) {
				// Friends are represented by ExtendedUserProfile class
				const friends:Vector.<ExtendedUserProfile> = new <ExtendedUserProfile>[];
				const friendsProperties:Array = eventJSON.friends as Array;
				var length:uint = friendsProperties.length;

				// Create friends Vector
				for( var i:uint = 0; i < length; i++ ) {
					const friend:ExtendedUserProfile = new ExtendedUserProfile();
					friend.ns_airfacebook_internal::properties = friendsProperties[i];
					friends[friends.length] = friend;
				}

				// Set the result's list of friends
				event.ns_airfacebook_internal::friends = friends;
				// Dispatch event
				dispatchEvent( event );

				// Listener
				if( listener != null ) {
					listener.onFacebookUserFriendsSuccess( friends );
				}
			} else {
				// Set the result's error message
				event.ns_airfacebook_internal::errorMessage = "User friends request returned unexpected data " + eventJSON.errorMessage;
				// Dispatch event
				dispatchEvent( event );

				// Listener
				if( listener != null ) {
					listener.onFacebookUserFriendsError( event.errorMessage );
				}
			}
		}

		private function onFriendsErrorHandler( eventJSON:Object ):void {
			// Dispatch event
			const event:AIRFacebookUserFriendsEvent = new AIRFacebookUserFriendsEvent( AIRFacebookUserFriendsEvent.REQUEST_RESULT );
			event.ns_airfacebook_internal::errorMessage = eventJSON.errorMessage;
			dispatchEvent( event );

			// Listener
			const listenerID:int = eventJSON.listenerID;
			const listener:IAIRFacebookUserFriendsListener = popListener( listenerID ) as IAIRFacebookUserFriendsListener;
			if( listener != null ) {
				listener.onFacebookUserFriendsError( event.errorMessage );
			}
		}

		/**
		 * DEFERRED APP LINK
		 */

		private function onDeferredAppLinkHandler( eventJSON:Object ):void {
			// Dispatch event
			const event:AIRFacebookDeferredAppLinkEvent = new AIRFacebookDeferredAppLinkEvent( AIRFacebookDeferredAppLinkEvent.REQUEST_RESULT );
			event.ns_airfacebook_internal::linkNotFound = "notFound" in eventJSON;
			event.ns_airfacebook_internal::errorMessage = ("errorMessage" in eventJSON) ? eventJSON.errorMessage : null;
			var appLinkParameters:Vector.<AIRFacebookLinkParameter> = null;
			if( "parameters" in eventJSON ) {
				appLinkParameters = getAppLinkParameters( String( eventJSON.parameters ).split( "," ) );
			}
			event.ns_airfacebook_internal::parameters = appLinkParameters;
			event.ns_airfacebook_internal::targetURL = ("targetURL" in eventJSON) ? eventJSON.targetURL : null;
			dispatchEvent( event );

			// Listener
			const listenerID:int = eventJSON.listenerID;
			const listener:IAIRFacebookDeferredAppLinkListener = popListener( listenerID ) as IAIRFacebookDeferredAppLinkListener;
			if( listener != null ) {
				if( "errorMessage" in eventJSON ) {
					listener.onFacebookDeferredAppLinkError( event.errorMessage );
				} else if( event.linkNotFound ) {
					listener.onFacebookDeferredAppLinkNotFound();
				} else {
					listener.onFacebookDeferredAppLinkSuccess( event.targetURL, appLinkParameters );
				}
			}
		}

		/**
		 * FACEBOOK SDK INIT
		 */

		private function onFacebookSDKInit():void {
			// Dispatch event
			dispatchEvent( new AIRFacebookEvent( AIRFacebookEvent.SDK_INIT ) );

			// Listener
			if( _sdkInitListener != null ) {
				_sdkInitListener.onFacebookSDKInitialized();
				_sdkInitListener = null;
			}
		}

		/**
		 *
		 *
		 * Protected API
		 *
		 *
		 */

		protected function log( message:String ):void {
			if( _logEnabled ) {
				trace( TAG, message );
			}
		}

	}

}
