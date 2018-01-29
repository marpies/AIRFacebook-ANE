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

package com.marpies.ane.facebook {

    public class AIRFacebook extends BaseAIRFacebook {

        public static function get VERSION():String {
            return AIRFACEBOOK_VERSION;
        }

        /* Singleton stuff */
        private static var mCanInitialize:Boolean;
        private static var mInstance:IAIRFacebook;

        /**
         * @private
         */
        public function AIRFacebook() {
            super();

            if( !mCanInitialize ) {
                throw new Error( "AIRFacebook is a singleton, use instance getter." );
            }
        }

        public static function get instance():IAIRFacebook {
            if( !mInstance ) {
                mCanInitialize = true;
                mInstance = new AIRFacebook();
                mCanInitialize = false;
            }
            return mInstance;
        }

        override public function get isSupported():Boolean {
            return true;
        }

    }
}
