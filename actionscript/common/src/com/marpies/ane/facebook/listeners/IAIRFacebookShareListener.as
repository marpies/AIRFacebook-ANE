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

    /**
     * Interface for objects that want to be notified about a sharing process result.
     */
    public interface IAIRFacebookShareListener {

        /**
         * Called if the sharing is successful.
         * @param postID ID of the post that was created during the sharing process. It is <code>null</code> when
         *               sharing using Messenger app.
         */
        function onFacebookShareSuccess( postID:String ):void;

        /**
         * Called if the sharing dialog is cancelled.
         */
        function onFacebookShareCancel():void;

        /**
         * Called if an error occurs during the sharing process.
         * @param errorMessage Message describing the error.
         */
        function onFacebookShareError( errorMessage:String ):void;

    }

}
