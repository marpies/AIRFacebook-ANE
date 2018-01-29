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
     * Dispatched after a call to any of the sharing methods, including
     * <code>AIRFacebook.showAppInviteDialog()</code>.
     */
    public class AIRFacebookShareEvent extends AIRFacebookCancellableEvent {

        public static const SHARE_RESULT:String = "shareResult";

        private var mPostID:String;

        public function AIRFacebookShareEvent( type:String, bubbles:Boolean = false, cancelable:Boolean = false ) {
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
         * ID of the post that was created during the sharing process.
         * It is <code>null</code> when sharing using Messenger app.
         */
        public function get postID():String {
            return mPostID;
        }

        /**
         * @private
         */
        ns_airfacebook_internal function set postID( value:String ):void {
            mPostID = value;
        }

    }

}
