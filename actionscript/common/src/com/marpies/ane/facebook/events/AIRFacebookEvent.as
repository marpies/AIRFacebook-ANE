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
     * Base class for events, providing an occasional error message.
     */
    public class AIRFacebookEvent extends Event {

        /**
         * Dispatched shortly after a call to <code>AIRFacebook.init()</code>, at which point the Facebook SDK
         * is fully initialized and it is safe to use the rest of the API. Listener for this event should be
         * added <strong>before</strong> calling <code>AIRFacebook.init()</code>.
         */
        public static const SDK_INIT:String = "sdkInit";

        private var mErrorMessage:String;

        public function AIRFacebookEvent( type:String, bubbles:Boolean = false, cancelable:Boolean = false ) {
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
         * Returns a message associated with an error,
         * or <code>null</code> if no error occurred.
         */
        public function get errorMessage():String {
            return mErrorMessage;
        }

        /**
         * @private
         */
        ns_airfacebook_internal function set errorMessage( value:String ):void {
            mErrorMessage = value;
        }

    }

}
