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
     * Provides access to basic user's properties shortly after logging the user into Facebook.
     * This profile is available by default and does not need to be explicitly requested.
     */
    public class BasicUserProfile {

        /**
         * @private
         */
        protected var mProperties:Object;

        /**
         * @private
         */
        public function BasicUserProfile() {
            ns_airfacebook_internal::clear();
        }

        /**
         * @private
         */
        ns_airfacebook_internal function clear():void {
            mProperties = {};
        }

        /**
         *
         *
         * Getters / Setters
         *
         *
         */

        /**
         * User's ID.
         */
        public function get id():String {
            return ("id" in mProperties) ? mProperties.id : null;
        }

        /**
         * User's first name. Can be <code>null</code>.
         */
        public function get firstName():String {
            return ("first_name" in mProperties) ? mProperties.first_name : null;
        }

        /**
         * User's middle name. Can be <code>null</code>.
         */
        public function get middleName():String {
            return ("middle_name" in mProperties) ? mProperties.middle_name : null;
        }

        /**
         * User's last name. Can be <code>null</code>.
         */
        public function get lastName():String {
            return ("last_name" in mProperties) ? mProperties.last_name : null;
        }

        /**
         * User's full name. Can be <code>null</code>.
         */
        public function get name():String {
            return ("name" in mProperties) ? mProperties.name : null;
        }

        /**
         * Link to user's Facebook profile. Can be <code>null</code>.
         */
        public function get linkURI():String {
            if( "link_uri" in mProperties ) return mProperties.link_uri;
            if( "link" in mProperties ) return mProperties.link;
            return null;
        }

        /**
         * @private
         * @param value
         */
        ns_airfacebook_internal function set properties( value:Object ):void {
            mProperties = value;
        }

    }

}
