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
     * Interface for objects that want to be notified about a Game Request process result.
     */
    public interface IAIRFacebookGameRequestListener {

        /**
         * Called if a Game Request is sent successfully.
         * @param requestID ID of the GameRequest that was just sent.
         * @param recipients List of IDs of Facebook users to which the request was sent.
         */
        function onFacebookGameRequestSuccess( requestID:String, recipients:Vector.<String> ):void;

        /**
         * Called if a Game Request dialog is cancelled.
         */
        function onFacebookGameRequestCancel():void;

        /**
         * Called if an error occurs during the Game Request process.
         * @param errorMessage Message describing the error.
         */
        function onFacebookGameRequestError( errorMessage:String ):void;

    }

}
