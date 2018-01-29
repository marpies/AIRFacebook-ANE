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

package com.marpies.ane.facebook.data {

    /**
     * Represents Facebook Game Requests which can be requested using
     * <code>AIRFacebook.requestUserGameRequests()</code>. Only the properties
     * specified in the <code>fields</code> parameter are available in the result.
     */
    public class AIRFacebookGameRequest {

        /**
         * @private
         */
        protected var mProperties:Object;

        /**
         * @private
         */
        public function AIRFacebookGameRequest():void { }

        /**
         *
         *
         * Getters / Setters
         *
         *
         */

        /**
         * ID of the Game Request.
         */
        public function get id():String {
            return ("id" in mProperties) ? mProperties.id : null;
        }

        /**
         * Returns one of the values specified in <code>AIRFacebookGameRequestActionType</code> or <code>"invite"</code>.
         */
        public function get actionType():String {
            return ("action_type" in mProperties) ? mProperties.action_type : AIRFacebookGameRequestActionType.NONE;
        }

        /**
         * Returns <code>Object</code> containing information about the application that was used to send
         * the request, or <code>null</code> if the field <code>application</code> was not specified in the call
         * requesting the Game Requests.
         */
        public function get application():Object {
            return ("application" in mProperties) ? mProperties.application : null;
        }

        /**
         * Specifies when the Game Request was created, in the format <code>yyyy-MM-dd'T'HH:mm:ss.SSSZ</code>,
         * e.g. <code>2015-02-25T13:37:00+0000</code>.
         */
        public function get createdTime():String {
            return ("created_time" in mProperties) ? mProperties.created_time : null;
        }

        /**
         * Additional freeform data that you sent along with the request, or <code>null</code> if the field
         * <code>data</code> was not specified in the call requesting the Game Requests.
         */
        public function get data():String {
            return ("data" in mProperties) ? mProperties.data : null;
        }

        /**
         * ID of the user sending the Game Request.
         */
        public function get senderID():String {
            return ("from" in mProperties) ? mProperties.from : null;
        }

        /**
         * ID of the user receiving the Game Request. This is <code>null</code> if the Game Request
         * is queried using sender's access token. To obtain this information using a sender's access token,
         * you need to append the Game Request ID with recipient ID and query this concatenated ID.
         *
         * <p>Format of concatenated Game Request ID: <code>{REQUEST_OBJECT_ID}_{USER_ID}</code>.</p>
         */
        public function get recipientID():String {
            return ("to" in mProperties) ? mProperties.to : null;
        }

        /**
         * Message that was sent along with the Game Request.
         */
        public function get message():String {
            if( "message" in mProperties ) return mProperties.message;
            return null;
        }

        /**
         * Returns <code>Object</code> (JSON) containing information about the object that was either sent or asked
         * for by the sender of the request, or <code>null</code> if the field <code>object</code> was not specified
         * in the call making the request or the <code>object</code> field is not supported for this <code>actionType</code>.
         */
        public function get object():Object {
            if( "object" in mProperties ) return mProperties.object;
            return null;
        }

        /**
         * @private
         */
        ns_airfacebook_internal function set properties( value:Object ):void {
            mProperties = value;
        }

    }

}
