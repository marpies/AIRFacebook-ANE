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

import android.graphics.Bitmap;
import android.os.Bundle;
import com.facebook.share.model.SharePhoto;
import com.facebook.share.model.SharePhotoContent;
import com.marpies.ane.facebook.ShareActivity;
import com.marpies.ane.facebook.data.AIRFacebookSharedBitmap;

public class SharePhotoContentBuilder {

	/**
	 * The content may or may not be built synchronously depending if the image is
	 * provided as a bitmap or an URL that must be loaded first, therefore the result
	 * is returned in the form of a callback.
	 */
	public static void createContentForParameters( Bundle parameters, final SharePhotoContentBuilderCallback callback ) {
		// todo: add setPeopleIds, setPlaceId ....

		final SharePhoto.Builder photo = new SharePhoto.Builder()
				.setUserGenerated( parameters.getBoolean( ShareActivity.extraPrefix + ".userGenerated" ) );
		/* Add photo from BitmapData */
		if( AIRFacebookSharedBitmap.DATA != null ) {
			AIR.log( "Sharing photo using BitmapData." );
			callback.onPhotoContentBuilderSucceeded( getPhotoContent( AIRFacebookSharedBitmap.DATA, photo ) );
		}
		/* Or add photo from URL */
		else if( parameters.containsKey( ShareActivity.extraPrefix + ".imageURL" ) ) {
			AIR.log( "Loading photo from URL before sharing." );
			final String imageURL = parameters.getString( ShareActivity.extraPrefix + ".imageURL" );
			new AsyncImageLoader() {
				@Override
				protected void onPostExecute( Bitmap bitmap ) {
					super.onPostExecute( bitmap );
					if( bitmap != null ) {
						callback.onPhotoContentBuilderSucceeded( getPhotoContent( bitmap, photo ) );
					} else {
						callback.onPhotoContentBuilderFailed( "Error loading '" + imageURL + "' file." + (!imageURL.startsWith( "http" ) ? " Perhaps missing READ_EXTERNAL_STORAGE permission?" : "") );
					}
				}
			}.execute( imageURL );
		} else {
			callback.onPhotoContentBuilderFailed( "Invalid bitmap data encountered." );
		}
	}

	private static SharePhotoContent getPhotoContent( Bitmap bitmap, SharePhoto.Builder photo ) {
		photo.setBitmap( bitmap );
		return new SharePhotoContent.Builder()
				.addPhoto( photo.build() )
				.build();
	}

}
