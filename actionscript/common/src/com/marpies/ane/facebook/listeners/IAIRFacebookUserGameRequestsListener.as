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

    import com.marpies.ane.facebook.data.AIRFacebookGameRequest;

    /**
     * Interface for objects that want to be notified about a user Game Requests request result.
     */
    public interface IAIRFacebookUserGameRequestsListener {

        /**
         * Called if the user Game Requests request is successful.
         * @param gameRequests List of Game Requests which were sent to current user.
         */
        function onFacebookUserGameRequestsSuccess( gameRequests:Vector.<AIRFacebookGameRequest> ):void;

        /**
         * Called if an error occurs during the user Game Requests request.
         * @param errorMessage Message describing the error.
         */
        function onFacebookUserGameRequestsError( errorMessage:String ):void;

    }

}
