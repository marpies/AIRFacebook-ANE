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
    import flash.net.URLVariables;

    /**
     * Dispatched once your application is invoked from a Game Request, for example
     * when user tapped a request notification in native Facebook app.
     */
    public class AIRFacebookGameRequestInvokeEvent extends Event {

        public static const INVOKE:String = "invoke";

        private var mReason:String;
        private var mArguments:Array;
        private var mFullURL:String;
        private var mURLVars:URLVariables;
        private var mRequestIDs:Vector.<String>;

        public function AIRFacebookGameRequestInvokeEvent( type:String, bubbles:Boolean = false, cancelable:Boolean = false ) {
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
         * Reason of the invoke event.
         */
        public function get reason():String {
            return mReason;
        }

        /**
         * URL that was handled by the invoke event.
         */
        public function get fullURL():String {
            return mFullURL;
        }

        /**
         * Parsed variables from the invoked URL.
         */
        public function get URLVars():URLVariables {
            return mURLVars;
        }

        /**
         * Original <code>flash.events.InvokeEvent</code> arguments.
         */
        public function get arguments():Array {
            return mArguments;
        }

        /**
         * List of GameRequest IDs which were sent to the user.
         * Use the IDs with <code>AIRFacebook.requestUserGameRequests()</code>.
         */
        public function get requestIDs():Vector.<String> {
            return mRequestIDs;
        }

        /**
         * @private
         */
        ns_airfacebook_internal function set reason( value:String ):void {
            mReason = value;
        }

        /**
         * @private
         */
        ns_airfacebook_internal function set fullURL( value:String ):void {
            mFullURL = value;
        }

        /**
         * @private
         */
        ns_airfacebook_internal function set URLVars( value:URLVariables ):void {
            mURLVars = value;
        }

        /**
         * @private
         */
        ns_airfacebook_internal function set arguments( value:Array ):void {
            mArguments = value;
        }

        /**
         * @private
         */
        ns_airfacebook_internal function set requestIDs( value:Vector.<String> ):void {
            mRequestIDs = value;
        }

    }

}
