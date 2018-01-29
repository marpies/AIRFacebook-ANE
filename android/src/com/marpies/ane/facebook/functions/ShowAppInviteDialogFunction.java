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
import com.marpies.ane.facebook.ShareActivity;
import com.marpies.ane.facebook.data.AIRFacebookShareType;
import com.marpies.ane.facebook.utils.AIR;
import com.marpies.ane.facebook.utils.FREObjectUtils;

public class ShowAppInviteDialogFunction extends BaseFunction {

	@Override
	public FREObject call( FREContext context, FREObject[] args ) {
		super.call( context, args );

		String appLinkURL = FREObjectUtils.getStringFromFREObject( args[0] );
		String imageURL = (args[1] == null ) ? null : FREObjectUtils.getStringFromFREObject( args[1] );
		mListenerID = FREObjectUtils.getIntFromFREObject( args[2] );

		Bundle extras = new Bundle();
		extras.putString( ShareActivity.extraPrefix + ".type", AIRFacebookShareType.APP_INVITE.toString() );
		extras.putString( ShareActivity.extraPrefix + ".appLinkURL", appLinkURL );
		extras.putInt( ShareActivity.extraPrefix + ".listenerID", mListenerID );
		if( imageURL != null ) {
			extras.putString( ShareActivity.extraPrefix + ".imageURL", imageURL );
		}

		AIR.startActivity( ShareActivity.class, extras );

		return null;
	}

}
