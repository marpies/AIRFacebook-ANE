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

package com.marpies.ane.facebook.utils;

import android.net.Uri;
import android.os.Bundle;
import com.facebook.share.model.ShareLinkContent;
import com.marpies.ane.facebook.ShareActivity;

public class ShareLinkContentBuilder {

	public static ShareLinkContent getContentForParameters( Bundle parameters ) {
		// todo: add setPeopleIds, setPlaceId ....

		ShareLinkContent.Builder contentBuilder = new ShareLinkContent.Builder();
		if( parameters.containsKey( ShareActivity.extraPrefix + ".contentURL" ) ) {
			contentBuilder.setContentUrl( Uri.parse( parameters.getString( ShareActivity.extraPrefix + ".contentURL" ) ) );
		}

		return contentBuilder.build();
	}

}
