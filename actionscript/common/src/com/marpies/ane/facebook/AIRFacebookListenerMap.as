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

	import flash.events.EventDispatcher;
	import flash.utils.Dictionary;

	/**
	 * @private
	 */
	public class AIRFacebookListenerMap extends EventDispatcher {

		private static var _listenerIdCounter:int;

		private var _map:Dictionary;

		public function AIRFacebookListenerMap() {
			_map = new Dictionary();
		}

		/**
		 * Registers given listener and generates id which is used to look the listener up when it is time to call it.
		 *
		 * @param listener Listener to register.
		 * @return Id of the listener.
		 */
		protected function registerListener( listener:Object ):int {
			if( listener == null ) {
				return -1;
			}

			_map[_listenerIdCounter] = listener;
			return _listenerIdCounter++;
		}

		/**
		 * Gets registered listener with given id, and removes it from the map.
		 *
		 * @param listenerId id of the listener to retrieve.
		 * @return Listener registered with given id, or <code>null</code> if no such listener exists.
		 */
		protected function popListener( listenerId:int ):Object {
			var listener:Object = getListener( listenerId );
			delete _map[listenerId];
			return listener;
		}

		/**
		 * Gets registered listener with given id.
		 *
		 * @param listenerId id of the listener to retrieve.
		 * @return Listener registered with given id, or <code>null</code> if no such listener exists.
		 */
		protected function getListener( listenerId:int ):Object {
			if( listenerId == -1 || !(listenerId in _map) ) {
				return null;
			}
			return _map[listenerId];
		}

		/**
		 * Returns list of key-values from key-value object, e.g. { "key": "val" } -> [ "key", "val" ].
		 * @param object Key-value object to transform into list.
		 * @return List of key-values from <code>object</code>, or null if <code>object</code> is null.
		 */
		protected function getVectorFromObject( object:Object ):Vector.<String> {
			var properties:Vector.<String> = null;
			if( object ) {
				properties = new <String>[];

				// Create a list of object properties, that is key followed by its value
				for( var key:String in object ) {
					properties[properties.length] = key;
					properties[properties.length] = object[key];
				}
			}
			return properties;
		}

		/**
		 * Disposes the listener map.
		 */
		public function dispose():void {
			_map = null;
		}

	}

}
