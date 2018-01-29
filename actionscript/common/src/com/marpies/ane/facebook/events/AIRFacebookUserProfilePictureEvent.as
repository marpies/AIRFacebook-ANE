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

    import flash.display.Bitmap;

    /**
     * Dispatched after a call to <code>AIRFacebook.requestUserProfilePicture()</code> if the parameter
     * <code>autoLoad</code> was set to <code>true</code>.
     */
    public class AIRFacebookUserProfilePictureEvent extends AIRFacebookEvent {

        public static const RESULT:String = "profilePictureLoadResult";

        private var mProfilePicture:Bitmap;

        public function AIRFacebookUserProfilePictureEvent( type:String, bubbles:Boolean = false, cancelable:Boolean = false ) {
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
         * <code>flash.display.Bitmap</code> of user's profile picture.
         */
        public function get profilePicture():Bitmap {
            return mProfilePicture;
        }

        /**
         * @private
         */
        ns_airfacebook_internal function set profilePicture( value:Bitmap ):void {
            mProfilePicture = value;
        }

    }

}
