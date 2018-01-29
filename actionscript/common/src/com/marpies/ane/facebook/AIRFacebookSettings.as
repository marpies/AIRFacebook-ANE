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

	/**
	 * Class that allows setting Facebook and extension settings.
	 * Changes only take effect when set before calling AIRFacebook.instance.init().
	 */
	public class AIRFacebookSettings {

		private var _urlSchemeSuffix:String = null;
		private var _showLogs:Boolean = false;

		/**
		 * @private
		 */
		public function AIRFacebookSettings() {
		}

		/**
		 * @private
		 */
		internal function get urlSchemeSuffix():String {
			return _urlSchemeSuffix;
		}

		/**
		 * [iOS only] The URL scheme suffix to be used in scenarios where you have multiple iOS
		 * apps using one Facebook Application ID.
		 *
		 * @see http://developers.facebook.com/docs/ios/troubleshooting#sharedappid
		 */
		public function setUrlSchemeSuffix( value:String ):AIRFacebookSettings {
			_urlSchemeSuffix = value;
			return this;
		}

		/**
		 * @private
		 */
		internal function get showLogs():Boolean {
			return _showLogs;
		}

		/**
		 * Set to <code>true</code> to show extension log messages.
		 */
		public function setShowLogs( value:Boolean ):AIRFacebookSettings {
			_showLogs = value;
			return this;
		}
	}

}
