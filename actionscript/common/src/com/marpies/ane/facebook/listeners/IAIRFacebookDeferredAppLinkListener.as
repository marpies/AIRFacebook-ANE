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

    import com.marpies.ane.facebook.data.AIRFacebookLinkParameter;

    /**
     * Interface for objects that want to be notified about a deferred app link request result.
     */
    public interface IAIRFacebookDeferredAppLinkListener {

        /**
         * Called if a deferred app link was fetched successfully from the server.
         * @param targetURL The deferred deep link.
         * @param parameters If the deferred deep link specified parameters after a question mark then these will be
         *                   parsed by the ANE and available in this parameter, otherwise you will have to parse the
         *                   parameters from <code>targetURL</code> yourself.
         */
        function onFacebookDeferredAppLinkSuccess( targetURL:String, parameters:Vector.<AIRFacebookLinkParameter> ):void;

        /**
         * Called if a deferred app link was not found on the server.
         */
        function onFacebookDeferredAppLinkNotFound():void;

        /**
         * Called if an error occurred during the process.
         * @param errorMessage Message describing the error.
         */
        function onFacebookDeferredAppLinkError( errorMessage:String ):void;

    }

}
