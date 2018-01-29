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

    use namespace ns_airfacebook_internal;

    /**
     * Provides access to additional user's properties. This profile needs to be
     * explicitly requested using <code>AIRFacebook.requestExtendedUserProfile()</code>.
     * The properties you wish to obtain must be specified using the <code>fields</code> parameter,
     * though their availability is subject to granted permissions, e.g. birthday info.
     */
    public class ExtendedUserProfile extends BasicUserProfile {

        /**
         * @private
         */
        public function ExtendedUserProfile() {
            super();
        }

        /**
         *
         *
         * Getters / Setters
         *
         *
         */

        /**
         * Allows you to access user properties which are not part of <code>BasicUserProfile</code>
         * by default. Only the properties that were specified in the <code>fields</code> parameter
         * of <code>AIRFacebook.requestExtendedUserProfile()</code> and for which your application
         * has permission to read are available.
         *
         * @param property Name of property to retrieve, e.g. <code>birthday</code> or <code>gender</code>.
         * @return Value associated with the property if available, <code>null</code> otherwise.
         *         Return value is <code>String</code> for most properties. For properties like <code>hometown</code>
         *         and <code>picture</code> the returned value is <code>Object</code> (JSON).
         */
        public function getProperty( property:String ):Object {
            return (property in mProperties) ? mProperties[property] : null;
        }

    }

}
