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

    import flash.net.URLVariables;

    /**
     * Interface for objects that want to be notified when your application is invoked from a Game Request notification.
     */
    public interface IAIRFacebookGameRequestInvokeListener {

        /**
         * Called when your application is invoked from a Game Request notification.
         * @param requestIDs List of GameRequest IDs which were sent to the user. Use the IDs with <code>AIRFacebook.requestUserGameRequests()</code>.
         * @param URLVars Parsed variables from the invoked URL.
         * @param arguments Original <code>flash.events.InvokeEvent</code> arguments.
         * @param fullURL URL that was handled by the invoke event.
         * @param reason Reason of the invoke event.
         */
        function onFacebookGameRequestInvoke( requestIDs:Vector.<String>, URLVars:URLVariables, arguments:Array, fullURL:String, reason:String ):void;

    }

}
