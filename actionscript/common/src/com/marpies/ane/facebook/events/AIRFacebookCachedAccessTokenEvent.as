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

package com.marpies.ane.facebook.events {

    import flash.events.Event;

    /**
     * Dispatched shortly after Facebook initialization.
     * Listen to this event during Facebook initialization and check the
     * <code>wasLoaded</code> property to see if a cached access token was loaded.
     */
    public class AIRFacebookCachedAccessTokenEvent extends Event {

        public static const RESULT:String = "cachedAccessTokenResult";

        private var mWasLoaded:Boolean;

        public function AIRFacebookCachedAccessTokenEvent( type:String, bubbles:Boolean = false, cancelable:Boolean = false ) {
            super( type, bubbles, cancelable );
        }

        /**
         *
         *
         * Getters / Setters
         *
         *
         */

        /**
         * Returns <code>true</code> if a cached access token was loaded
         * during initialization, <code>false</code> otherwise.
         */
        public function get wasLoaded():Boolean {
            return mWasLoaded;
        }

        /**
         * @private
         */
        ns_airfacebook_internal function set wasLoaded( value:Boolean ):void {
            mWasLoaded = value;
        }
        
    }

}
