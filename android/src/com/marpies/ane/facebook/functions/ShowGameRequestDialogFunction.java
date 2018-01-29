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
import com.adobe.fre.FREArray;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREObject;
import com.facebook.share.model.GameRequestContent;
import com.marpies.ane.facebook.ShareActivity;
import com.marpies.ane.facebook.data.AIRFacebookShareType;
import com.marpies.ane.facebook.utils.AIR;
import com.marpies.ane.facebook.utils.FREObjectUtils;

import java.util.ArrayList;
import java.util.List;

public class ShowGameRequestDialogFunction extends BaseFunction {

	@Override
	public FREObject call( FREContext context, FREObject[] args ) {
		super.call( context, args );

		String message = FREObjectUtils.getStringFromFREObject( args[0] );
		String actionType = (args[1] == null ) ? null : FREObjectUtils.getStringFromFREObject( args[1] );
		String title = (args[2] == null ) ? null : FREObjectUtils.getStringFromFREObject( args[2] );
		String objectID = (args[3] == null ) ? null : FREObjectUtils.getStringFromFREObject( args[3] );
		String friendsFilter = (args[4] == null ) ? null : FREObjectUtils.getStringFromFREObject( args[4] );
		String data = (args[5] == null ) ? null : FREObjectUtils.getStringFromFREObject( args[5] );
		ArrayList<String> suggestedFriends = (args[6] == null ) ? null : (ArrayList<String>)FREObjectUtils.getListOfStringFromFREArray( (FREArray)args[6] );
		ArrayList<String> recipients = (args[7] == null ) ? null : (ArrayList<String>)FREObjectUtils.getListOfStringFromFREArray( (FREArray)args[7] );
		mListenerID = FREObjectUtils.getIntFromFREObject( args[8] );

		Bundle extras = new Bundle();
		extras.putString( ShareActivity.extraPrefix + ".type", AIRFacebookShareType.GAME_REQUEST.toString() );
		extras.putString( ShareActivity.extraPrefix + ".message", message );
		extras.putInt( ShareActivity.extraPrefix + ".listenerID", mListenerID );
		if( actionType != null && !actionType.equals( "NONE" ) ) {
			extras.putString( ShareActivity.extraPrefix + ".actionType", actionType );
		}
		if( title != null ) {
			extras.putString( ShareActivity.extraPrefix + ".title", title );
		}
		if( objectID != null ) {
			extras.putString( ShareActivity.extraPrefix + ".objectID", objectID );
		}
		if( friendsFilter != null ) {
			if( friendsFilter.equals( "appUsers" ) ) {
				extras.putString( ShareActivity.extraPrefix + ".friendsFilter", GameRequestContent.Filters.APP_USERS.toString() );
			} else {
				extras.putString( ShareActivity.extraPrefix + ".friendsFilter", GameRequestContent.Filters.APP_NON_USERS.toString() );
			}
		}
		if( data != null ) {
			extras.putString( ShareActivity.extraPrefix + ".data", data );
		}
		if( suggestedFriends != null ) {
			extras.putStringArrayList( ShareActivity.extraPrefix + ".suggestedFriends", suggestedFriends );
		}
		if( recipients != null ) {
			extras.putStringArrayList( ShareActivity.extraPrefix + ".recipients", recipients );
		}

		AIR.startActivity( ShareActivity.class, extras );

		return null;
	}

}
