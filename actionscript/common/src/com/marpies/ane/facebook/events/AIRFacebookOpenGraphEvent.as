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
     * Dispatched after a call to any of the methods working with Open Graph.
     * This event provides both raw and parsed responses.
     */
    public class AIRFacebookOpenGraphEvent extends AIRFacebookEvent {

        public static const REQUEST_RESULT:String = "openGraphRequestResult";

        private var mRawResponse:String;
        private var mJsonResponse:Object;

        public function AIRFacebookOpenGraphEvent( type:String, bubbles:Boolean = false, cancelable:Boolean = false ) {
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
         * Raw response as it was returned by the native SDK.
         */
        public function get rawResponse():String {
            return mRawResponse;
        }

        /**
         * Parsed JSON response. In some cases, this JSON may not contain
         * all the data that is included in the <code>rawResponse</code>.
         */
        public function get jsonResponse():Object {
            return mJsonResponse;
        }

        /**
         * @private
         */
        ns_airfacebook_internal function set rawResponse( value:String ):void {
            mRawResponse = value;
        }

        /**
         * @private
         */
        ns_airfacebook_internal function set jsonResponse( value:Object ):void {
            mJsonResponse = value;
        }

    }

}
