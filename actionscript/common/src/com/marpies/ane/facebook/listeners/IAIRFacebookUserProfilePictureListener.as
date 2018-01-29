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

package com.marpies.ane.facebook.listeners {

    import flash.display.Bitmap;

    /**
     * Interface for objects that want to be notified about user's picture loading process result.
     */
    public interface IAIRFacebookUserProfilePictureListener {

        /**
         * Called if the picture is loaded successfully.
         * @param picture <code>flash.display.Bitmap</code> of user's profile picture.
         */
        function onFacebookUserProfilePictureSuccess( picture:Bitmap ):void;

        /**
         * Called if an error occurs during the loading process.
         * @param errorMessage Message describing the error.
         */
        function onFacebookUserProfilePictureError( errorMessage:String ):void;

    }

}
