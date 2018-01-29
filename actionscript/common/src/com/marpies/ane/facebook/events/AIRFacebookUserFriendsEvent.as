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
     * Dispatched after a call to <code>AIRFacebook.requestUserFriends()</code>.
     * If the call was successful, this event provides a list of <code>ExtendedUserProfile</code>
     * instances which represent user's friends. Properties available in these instances
     * depend on the value of the request <code>fields</code> parameter and granted permissions.
     */
    public class AIRFacebookUserFriendsEvent extends AIRFacebookEvent {

        public static const REQUEST_RESULT:String = "userFriendsRequestResult";

        private var mFriends:Vector.<ExtendedUserProfile>;

        public function AIRFacebookUserFriendsEvent( type:String, bubbles:Boolean = false, cancelable:Boolean = false ) {
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
         * List of user's friends who have also authorized your application.
         */
        public function get friends():Vector.<ExtendedUserProfile> {
            return mFriends;
        }

        /**
         * @private
         */
        ns_airfacebook_internal function set friends( value:Vector.<ExtendedUserProfile> ):void {
            mFriends = value;
        }

    }

}
