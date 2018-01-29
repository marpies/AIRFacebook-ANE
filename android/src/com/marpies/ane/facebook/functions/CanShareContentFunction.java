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

package com.marpies.ane.facebook.functions;

import android.app.Activity;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREObject;
import com.adobe.fre.FREWrongThreadException;
import com.facebook.internal.FacebookDialogBase;
import com.facebook.share.Sharer;
import com.facebook.share.model.ShareContent;
import com.facebook.share.model.ShareLinkContent;
import com.facebook.share.model.ShareOpenGraphContent;
import com.facebook.share.model.SharePhotoContent;
import com.facebook.share.widget.MessageDialog;
import com.facebook.share.widget.ShareDialog;
import com.marpies.ane.facebook.data.AIRFacebookShareType;
import com.marpies.ane.facebook.utils.AIR;
import com.marpies.ane.facebook.utils.FREObjectUtils;

public class CanShareContentFunction extends BaseFunction {

	@Override
	public FREObject call( FREContext context, FREObject[] args ) {
		super.call( context, args );

		AIRFacebookShareType contentType = AIRFacebookShareType.valueOf( FREObjectUtils.getStringFromFREObject( args[0] ) );

		FacebookDialogBase<ShareContent, Sharer.Result> dialog = null;
		ShareContent content = null;

		Activity activity = AIR.getContext().getActivity();
		/* Create content and dialog based on the content we are asking to share */
		switch( contentType ) {
			case LINK:
				dialog = new ShareDialog( activity );
				content = new ShareLinkContent.Builder().build();
				break;
			case PHOTO:
				dialog = new ShareDialog( activity );
				content = new SharePhotoContent.Builder().build();
				break;
			case MESSAGE_LINK:
				dialog = new MessageDialog( activity );
				content = new ShareLinkContent.Builder().build();
				break;
			case MESSAGE_PHOTO:
				dialog = new MessageDialog( activity );
				content = new SharePhotoContent.Builder().build();
				break;
			case OPEN_GRAPH_STORY:
				dialog = new ShareDialog( activity );
				content = new ShareOpenGraphContent.Builder().build();
				break;
		}

		try {
			if( dialog == null || content == null ) {
				return FREObject.newObject( false );
			}
			return FREObject.newObject( dialog.canShow( content ) );
		} catch( FREWrongThreadException e ) {
			e.printStackTrace();
			return null;
		}
	}

}
