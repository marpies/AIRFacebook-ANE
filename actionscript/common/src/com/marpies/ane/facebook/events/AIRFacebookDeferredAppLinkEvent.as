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

    import com.marpies.ane.facebook.data.AIRFacebookLinkParameter;

    /**
     * Dispatched after a call to <code>AIRFacebook.fetchDeferredAppLink()</code>.
     */
    public class AIRFacebookDeferredAppLinkEvent extends AIRFacebookEvent {

        public static const REQUEST_RESULT:String = "deferredAppLinkRequestResult";

        private var mNotFound:Boolean;
        private var mTargetURL:String;
        private var mParameters:Vector.<AIRFacebookLinkParameter>;

        public function AIRFacebookDeferredAppLinkEvent( type:String, bubbles:Boolean = false, cancelable:Boolean = false ) {
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
         * Returns <code>true</code> whether the deferred app link was not found on the server.
         */
        public function get linkNotFound():Boolean {
            return mNotFound;
        }

        /**
         * The deferred deep link or <code>null</code> if no link was found.
         */
        public function get targetURL():String {
            return mTargetURL;
        }

        /**
         * If the deferred deep link specified parameters after a question mark then these will be parsed by the ANE
         * and returned by this property, otherwise you will have to parse the parameters from <code>targetURL</code> yourself.
         */
        public function get parameters():Vector.<AIRFacebookLinkParameter> {
            return mParameters;
        }

        /**
         * @private
         */
        ns_airfacebook_internal function set linkNotFound( value:Boolean ):void {
            mNotFound = value;
        }

        /**
         * @private
         */
        ns_airfacebook_internal function set targetURL( value:String ):void {
            mTargetURL = value;
        }

        /**
         * @private
         */
        ns_airfacebook_internal function set parameters( value:Vector.<AIRFacebookLinkParameter> ):void {
            mParameters = value;
        }

    }

}
