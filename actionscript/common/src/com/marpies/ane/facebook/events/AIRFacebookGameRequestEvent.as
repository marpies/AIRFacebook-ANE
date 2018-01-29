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

    /**
     * Dispatched after a call to <code>AIRFacebook.showGameRequestDialog()</code>.
     * If the dialog was successfully sent, this event provides ID of the sent request
     * as well as IDs of the recipients.
     */
    public class AIRFacebookGameRequestEvent extends AIRFacebookCancellableEvent {

        public static const REQUEST_RESULT:String = "gameRequestRequestResult";

        private var mRequestID:String;
        private var mRecipients:Vector.<String>;

        public function AIRFacebookGameRequestEvent( type:String, bubbles:Boolean = false, cancelable:Boolean = false ) {
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
         * ID of the GameRequest, or <code>null</code> if the request was not sent.
         */
        public function get requestID():String {
            return mRequestID;
        }

        /**
         * List of IDs of Facebook users to which the request was sent,
         * or <code>null</code> if the request was not sent.
         */
        public function get recipients():Vector.<String> {
            return mRecipients;
        }

        /**
         * @private
         */
        ns_airfacebook_internal function set requestID( value:String ):void {
            mRequestID = value;
        }

        /**
         * @private
         */
        ns_airfacebook_internal function set recipients( value:Vector.<String> ):void {
            mRecipients = value;
        }

    }

}
