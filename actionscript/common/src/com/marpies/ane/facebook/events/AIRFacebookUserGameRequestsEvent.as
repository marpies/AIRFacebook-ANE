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

    import com.marpies.ane.facebook.data.AIRFacebookGameRequest;

    /**
     * Dispatched after a call to <code>AIRFacebook.requestUserGameRequests()</code>.
     * If the call was successful, this event provides a list of <code>AIRFacebookGameRequest</code>
     * instances which represent the Game Requests. Properties available in these instances
     * depend on the value of <code>fields</code> parameter when making the request.
     */
    public class AIRFacebookUserGameRequestsEvent extends AIRFacebookEvent {

        public static const REQUEST_RESULT:String = "userGameRequestsRequestResult";

        private var mGameRequests:Vector.<AIRFacebookGameRequest>;

        public function AIRFacebookUserGameRequestsEvent( type:String, bubbles:Boolean = false, cancelable:Boolean = false ) {
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
         * List of Game Requests which were sent to current user.
         */
        public function get gameRequests():Vector.<AIRFacebookGameRequest> {
            return mGameRequests;
        }

        /**
         * @private
         */
        ns_airfacebook_internal function set gameRequests( value:Vector.<AIRFacebookGameRequest> ):void {
            mGameRequests = value;
        }

    }

}
