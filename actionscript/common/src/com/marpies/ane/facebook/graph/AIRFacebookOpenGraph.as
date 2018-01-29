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

package com.marpies.ane.facebook.graph {

	import com.marpies.ane.facebook.AIRFacebookListenerMap;
	import com.marpies.ane.facebook.IAIRFacebook;
	import com.marpies.ane.facebook.events.AIRFacebookOpenGraphEvent;
	import com.marpies.ane.facebook.listeners.IAIRFacebookOpenGraphListener;

	import flash.events.StatusEvent;

	import flash.external.ExtensionContext;

	/**
	 * @private
	 */
	public class AIRFacebookOpenGraph extends AIRFacebookListenerMap implements IAIRFacebookOpenGraph {

		protected const OPEN_GRAPH_ERROR:String = "openGraphError";
		protected const OPEN_GRAPH_SUCCESS:String = "openGraphSuccess";

		private var _facebook:IAIRFacebook;
		private var _context:ExtensionContext;

		public function AIRFacebookOpenGraph( facebook:IAIRFacebook, context:ExtensionContext ) {
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
		public function sendGETRequest( path:String, parameters:Object = null, listener:IAIRFacebookOpenGraphListener = null ):void {
			if( !_facebook.isSupported ) {
				return;
			}

			if( !path ) {
				throw new ArgumentError( "Parameter path cannot be null." );
			}

			// List of object properties
			var params:Vector.<String> = getVectorFromObject( parameters );

			_context.call( "sendOpenGraphRequest", "GET", path, params, registerListener( listener ) );
		}

		/**
		 * @inheritDoc
		 */
		public function sendPOSTRequest( path:String, parameters:Object = null, listener:IAIRFacebookOpenGraphListener = null ):void {
			if( !_facebook.isSupported ) {
				return;
			}

			if( !path ) {
				throw new ArgumentError( "Parameter path cannot be null." );
			}

			// List of object properties
			var params:Vector.<String> = getVectorFromObject( parameters );

			_context.call( "sendOpenGraphRequest", "POST", path, params, registerListener( listener ) );
		}

		/**
		 * @inheritDoc
		 */
		public function sendDELETERequest( nodeID:String, listener:IAIRFacebookOpenGraphListener = null ):void {
			if( !_facebook.isSupported ) {
				return;
			}

			if( !nodeID ) {
				throw new ArgumentError( "Parameter nodeID cannot be null." );
			}

			_context.call( "sendOpenGraphRequest", "DELETE", nodeID, null, registerListener( listener ) );
		}

		/**
		 * @inheritDoc
		 */
		public function postAchievement( achievementURL:String, listener:IAIRFacebookOpenGraphListener = null ):void {
			if( !_facebook.isSupported ) {
				return;
			}

			if( !achievementURL ) {
				throw new ArgumentError( "Parameter achievementURL cannot be null." );
			}

			// List of object properties
			var params:Vector.<String> = getVectorFromObject( { achievement: achievementURL } );

			_context.call( "sendOpenGraphRequest", "POST", "/me/achievements", params, registerListener( listener ) );
		}

		/**
		 * @inheritDoc
		 */
		public function postScore( score:int, listener:IAIRFacebookOpenGraphListener = null ):void {
			if( !_facebook.isSupported ) {
				return;
			}

			if( score < 1 ) {
				throw new ArgumentError( "Parameter score must be greater than zero." );
			}

			// List of object properties
			var params:Vector.<String> = getVectorFromObject( { score: score } );

			_context.call( "sendOpenGraphRequest", "POST", "/me/scores", params, registerListener( listener ) );
		}

		/**
		 * @inheritDoc
		 */
		public function requestScores( listener:IAIRFacebookOpenGraphListener = null ):void {
			if( !_facebook.isSupported ) {
				return;
			}

			// List of object properties
			var params:Vector.<String> = getVectorFromObject( { fields: "user,score" } );

			_context.call( "sendOpenGraphRequest", "GET", "/" + _facebook.applicationId + "/scores", params, registerListener( listener ) );
		}
		
		/**
		 *
		 *
		 * Private API
		 *
		 *
		 */

		private function onStatus( event:StatusEvent ):void {
			switch( event.code ) {
				// Open Graph request success - set raw and JSON response
				case OPEN_GRAPH_SUCCESS:
					// Response is in format "{LISTENER_ID}||{JSON_RESPONSE}||{RAW_RESPONSE}"
					const response:Array = event.level.split( "||" );
					onOpenGraphSuccessHandler( response[0], JSON.parse( response[1] ), response[2] );
					return;

				// Open Graph request error - set error message
				case OPEN_GRAPH_ERROR:
					onOpenGraphErrorHandler( JSON.parse( event.level ) );
					return;
			}
		}

		/**
		 * OPEN GRAPH
		 */

		private function onOpenGraphSuccessHandler( listenerID:int, jsonResponse:Object, rawResponse:String ):void {
			// Dispatch event
			const event:AIRFacebookOpenGraphEvent = new AIRFacebookOpenGraphEvent( AIRFacebookOpenGraphEvent.REQUEST_RESULT );
			event.ns_airfacebook_internal::jsonResponse = jsonResponse;
			event.ns_airfacebook_internal::rawResponse = rawResponse;
			dispatchEvent( event );

			// Listener
			const listener:IAIRFacebookOpenGraphListener = popListener( listenerID ) as IAIRFacebookOpenGraphListener;
			if( listener != null ) {
				listener.onFacebookOpenGraphSuccess( jsonResponse, rawResponse );
			}
		}

		private function onOpenGraphErrorHandler( eventJSON:Object ):void {
			// Dispatch event
			const event:AIRFacebookOpenGraphEvent = new AIRFacebookOpenGraphEvent( AIRFacebookOpenGraphEvent.REQUEST_RESULT );
			event.ns_airfacebook_internal::errorMessage = eventJSON.errorMessage;
			dispatchEvent( event );

			// Listener
			const listenerID:int = eventJSON.listenerID;
			const listener:IAIRFacebookOpenGraphListener = popListener( listenerID ) as IAIRFacebookOpenGraphListener;
			if( listener != null ) {
				listener.onFacebookOpenGraphError( event.errorMessage );
			}
		}

	}

}
