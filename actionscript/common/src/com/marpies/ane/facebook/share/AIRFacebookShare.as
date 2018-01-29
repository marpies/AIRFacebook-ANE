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

package com.marpies.ane.facebook.share {

	import com.marpies.ane.facebook.AIRFacebookListenerMap;
	import com.marpies.ane.facebook.IAIRFacebook;
	import com.marpies.ane.facebook.events.AIRFacebookShareEvent;
	import com.marpies.ane.facebook.listeners.IAIRFacebookAppInviteListener;
	import com.marpies.ane.facebook.listeners.IAIRFacebookShareListener;

	import flash.display.BitmapData;
	import flash.events.StatusEvent;

	import flash.external.ExtensionContext;

	/**
	 * @private
	 */
	public class AIRFacebookShare extends AIRFacebookListenerMap implements IAIRFacebookShare {

		protected const SHARE_ERROR:String = "shareError";
		protected const SHARE_CANCEL:String = "shareCancel";
		protected const SHARE_SUCCESS:String = "shareSuccess";

		private var _facebook:IAIRFacebook;
		private var _context:ExtensionContext;

		public function AIRFacebookShare( facebook:IAIRFacebook, context:ExtensionContext ) {
			_facebook = facebook;
			_context = context;
			if( _context != null ) {
				_context.addEventListener( StatusEvent.STATUS, onStatus );
			}
		}

		override public function dispose():void {
			super.dispose();

			if( _context != null ) {
				_context.removeEventListener( StatusEvent.STATUS, onStatus );
			}
		}

		/**
		 * @inheritDoc
		 */
		public function link( contentURL:String,
							  postWithoutUI:Boolean = false,
							  message:String = null,
							  listener:IAIRFacebookShareListener = null ):void {
			if( !canShareLink ) {
				const shareEvent:AIRFacebookShareEvent = new AIRFacebookShareEvent( AIRFacebookShareEvent.SHARE_RESULT );
				shareEvent.ns_airfacebook_internal::errorMessage = "Device is not capable of sharing a link.";
				dispatchEvent( shareEvent );

				// Listener
				if( listener != null ) {
					listener.onFacebookShareError( shareEvent.errorMessage );
				}
				return;
			}
			shareLinkWithMethod( contentURL, postWithoutUI, false, message, listener );
		}

		/**
		 * @inheritDoc
		 */
		public function linkMessage( contentURL:String,
									 listener:IAIRFacebookShareListener = null ):void {
			if( !canShareLinkMessage ) {
				const shareEvent:AIRFacebookShareEvent = new AIRFacebookShareEvent( AIRFacebookShareEvent.SHARE_RESULT );
				shareEvent.ns_airfacebook_internal::errorMessage = "Device is not capable of sharing a link with Messenger.";
				dispatchEvent( shareEvent );

				// Listener
				if( listener != null ) {
					listener.onFacebookShareError( shareEvent.errorMessage );
				}
				return;
			}
			shareLinkWithMethod( contentURL, false, true, null, listener );
		}

		/**
		 * @inheritDoc
		 */
		public function photo( photo:Object,
							   isUserGenerated:Boolean = false,
							   postWithoutUI:Boolean = false,
							   message:String = null,
							   listener:IAIRFacebookShareListener = null ):void {
			if( !canSharePhoto ) {
				const shareEvent:AIRFacebookShareEvent = new AIRFacebookShareEvent( AIRFacebookShareEvent.SHARE_RESULT );
				shareEvent.ns_airfacebook_internal::errorMessage = "Device is not capable of sharing a photo.";
				dispatchEvent( shareEvent );
				return;
			}
			sharePhotoWithMethod( photo, isUserGenerated, postWithoutUI, false, message, listener );
		}

		/**
		 * @inheritDoc
		 */
		public function photoMessage( photo:Object, isUserGenerated:Boolean = false, listener:IAIRFacebookShareListener = null ):void {
			if( !canSharePhotoMessage ) {
				const shareEvent:AIRFacebookShareEvent = new AIRFacebookShareEvent( AIRFacebookShareEvent.SHARE_RESULT );
				shareEvent.ns_airfacebook_internal::errorMessage = "Device is not capable of sharing a photo with Messenger.";
				dispatchEvent( shareEvent );
				return;
			}
			sharePhotoWithMethod( photo, isUserGenerated, false, true, null, listener );
		}

		/**
		 * @inheritDoc
		 */
		public function openGraphStory( actionType:String, objectType:String, title:String, image:Object = null, objectProperties:Object = null, listener:IAIRFacebookShareListener = null ):void {
			if( !canShareOpenGraphStory ) {
				const shareEvent:AIRFacebookShareEvent = new AIRFacebookShareEvent( AIRFacebookShareEvent.SHARE_RESULT );
				shareEvent.ns_airfacebook_internal::errorMessage = "Device is not capable of sharing an Open Graph content.";
				dispatchEvent( shareEvent );

				// Listener
				if( listener != null ) {
					listener.onFacebookShareError( shareEvent.errorMessage );
				}
				return;
			}
			if( !actionType ) throw new ArgumentError( "Parameter actionType cannot be null." );
			if( !objectType ) throw new ArgumentError( "Parameter objectType cannot be null." );
			if( !title ) throw new ArgumentError( "Parameter title cannot be null." );
			if( objectType.indexOf( ":" ) == -1 ) throw new Error( "Object type must have a namespace specified." );

			// Image
			if( image ) {
				if( !(image is String) && !(image is BitmapData) ) {
					throw new ArgumentError( "Parameter image must be either String or BitmapData." );
				}
			}

			// List of object properties
			var properties:Vector.<String> = getVectorFromObject( objectProperties );

			_context.call( "shareOpenGraphStory", actionType, objectType, title, image, properties, registerListener( listener ) );
		}

		/**
		 * @inheritDoc
		 */
		public function appInvite( appLinkURL:String, imageURL:String = null, listener:IAIRFacebookAppInviteListener = null ):void {
			if( !canShareAppInvite ) {
				const shareEvent:AIRFacebookShareEvent = new AIRFacebookShareEvent( AIRFacebookShareEvent.SHARE_RESULT );
				shareEvent.ns_airfacebook_internal::errorMessage = "Device is not capable of showing an app invite dialog.";
				dispatchEvent( shareEvent );

				// Listener
				if( listener != null ) {
					listener.onFacebookAppInviteError( shareEvent.errorMessage );
				}
				return;
			}

			if( !appLinkURL ) throw new ArgumentError( "Parameter appLinkURL cannot be null." );

			_context.call( "showAppInviteDialog", appLinkURL, imageURL, registerListener( listener ) );
		}

		/**
		 * @inheritDoc
		 */
		public function get canShareLink():Boolean {
			if( !_facebook.isSupported ) {
				return false;
			}

			return _context.call( "canShareContent", "LINK" ) as Boolean;
		}

		/**
		 * @inheritDoc
		 */
		public function get canSharePhoto():Boolean {
			if( !_facebook.isSupported ) {
				return false;
			}

			return _context.call( "canShareContent", "PHOTO" ) as Boolean;
		}

		/**
		 * @inheritDoc
		 */
		public function get canShareLinkMessage():Boolean {
			if( !_facebook.isSupported ) {
				return false;
			}

			return _context.call( "canShareContent", "MESSAGE_LINK" ) as Boolean;
		}

		/**
		 * @inheritDoc
		 */
		public function get canSharePhotoMessage():Boolean {
			if( !_facebook.isSupported ) {
				return false;
			}

			return _context.call( "canShareContent", "MESSAGE_PHOTO" ) as Boolean;
		}

		/**
		 * @inheritDoc
		 */
		public function get canShareOpenGraphStory():Boolean {
			if( !_facebook.isSupported ) {
				return false;
			}

			return _context.call( "canShareContent", "OPEN_GRAPH" ) as Boolean;
		}

		/**
		 * @inheritDoc
		 */
		public function get canShareAppInvite():Boolean {
			if( !_facebook.isSupported ) {
				return false;
			}

			return _context.call( "canShowAppInviteDialog" ) as Boolean;
		}

		/**
		 *
		 *
		 * Private API
		 *
		 *
		 */

		private function sharePhotoWithMethod( photo:Object,
											   isUserGenerated:Boolean = false,
											   postWithoutUI:Boolean = false,
											   useMessenger:Boolean = false,
											   message:String = null,
											   listener:IAIRFacebookShareListener = null ):void {
			if( !_facebook.isSupported ) {
				return;
			}


			if( !photo ) {
				throw new ArgumentError( "Parameter photo cannot be null." );
			}

			if( !(photo is String) && !(photo is BitmapData) ) {
				throw new ArgumentError( "Parameter photo must be either String or BitmapData." );
			}

			_context.call( "sharePhoto", photo, isUserGenerated, postWithoutUI, useMessenger, message, registerListener( listener ) );
		}

		private function shareLinkWithMethod( contentURL:String,
											  postWithoutUI:Boolean = false,
											  useMessenger:Boolean = false,
											  message:String = null,
											  listener:IAIRFacebookShareListener = null ):void {
			if( !_facebook.isSupported ) {
				return;
			}

			if( !contentURL ) {
				throw new ArgumentError( "Parameter contentURL cannot be null." );
			}

			_context.call( "shareLink", contentURL, postWithoutUI, useMessenger, message, registerListener( listener ) );
		}

		private function onStatus( event:StatusEvent ):void {
			var eventJSON:Object = null;

			switch( event.code ) {
					// Share success - set post ID
				case SHARE_SUCCESS:
					eventJSON = JSON.parse( event.level );
					if( "appInvite" in eventJSON ) {
						onAppInviteSuccessHandler( eventJSON );
					} else {
						onShareSuccessHandler( eventJSON );
					}
					return;

					// Share error - set error message
				case SHARE_ERROR:
					eventJSON = JSON.parse( event.level );
					if( "appInvite" in eventJSON ) {
						onAppInviteErrorHandler( eventJSON );
					} else {
						onShareErrorHandler( eventJSON );
					}
					return;

					// Share cancelled - set cancel flag
				case SHARE_CANCEL:
					eventJSON = JSON.parse( event.level );
					if( "appInvite" in eventJSON ) {
						onAppInviteCancelHandler( eventJSON );
					} else {
						onShareCancelHandler( eventJSON );
					}
					return;
			}
		}

		/**
		 * APP INVITE
		 */

		private function onAppInviteSuccessHandler( eventJSON:Object ):void {
			// Dispatch event
			const event:AIRFacebookShareEvent = new AIRFacebookShareEvent( AIRFacebookShareEvent.SHARE_RESULT );
			dispatchEvent( event );

			// Listener
			const listenerID:int = eventJSON.listenerID;
			const listener:IAIRFacebookAppInviteListener = popListener( listenerID ) as IAIRFacebookAppInviteListener;
			if( listener != null ) {
				listener.onFacebookAppInviteSuccess();
			}
		}

		private function onAppInviteErrorHandler( eventJSON:Object ):void {
			// Dispatch event
			const event:AIRFacebookShareEvent = new AIRFacebookShareEvent( AIRFacebookShareEvent.SHARE_RESULT );
			event.ns_airfacebook_internal::errorMessage = eventJSON.errorMessage;
			dispatchEvent( event );

			// Listener
			const listenerID:int = eventJSON.listenerID;
			const listener:IAIRFacebookAppInviteListener = popListener( listenerID ) as IAIRFacebookAppInviteListener;
			if( listener != null ) {
				listener.onFacebookAppInviteError( event.errorMessage );
			}
		}

		private function onAppInviteCancelHandler( eventJSON:Object ):void {
			// Dispatch event
			const event:AIRFacebookShareEvent = new AIRFacebookShareEvent( AIRFacebookShareEvent.SHARE_RESULT );
			event.ns_airfacebook_internal::wasCancelled = true;
			dispatchEvent( event );

			// Listener
			const listenerID:int = eventJSON.listenerID;
			const listener:IAIRFacebookAppInviteListener = popListener( listenerID ) as IAIRFacebookAppInviteListener;
			if( listener != null ) {
				listener.onFacebookAppInviteCancel();
			}
		}

		/**
		 * CONTENT SHARE
		 */

		private function onShareSuccessHandler( eventJSON:Object ):void {
			// Dispatch event
			const event:AIRFacebookShareEvent = new AIRFacebookShareEvent( AIRFacebookShareEvent.SHARE_RESULT );
			if( "postID" in eventJSON ) {
				event.ns_airfacebook_internal::postID = eventJSON.postID;
			}
			dispatchEvent( event );

			// Listener
			const listenerID:int = eventJSON.listenerID;
			const listener:IAIRFacebookShareListener = popListener( listenerID ) as IAIRFacebookShareListener;
			if( listener != null ) {
				listener.onFacebookShareSuccess( event.postID );
			}
		}

		private function onShareErrorHandler( eventJSON:Object ):void {
			// Dispatch event
			const event:AIRFacebookShareEvent = new AIRFacebookShareEvent( AIRFacebookShareEvent.SHARE_RESULT );
			event.ns_airfacebook_internal::errorMessage = eventJSON.errorMessage;
			dispatchEvent( event );

			// Listener
			const listenerID:int = eventJSON.listenerID;
			const listener:IAIRFacebookShareListener = popListener( listenerID ) as IAIRFacebookShareListener;
			if( listener != null ) {
				listener.onFacebookShareError( event.errorMessage );
			}
		}

		private function onShareCancelHandler( eventJSON:Object ):void {
			// Dispatch event
			const event:AIRFacebookShareEvent = new AIRFacebookShareEvent( AIRFacebookShareEvent.SHARE_RESULT );
			event.ns_airfacebook_internal::wasCancelled = true;
			dispatchEvent( event );

			// Listener
			const listenerID:int = eventJSON.listenerID;
			const listener:IAIRFacebookShareListener = popListener( listenerID ) as IAIRFacebookShareListener;
			if( listener != null ) {
				listener.onFacebookShareCancel();
			}
		}

	}

}
