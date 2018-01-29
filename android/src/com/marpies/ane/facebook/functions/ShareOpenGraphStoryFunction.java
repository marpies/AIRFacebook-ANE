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

import android.graphics.Bitmap;
import android.os.Bundle;
import com.adobe.fre.*;
import com.marpies.ane.facebook.ShareActivity;
import com.marpies.ane.facebook.data.AIRFacebookShareType;
import com.marpies.ane.facebook.data.AIRFacebookSharedBitmap;
import com.marpies.ane.facebook.utils.AIR;
import com.marpies.ane.facebook.utils.BitmapDataUtils;
import com.marpies.ane.facebook.utils.FREObjectUtils;

public class ShareOpenGraphStoryFunction extends BaseFunction {

	@Override
	public FREObject call( FREContext context, FREObject[] args ) {
		super.call( context, args );

		String actionType = FREObjectUtils.getStringFromFREObject( args[0] );
		String objectType = FREObjectUtils.getStringFromFREObject( args[1] );
		String title = FREObjectUtils.getStringFromFREObject( args[2] );

		String imageURL = null;
		Bitmap image = null;
		/* Check if passed image object is BitmapData or String */
		if( args[3] != null ) {
			if( args[3] instanceof FREBitmapData ) {
				try {
					image = BitmapDataUtils.getBitmap( (FREBitmapData) args[3] );
				} catch( FREWrongThreadException e ) {
					e.printStackTrace();
				} catch( FREInvalidObjectException e ) {
					e.printStackTrace();
				}
			} else {
				imageURL = FREObjectUtils.getStringFromFREObject( args[3] );
			}
		}
		Bundle objectProperties = (args[4] == null) ? null : FREObjectUtils.getBundleFromFREArray( (FREArray) args[4] );
		mListenerID = FREObjectUtils.getIntFromFREObject( args[5] );

		Bundle extras = new Bundle();
		extras.putString( ShareActivity.extraPrefix + ".type", AIRFacebookShareType.OPEN_GRAPH_STORY.toString() );
		extras.putString( ShareActivity.extraPrefix + ".actionType", actionType );
		extras.putString( ShareActivity.extraPrefix + ".objectType", objectType );
		extras.putString( ShareActivity.extraPrefix + ".title", title );
		extras.putInt( ShareActivity.extraPrefix + ".listenerID", mListenerID );
		if( image != null ) {
			AIRFacebookSharedBitmap.DATA = image;
		} else if( imageURL != null ) {
			extras.putString( ShareActivity.extraPrefix + ".imageURL", imageURL );
		}
		if( objectProperties != null ) {
			extras.putBundle( ShareActivity.extraPrefix + ".objectProperties", objectProperties );
		}

		AIR.startActivity( ShareActivity.class, extras );

		return null;
	}

}
