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

import android.os.Bundle;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREObject;
import com.facebook.share.ShareApi;
import com.marpies.ane.facebook.ShareActivity;
import com.marpies.ane.facebook.data.AIRFacebookShareType;
import com.marpies.ane.facebook.utils.AIR;
import com.marpies.ane.facebook.utils.FREObjectUtils;
import com.marpies.ane.facebook.utils.ShareLinkContentBuilder;
import com.marpies.ane.facebook.utils.ShareWithoutUICallback;

public class ShareLinkFunction extends BaseFunction {

	@Override
	public FREObject call( FREContext context, FREObject[] args ) {
		super.call( context, args );

		String contentURL = FREObjectUtils.getStringFromFREObject( args[0] );
		Boolean withoutUI = (args[1] == null ) ? Boolean.FALSE : FREObjectUtils.getBooleanFromFREObject( args[1] );
		Boolean useMessengerApp = (args[2] == null ) ? Boolean.FALSE : FREObjectUtils.getBooleanFromFREObject( args[2] );
		String message = (args[3] == null ) ? null : FREObjectUtils.getStringFromFREObject( args[3] );
		mListenerID = FREObjectUtils.getIntFromFREObject( args[4] );

		Bundle extras = new Bundle();
		AIRFacebookShareType shareType = useMessengerApp ? AIRFacebookShareType.MESSAGE_LINK : AIRFacebookShareType.LINK;
		extras.putString( ShareActivity.extraPrefix + ".type", shareType.toString() );
		extras.putInt( ShareActivity.extraPrefix + ".listenerID", mListenerID );
		if( contentURL != null ) {
			extras.putString( ShareActivity.extraPrefix + ".contentURL", contentURL );
		}

		/* Do not launch sharing activity if there is not native UI involved */
		if( withoutUI ) {
			ShareApi shareApi = new ShareApi( ShareLinkContentBuilder.getContentForParameters( extras ) );
			if( message != null ) {
				shareApi.setMessage( message );
			}
			AIR.log( "Sharing link without UI." );
			shareApi.share( ShareWithoutUICallback.getInstance( mListenerID ) );
		}
		/* Otherwise launch sharing activity */
		else {
			AIR.startActivity( ShareActivity.class, extras );
		}

		return null;
	}

}
