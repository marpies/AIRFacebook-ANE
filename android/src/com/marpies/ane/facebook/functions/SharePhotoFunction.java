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
import com.facebook.share.ShareApi;
import com.facebook.share.model.SharePhotoContent;
import com.marpies.ane.facebook.ShareActivity;
import com.marpies.ane.facebook.data.AIRFacebookEvent;
import com.marpies.ane.facebook.data.AIRFacebookShareType;
import com.marpies.ane.facebook.data.AIRFacebookSharedBitmap;
import com.marpies.ane.facebook.utils.*;

public class SharePhotoFunction extends BaseFunction implements SharePhotoContentBuilderCallback {

	/* Message to be added to the content when sharing without UI.
	 * Needs to be member variable as it is used in the callback. */
	private String mShareMessage;

	@Override
	public FREObject call( FREContext context, FREObject[] args ) {
		super.call( context, args );

		Boolean isUserGenerated = FREObjectUtils.getBooleanFromFREObject( args[1] );
		Boolean withoutUI = FREObjectUtils.getBooleanFromFREObject( args[2] );
		Boolean useMessengerApp = FREObjectUtils.getBooleanFromFREObject( args[3] );
		mShareMessage = (args[4] == null ) ? null : FREObjectUtils.getStringFromFREObject( args[4] );
		mListenerID = FREObjectUtils.getIntFromFREObject( args[5] );

		String imageURL = null;
		Bitmap image = null;
		/* Check if passed image object is BitmapData or String */
		if( args[0] != null ) {
			FREObject imageObject = args[0];
			if( imageObject instanceof FREBitmapData ) {
				try {
					image = BitmapDataUtils.getBitmap( (FREBitmapData) imageObject );
				} catch( FREWrongThreadException e ) {
					e.printStackTrace();
				} catch( FREInvalidObjectException e ) {
					e.printStackTrace();
				}
			} else {
				imageURL = FREObjectUtils.getStringFromFREObject( imageObject );
			}
		}

		Bundle extras = new Bundle();
		AIRFacebookShareType shareType = useMessengerApp ? AIRFacebookShareType.MESSAGE_PHOTO : AIRFacebookShareType.PHOTO;
		extras.putString( ShareActivity.extraPrefix + ".type", shareType.toString() );
		extras.putInt( ShareActivity.extraPrefix + ".listenerID", mListenerID );
		/* Store a global reference to the image */
		if( image != null ) {
			AIRFacebookSharedBitmap.DATA = image;
		}
		/* Or pass the image URL parameter */
		else if( imageURL != null ) {
			extras.putString( ShareActivity.extraPrefix + ".imageURL", imageURL );
		}
//		extras.putBoolean( ShareActivity.extraPrefix + ".withoutUI", withoutUI );
		extras.putBoolean( ShareActivity.extraPrefix + ".userGenerated", isUserGenerated );

		if( withoutUI ) {
			SharePhotoContentBuilder.createContentForParameters( extras, this );
		} else {
			AIR.startActivity( ShareActivity.class, extras );
		}

		return null;
	}

	/**
	 *
	 *
	 * Callbacks for SharePhotoContentBuilder (called only when sharing without UI)
	 *
	 *
	 */

	@Override
	public void onPhotoContentBuilderSucceeded( SharePhotoContent content ) {
		AIR.log( "Sharing photo without UI." );
		ShareApi shareApi = new ShareApi( content );
		if( mShareMessage != null ) {
			shareApi.setMessage( mShareMessage );
		}
		shareApi.share( ShareWithoutUICallback.getInstance( mListenerID ) );
	}

	@Override
	public void onPhotoContentBuilderFailed( String errorMessage ) {
		AIR.dispatchEvent( AIRFacebookEvent.SHARE_ERROR, StringUtils.getEventErrorJSON( mListenerID, errorMessage ) );
	}

}
