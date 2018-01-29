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

    import com.marpies.ane.facebook.data.ExtendedUserProfile;

    /**
     * Interface for objects that want to be notified about a user friends request result.
     */
    public interface IAIRFacebookUserFriendsListener {

        /**
         * Called if the user friends request is successful.
         * @param friends List of user's friends who have also authorized your application.
         */
        function onFacebookUserFriendsSuccess( friends:Vector.<ExtendedUserProfile> ):void;

        /**
         * Called if an error occurs during the user friends request.
         * @param errorMessage Message describing the error.
         */
        function onFacebookUserFriendsError( errorMessage:String ):void;

    }

}
