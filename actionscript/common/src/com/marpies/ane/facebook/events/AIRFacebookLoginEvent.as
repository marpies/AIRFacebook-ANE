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
     * Dispatched after a call to either <code>AIRFacebook.loginWithReadPermissions()</code> or
     * <code>AIRFacebook.loginWithPublishPermissions()</code> and after the login process is
     * finished.
     */
    public class AIRFacebookLoginEvent extends AIRFacebookCancellableEvent {

        public static const LOGIN_RESULT:String = "loginResult";

        private var mDeniedPermissions:Vector.<String>;
        private var mGrantedPermissions:Vector.<String>;

        public function AIRFacebookLoginEvent( type:String, bubbles:Boolean = false, cancelable:Boolean = false ) {
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
         * List of permissions that were denied by the user during this login attempt.
         */
        public function get deniedPermissions():Vector.<String> {
            return mDeniedPermissions;
        }

        /**
         * List of permissions that were granted by the user during this login attempt.
         */
        public function get grantedPermissions():Vector.<String> {
            return mGrantedPermissions;
        }

        /**
         * @private
         */
        ns_airfacebook_internal function set deniedPermissions( permissions:Vector.<String> ):void {
            mDeniedPermissions = permissions;
        }

        /**
         * @private
         */
        ns_airfacebook_internal function set grantedPermissions( permissions:Vector.<String> ):void {
            mGrantedPermissions = permissions;
        }

    }

}
