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

    import com.marpies.ane.facebook.data.ExtendedUserProfile;

    /**
     * Dispatched after a call to <code>AIRFacebook.requestExtendedUserProfile()</code>.
     */
    public class AIRFacebookExtendedUserProfileEvent extends AIRFacebookEvent {

        public static const PROFILE_LOADED:String = "profileLoaded";

        private var mExtendedUserProfile:ExtendedUserProfile;

        public function AIRFacebookExtendedUserProfileEvent( type:String, bubbles:Boolean = false, cancelable:Boolean = false ) {
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
         * Returns an extended user profile as a result of the request.
         */
        public function get extendedUserProfile():ExtendedUserProfile {
            return mExtendedUserProfile;
        }

        /**
         * @private
         */
        ns_airfacebook_internal function set extendedUserProfile( value:ExtendedUserProfile ):void {
            mExtendedUserProfile = value;
        }

    }

}
