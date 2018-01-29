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

	import com.marpies.ane.facebook.data.BasicUserProfile;
	import com.marpies.ane.facebook.data.ExtendedUserProfile;
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

	import flash.events.EventDispatcher;

	public class AIRFacebook extends EventDispatcher implements IAIRFacebook {

		public static function get VERSION():String {
			return AIRFACEBOOK_VERSION;
		}

		/* Singleton stuff */
		private static var mCanInitialize:Boolean;
		private static var mInstance:IAIRFacebook;

		private var _share:IAIRFacebookShare;
		private var _openGraph:IAIRFacebookOpenGraph;
		private var _gameRequests:IAIRFacebookGameRequests;
		private var _settings:AIRFacebookSettings;


		/**
		 * @private
		 */
		public function AIRFacebook() {
			super();

			if( !mCanInitialize ) {
				throw new Error( "AIRFacebook is a singleton, use instance getter." );
			}
		}

		public static function get instance():IAIRFacebook {
			if( !mInstance ) {
				mCanInitialize = true;
				mInstance = new AIRFacebook();
				mCanInitialize = false;
			}
			return mInstance;
		}

		public function init( applicationId:String, cachedAccessTokenListener:IAIRFacebookCachedAccessTokenListener = null, basicUserProfileListener:IAIRFacebookBasicUserProfileListener = null, sdkInitListener:IAIRFacebookSDKInitListener = null ):Boolean {
			return false;
		}

		public function addBasicUserProfileListener( listener:IAIRFacebookBasicUserProfileListener ):void {
		}

		public function removeBasicUserProfileListener( listener:IAIRFacebookBasicUserProfileListener ):void {
		}

		public function logout( confirm:Boolean = false, title:String = "Log out from Facebook?", message:String = "You will not be able to connect with friends!", confirmLabel:String = "Log out", cancelLabel:String = "Cancel", listener:IAIRFacebookLogoutListener = null ):void {
		}

		public function requestUserProfilePicture( width:int, height:int, autoLoad:Boolean = false, listener:IAIRFacebookUserProfilePictureListener = null ):String {
			return "";
		}

		public function requestExtendedUserProfile( fields:Vector.<String> = null, forceRefresh:Boolean = false, listener:IAIRFacebookExtendedUserProfileListener = null ):ExtendedUserProfile {
			return null;
		}

		public function requestUserFriends( fields:Vector.<String> = null, listener:IAIRFacebookUserFriendsListener = null ):void {
		}

		public function isPermissionGranted( permission:String ):Boolean {
			return false;
		}

		public function loginWithReadPermissions( permissions:Vector.<String> = null, listener:IAIRFacebookLoginListener = null ):void {
		}

		public function loginWithPublishPermissions( permissions:Vector.<String> = null, listener:IAIRFacebookLoginListener = null ):void {
		}

		public function logEvent( eventName:String, parameters:Object = null, valueToSum:Number = 0.0 ):void {
		}

		public function fetchDeferredAppLink( listener:IAIRFacebookDeferredAppLinkListener = null ):void {
		}

		public function dispose():void {
		}

		public function get openGraph():IAIRFacebookOpenGraph {
			if( _openGraph == null ) {
				_openGraph = new AIRFacebookOpenGraph( this, null );
			}
			return _openGraph;
		}

		public function get gameRequests():IAIRFacebookGameRequests {
			if( _gameRequests == null ) {
				_gameRequests = new AIRFacebookGameRequests( this, null );
			}
			return _gameRequests;
		}

		public function get share():IAIRFacebookShare {
			if( _share == null ) {
				_share = new AIRFacebookShare( this, null );
			}
			return _share;
		}

		public function get settings():AIRFacebookSettings {
			if( _settings == null ) {
				_settings = new AIRFacebookSettings();
			}
			return _settings;
		}

		public function get applicationId():String {
			return null;
		}

		public function get isSupported():Boolean {
			return false;
		}

		public function get isInitialized():Boolean {
			return false;
		}

		public function get isBasicUserProfileReady():Boolean {
			return false;
		}

		public function get basicUserProfile():BasicUserProfile {
			return null;
		}

		public function get isUserLoggedIn():Boolean {
			return false;
		}

		public function get accessToken():String {
			return null;
		}

		public function get accessTokenExpirationTimestamp():Number {
			return 0;
		}

		public function get isAccessTokenExpired():Boolean {
			return true;
		}

		public function get grantedPermissions():Vector.<String> {
			return null;
		}

		public function get deniedPermissions():Vector.<String> {
			return null;
		}

		public function get sdkVersion():String {
			return "";
		}
	}
}
