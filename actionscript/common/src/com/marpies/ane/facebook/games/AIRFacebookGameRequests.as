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

package com.marpies.ane.facebook.games {

	import com.marpies.ane.facebook.AIRFacebookListenerMap;
	import com.marpies.ane.facebook.IAIRFacebook;
	import com.marpies.ane.facebook.data.AIRFacebookGameRequest;
	import com.marpies.ane.facebook.data.AIRFacebookGameRequestActionType;
	import com.marpies.ane.facebook.data.AIRFacebookGameRequestFilter;
	import com.marpies.ane.facebook.events.AIRFacebookGameRequestEvent;
	import com.marpies.ane.facebook.events.AIRFacebookGameRequestInvokeEvent;
	import com.marpies.ane.facebook.events.AIRFacebookUserGameRequestsEvent;
	import com.marpies.ane.facebook.listeners.IAIRFacebookGameRequestInvokeListener;
	import com.marpies.ane.facebook.listeners.IAIRFacebookGameRequestListener;
	import com.marpies.ane.facebook.listeners.IAIRFacebookOpenGraphListener;
	import com.marpies.ane.facebook.listeners.IAIRFacebookUserGameRequestsListener;

	import flash.desktop.NativeApplication;

	import flash.events.InvokeEvent;

	import flash.events.StatusEvent;

	import flash.external.ExtensionContext;
	import flash.net.URLVariables;

	/**
	 * @private
	 */
	public class AIRFacebookGameRequests extends AIRFacebookListenerMap implements IAIRFacebookGameRequests {

		protected const GAME_REQUEST_ERROR:String = "gameRequestError";
		protected const GAME_REQUEST_CANCEL:String = "gameRequestCancel";
		protected const GAME_REQUEST_SUCCESS:String = "gameRequestSuccess";

		protected const APP_REQUESTS_ERROR:String = "appRequestsError";
		protected const APP_REQUESTS_SUCCESS:String = "appRequestsSuccess";

		private var _facebook:IAIRFacebook;
		private var _context:ExtensionContext;
		private var _gameRequestInvokeListeners:Vector.<IAIRFacebookGameRequestInvokeListener>;

		public function AIRFacebookGameRequests( facebook:IAIRFacebook, context:ExtensionContext ) {
			_facebook = facebook;
			_context = context;
			_gameRequestInvokeListeners = new <IAIRFacebookGameRequestInvokeListener>[];

			if( _context != null ) {
				_context.addEventListener( StatusEvent.STATUS, onStatus );
				NativeApplication.nativeApplication.addEventListener( InvokeEvent.INVOKE, onInvoke );
			}
		}

		override public function dispose():void {
			super.dispose();

			if( _context != null ) {
				_context.removeEventListener( StatusEvent.STATUS, onStatus );
			}

			_gameRequestInvokeListeners.length = 0;
			_gameRequestInvokeListeners = null;

			NativeApplication.nativeApplication.removeEventListener( InvokeEvent.INVOKE, onInvoke );
		}

		/**
		 * @inheritDoc
		 */
		public function showDialog( message:String,
									actionType:String = null,
									title:String = null,
									objectID:String = null,
									friendsFilter:String = null,
									data:String = null,
									suggestedFriends:Vector.<String> = null,
									recipients:Vector.<String> = null,
									listener:IAIRFacebookGameRequestListener = null ):void {
			if( !_facebook.isSupported ) {
				return;
			}

			if( !actionType ) {
				throw new ArgumentError( "Parameter actionType cannot be null." );
			}
			if( !message ) {
				throw new ArgumentError( "Parameter message cannot be null." );
			}

			// Only one of recipients, friendsFilter and suggestedFriends can be set
			var mutex:int = 0;
			if( friendsFilter ) {
				mutex++;
			}
			if( suggestedFriends ) {
				mutex++;
			}
			if( recipients ) {
				mutex++;
			}
			if( mutex > 1 ) {
				throw new ArgumentError( "Parameters recipients, friendsFilter and suggestedFriends are mutually exclusive." );
			}

			if( friendsFilter ) {
				if( friendsFilter != AIRFacebookGameRequestFilter.APP_USERS &&
						friendsFilter != AIRFacebookGameRequestFilter.APP_NON_USERS ) {
					throw new ArgumentError( "Parameter friendsFilter must be one of the constants from AIRFacebookGameRequestFilter class." );
				}
			}

			if( !actionType ) {
				actionType = AIRFacebookGameRequestActionType.NONE;
			}

			// Check for invalid action type
			if( actionType != AIRFacebookGameRequestActionType.ASK_FOR &&
					actionType != AIRFacebookGameRequestActionType.SEND &&
					actionType != AIRFacebookGameRequestActionType.TURN &&
					actionType != AIRFacebookGameRequestActionType.NONE ) {
				throw new ArgumentError( "Parameter actionType must be one of the constants from AIRFacebookGameRequestActionType class." );
			}

			// If request type is ASKFOR or SEND then objectID is required
			if( (actionType == AIRFacebookGameRequestActionType.ASK_FOR || actionType == AIRFacebookGameRequestActionType.SEND) && !objectID ) {
				throw new ArgumentError( "Parameter objectID cannot be null if request type is either ASK_FOR or SEND." );
			}

			_context.call( "showGameRequestDialog", message, actionType.toUpperCase(), title, objectID, friendsFilter, data, suggestedFriends, recipients, registerListener( listener ) );
		}

		/**
		 * @inheritDoc
		 */
		public function loadUserGameRequests( fields:Vector.<String> = null, listener:IAIRFacebookUserGameRequestsListener = null ):void {
			if( !_facebook.isSupported ) {
				return;
			}

			if( !fields ) {
				fields = new <String>["id", "from", "to", "message", "action_type", "created_time", "application"];
			}
			// Force the action_type field otherwise we could not determine
			// if the request's action type is NONE or we did not ask for it
			else if( fields.indexOf( "action_type" ) == -1 ) {
				fields[fields.length] = "action_type";
			}

			_context.call( "requestAppRequests", fields, registerListener( listener ) );
		}

		/**
		 * @inheritDoc
		 */
		public function deleteGameRequest( requestID:String, listener:IAIRFacebookOpenGraphListener = null ):void {
			_facebook.openGraph.sendDELETERequest( requestID, listener );
		}

		/**
		 * @inheritDoc
		 */
		public function addGameRequestInvokeListener( listener:IAIRFacebookGameRequestInvokeListener ):void {
			if( !listener ) {
				return;
			}

			if( !_gameRequestInvokeListeners ) {
				_gameRequestInvokeListeners = new <IAIRFacebookGameRequestInvokeListener>[];
			}
			if( _gameRequestInvokeListeners.indexOf( listener ) == -1 ) {
				_gameRequestInvokeListeners[_gameRequestInvokeListeners.length] = listener;
			}
		}

		/**
		 * @inheritDoc
		 */
		public function removeGameRequestInvokeListener( listener:IAIRFacebookGameRequestInvokeListener ):void {
			if( !listener ) {
				return;
			}

			if( !_gameRequestInvokeListeners ) {
				return;
			}

			var index:int = _gameRequestInvokeListeners.indexOf( listener );
			if( index != -1 ) {
				_gameRequestInvokeListeners.splice( index, 1 );
			}
		}

		/**
		 * @inheritDoc
		 */
		public function get canShowDialog():Boolean {
			if( !_facebook.isSupported ) {
				return false;
			}

			return _context.call( "canShowGameRequestDialog" ) as Boolean;
		}

		/**
		 *
		 *
		 * Private API
		 *
		 *
		 */

		private function onInvoke( event:InvokeEvent ):void {
			var args:Array = event.arguments;
			if( !args || args.length == 0 ) {
				return;
			}

			// Filter only 'openUrl' as the invoke reason
			if( event.reason && event.reason.toLowerCase() == "openurl" ) {
				var urlVars:URLVariables = null;
				var fullURL:String = null;

				// Find the URL in the arguments
				var length:uint = args.length;
				for( var i:uint = 0; i < length; i++ ) {
					var arg:String = args[i];
					if( arg ) {
						// URL on Android starts with http
						if( arg.indexOf( "http" ) == 0 ) {
							fullURL = arg;
							urlVars = getUrlVariables( arg );
						}
						// URL on iOS starts with fb{APP_ID}
						else if( arg.indexOf( "fb" ) == 0 ) {
							urlVars = getUrlVariables( arg );
							if( urlVars != null ) {
								// We need to find the http part in the argument
								for( var key:String in urlVars ) {
									var value:String = urlVars[key];
									if( value && value.indexOf( "http" ) == 0 ) {
										fullURL = value;
										urlVars = new URLVariables( value );
										break;
									}
								}
							}
						}
					}
				}

				// Check if request ID is passed in the URL
				if( urlVars && "request_ids" in urlVars ) {
					// Dispatch event
					var parsedEvent:AIRFacebookGameRequestInvokeEvent = new AIRFacebookGameRequestInvokeEvent( AIRFacebookGameRequestInvokeEvent.INVOKE );
					parsedEvent.ns_airfacebook_internal::reason = event.reason;
					parsedEvent.ns_airfacebook_internal::fullURL = fullURL;
					parsedEvent.ns_airfacebook_internal::URLVars = urlVars;
					parsedEvent.ns_airfacebook_internal::arguments = event.arguments;
					parsedEvent.ns_airfacebook_internal::requestIDs = Vector.<String>( String( urlVars.request_ids ).split( "," ) );
					dispatchEvent( parsedEvent );

					// Listeners
					if( _gameRequestInvokeListeners ) {
						length = _gameRequestInvokeListeners.length;
						for( i = 0; i < length; i++ ) {
							_gameRequestInvokeListeners[i].onFacebookGameRequestInvoke( parsedEvent.requestIDs, urlVars, event.arguments, fullURL, event.reason );
						}
					}
				}
			}
		}

		private function getUrlVariables( urlString:String ):URLVariables {
			var result:URLVariables = null;
			try {
				result = new URLVariables( urlString );
			} catch( e:Error ) { }
			return result;
		}

		private function onStatus( event:StatusEvent ):void {
			switch( event.code ) {
				// Game Request success - set request ID and recipients property
				case GAME_REQUEST_SUCCESS:
					onGameRequestSuccessHandler( JSON.parse( event.level ) );
					return;

				// Game Request error - set error message
				case GAME_REQUEST_ERROR:
					onGameRequestErrorHandler( JSON.parse( event.level ) );
					return;

				// Game Request cancelled - set cancel flag
				case GAME_REQUEST_CANCEL:
					onGameRequestCancelHandler( JSON.parse( event.level ) );
					return;

				// App requests request success - set app requests or error message if data format is unexpected
				case APP_REQUESTS_SUCCESS:
					onUserGameRequestsSuccessHandler( JSON.parse( event.level ) );
					return;

				// App requests request error - set error message
				case APP_REQUESTS_ERROR:
					onUserGameRequestsErrorHandler( JSON.parse( event.level ) );
					return;
			}
		}

		/**
		 * GAME REQUEST
		 */

		private function onGameRequestSuccessHandler( eventJSON:Object ):void {
			// Dispatch event
			var event:AIRFacebookGameRequestEvent = new AIRFacebookGameRequestEvent( AIRFacebookGameRequestEvent.REQUEST_RESULT );
			if( eventJSON.recipients ) {
				event.ns_airfacebook_internal::recipients = Vector.<String>( eventJSON.recipients );
			}
			event.ns_airfacebook_internal::requestID = eventJSON.request_id;
			dispatchEvent( event );

			// Listener
			var listenerID:int = eventJSON.listenerID;
			var listener:IAIRFacebookGameRequestListener = popListener( listenerID ) as IAIRFacebookGameRequestListener;
			if( listener != null ) {
				listener.onFacebookGameRequestSuccess( event.requestID, event.recipients );
			}
		}

		private function onGameRequestErrorHandler( eventJSON:Object ):void {
			// Dispatch event
			var event:AIRFacebookGameRequestEvent = new AIRFacebookGameRequestEvent( AIRFacebookGameRequestEvent.REQUEST_RESULT );
			event.ns_airfacebook_internal::errorMessage = eventJSON.errorMessage;
			dispatchEvent( event );

			// Listener
			var listenerID:int = eventJSON.listenerID;
			var listener:IAIRFacebookGameRequestListener = popListener( listenerID ) as IAIRFacebookGameRequestListener;
			if( listener != null ) {
				listener.onFacebookGameRequestError( event.errorMessage );
			}
		}

		private function onGameRequestCancelHandler( eventJSON:Object ):void {
			// Dispatch event
			var event:AIRFacebookGameRequestEvent = new AIRFacebookGameRequestEvent( AIRFacebookGameRequestEvent.REQUEST_RESULT );
			event.ns_airfacebook_internal::wasCancelled = true;
			dispatchEvent( event );

			// Listener
			var listenerID:int = eventJSON.listenerID;
			var listener:IAIRFacebookGameRequestListener = popListener( listenerID ) as IAIRFacebookGameRequestListener;
			if( listener != null ) {
				listener.onFacebookGameRequestCancel();
			}
		}

		/**
		 * USER GAME REQUESTS
		 */

		private function onUserGameRequestsSuccessHandler( eventJSON:Object ):void {
			var event:AIRFacebookUserGameRequestsEvent = new AIRFacebookUserGameRequestsEvent( AIRFacebookUserGameRequestsEvent.REQUEST_RESULT );
			var listenerID:int = eventJSON.listenerID;
			var listener:IAIRFacebookUserGameRequestsListener = popListener( listenerID ) as IAIRFacebookUserGameRequestsListener;

			if( "gameRequests" in eventJSON && eventJSON.gameRequests is Array ) {
				// Requests are represented by AIRFacebookGameRequest class
				var gameRequests:Vector.<AIRFacebookGameRequest> = new <AIRFacebookGameRequest>[];
				var gameRequestProperties:Array = eventJSON.gameRequests as Array;
				var length:uint = gameRequestProperties.length;

				// Create AIRFacebookGameRequest Vector
				for( var i:uint = 0; i < length; i++ ) {
					var gameRequest:AIRFacebookGameRequest = new AIRFacebookGameRequest();
					gameRequest.ns_airfacebook_internal::properties = gameRequestProperties[i];
					gameRequests[gameRequests.length] = gameRequest;
				}

				// Set the result's list of game requests
				event.ns_airfacebook_internal::gameRequests = gameRequests;

				// Dispatch event
				dispatchEvent( event );

				// Listener
				if( listener != null ) {
					listener.onFacebookUserGameRequestsSuccess( gameRequests );
				}
			} else {
				// Set the result's error message
				event.ns_airfacebook_internal::errorMessage = "Request for user's game requests returned unexpected data " + eventJSON.errorMessage;

				// Dispatch event
				dispatchEvent( event );

				// Listener
				if( listener != null ) {
					listener.onFacebookUserGameRequestsError( event.errorMessage );
				}
			}
		}

		private function onUserGameRequestsErrorHandler( eventJSON:Object ):void {
			// Dispatch event
			var event:AIRFacebookUserGameRequestsEvent = new AIRFacebookUserGameRequestsEvent( AIRFacebookUserGameRequestsEvent.REQUEST_RESULT );
			event.ns_airfacebook_internal::errorMessage = eventJSON.errorMessage;
			dispatchEvent( event );

			// Listener
			var listenerID:int = eventJSON.listenerID;
			var listener:IAIRFacebookUserGameRequestsListener = popListener( listenerID ) as IAIRFacebookUserGameRequestsListener;
			if( listener != null ) {
				listener.onFacebookUserGameRequestsError( event.errorMessage );
			}
		}

	}

}
