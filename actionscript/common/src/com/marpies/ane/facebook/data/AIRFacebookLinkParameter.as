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

package com.marpies.ane.facebook.data {

    /**
     * Represents deep link parameter.
     */
    public class AIRFacebookLinkParameter {

        private var mName:String;
        private var mValue:String;

        /**
         * @private
         */
        public function AIRFacebookLinkParameter() {
        }

        public function toString():String {
            return "[AIRFacebookLinkParameter] {" + mName + " = " + mValue + "}";
        }

        /**
         *
         *
         * Getters / Setters
         *
         *
         */

        /**
         * Parameter name.
         */
        public function get name():String {
            return mName;
        }

        /**
         * Parameter value.
         */
        public function get value():String {
            return mValue;
        }

        ns_airfacebook_internal function set name( value:String ):void {
            mName = value;
        }

        ns_airfacebook_internal function set value( value:String ):void {
            mValue = value;
        }
    }

}
