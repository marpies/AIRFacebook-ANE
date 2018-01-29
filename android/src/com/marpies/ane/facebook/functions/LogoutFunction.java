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
import android.app.AlertDialog;
import android.content.DialogInterface;
import android.os.Build;
import com.adobe.fre.FREContext;
import com.adobe.fre.FREObject;
import com.facebook.login.LoginManager;
import com.marpies.ane.facebook.data.AIRFacebookEvent;
import com.marpies.ane.facebook.utils.AIR;
import com.marpies.ane.facebook.utils.FREObjectUtils;
import com.marpies.ane.facebook.utils.StringUtils;

public class LogoutFunction extends BaseFunction {

	@Override
	public FREObject call( FREContext context, FREObject[] args ) {
		super.call( context, args );

		mListenerID = FREObjectUtils.getIntFromFREObject( args[5] );

		final Activity activity = AIR.getContext().getActivity();

		try {
			Boolean confirmDialog = FREObjectUtils.getBooleanFromFREObject( args[0] );
			/* Show native confirm dialog if requested */
			if( confirmDialog ) {
				AIR.log( "Showing log out confirmation dialog." );
				String dialogTitle = FREObjectUtils.getStringFromFREObject( args[1] );
				String dialogMessage = FREObjectUtils.getStringFromFREObject( args[2] );
				String confirmLabel = FREObjectUtils.getStringFromFREObject( args[3] );
				String cancelLabel = FREObjectUtils.getStringFromFREObject( args[4] );
				/* Build the dialog with the latest possible theme */
				AlertDialog.Builder builder;
				if( Build.VERSION.SDK_INT >= Build.VERSION_CODES.ICE_CREAM_SANDWICH ) {
					builder = new AlertDialog.Builder( activity, AlertDialog.THEME_DEVICE_DEFAULT_DARK );	// Use device's default dark theme
				} else if( Build.VERSION.SDK_INT >= Build.VERSION_CODES.HONEYCOMB ) {
					builder = new AlertDialog.Builder( activity, AlertDialog.THEME_HOLO_DARK );	// Use Holo dark theme
				} else {
					builder = new AlertDialog.Builder( activity );
				}
				builder.setMessage(dialogMessage)
						.setCancelable( true )
						.setTitle( dialogTitle )
						.setPositiveButton( confirmLabel, new DialogInterface.OnClickListener() {
							public void onClick( DialogInterface dialog, int which ) {
								logout();
							}
						} )
						.setNegativeButton( cancelLabel, new DialogInterface.OnClickListener() {
							@Override
							public void onClick( DialogInterface dialogInterface, int i ) {
								AIR.log( "Log out cancelled." );
								AIR.dispatchEvent( AIRFacebookEvent.LOGOUT_CANCEL, StringUtils.getListenerJSONString( mListenerID ) );
							}
						} );
				builder.create().show();
			}
			/* Logout immediately */
			else {
				logout();
			}
		} catch( Exception exception ) {
			String errorMessage = "Unknown reason.";
			if( exception.getMessage() != null ) {
				errorMessage = exception.getMessage();
			}
			AIR.dispatchEvent( AIRFacebookEvent.LOGOUT_ERROR, StringUtils.getEventErrorJSON( mListenerID, errorMessage ) );
		}

		return null;
	}

	private void logout() {
		LoginManager.getInstance().logOut();
		AIR.dispatchEvent( AIRFacebookEvent.LOGOUT_SUCCESS, StringUtils.getListenerJSONString( mListenerID ) );
	}

}
