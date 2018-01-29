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

import com.facebook.FacebookCallback;
import com.facebook.FacebookException;
import com.facebook.share.Sharer;
import com.marpies.ane.facebook.data.AIRFacebookEvent;

/**
 * Callback used for share calls without UI.
 */
public class ShareWithoutUICallback implements FacebookCallback<Sharer.Result> {

	private static ShareWithoutUICallback mInstance;
	private static int mListenerID;

	private ShareWithoutUICallback() { }

	public static ShareWithoutUICallback getInstance( int listenerID ) {
		if( mInstance == null ) {
			mInstance = new ShareWithoutUICallback();
		}
		mListenerID = listenerID;
		return mInstance;
	}

	@Override
	public void onSuccess( Sharer.Result shareResult ) {
		AIR.log( "Share callback - success, post ID: " + shareResult.getPostId() );
		AIR.dispatchEvent( AIRFacebookEvent.SHARE_SUCCESS, StringUtils.getSingleValueJSONString( mListenerID, "postID", shareResult.getPostId() ) );
	}

	@Override
	public void onCancel() {
		AIR.log( "Share callback - cancelled" );
		AIR.dispatchEvent( AIRFacebookEvent.SHARE_CANCEL, StringUtils.getListenerJSONString( mListenerID ) );
	}

	@Override
	public void onError( FacebookException error ) {
		AIR.log( "[ShareActivity] share callback - error: " + error.getMessage() );
		AIR.dispatchEvent( AIRFacebookEvent.SHARE_ERROR, StringUtils.getEventErrorJSON( mListenerID, error.getMessage() ) );
	}

}
