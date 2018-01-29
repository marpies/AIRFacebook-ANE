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

package com.marpies.ane.facebook;

import android.app.Activity;
import android.content.Intent;
import android.os.Bundle;
import com.facebook.*;
import com.facebook.login.LoginManager;
import com.facebook.login.LoginResult;
import com.marpies.ane.facebook.data.AIRFacebookEvent;
import com.marpies.ane.facebook.data.AIRFacebookPermissionType;
import com.marpies.ane.facebook.utils.AIR;
import com.marpies.ane.facebook.utils.AIRFacebookProfileTracker;
import com.marpies.ane.facebook.utils.StringUtils;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;

public class LoginActivity extends Activity {

	public static String extraPrefix = "com.marpies.ane.facebook.LoginActivity";

	/* Callbacks */
	CallbackManager mCallbackManager;
	FacebookCallback<LoginResult> mLoginCallback;

	private int mListenerID;	// From ActionScript

	@Override
	protected void onCreate( Bundle savedInstanceState ) {
		super.onCreate( savedInstanceState );

		/* Initialize helper objects like ProfileTracker and callbacks */
		initHelperObjects();

		/* Track changes in user profile */
		AIRFacebookProfileTracker.startTracking();

		/* Register callbacks to LoginManager */
		LoginManager loginManager = LoginManager.getInstance();
		loginManager.registerCallback( mCallbackManager, mLoginCallback );

		/* Extra params */
		Bundle extras = getIntent().getExtras();
		mListenerID = extras.getInt( extraPrefix + ".listenerID" );
		String[] arrayPermissions = extras.getStringArray( extraPrefix + ".permissions" );
		List<String> permissions = null;
		if( arrayPermissions != null ) {
			permissions = new ArrayList<String>( Arrays.asList( arrayPermissions ) );
		}
		AIRFacebookPermissionType type = AIRFacebookPermissionType.valueOf( extras.getString( extraPrefix + ".permission_type" ) );
		switch( type ) {
			case READ:
				AIR.log( "[LoginActivity] logging in read with permissions " + permissions );
				loginManager.logInWithReadPermissions( this, permissions );
				break;
			case PUBLISH:
				AIR.log( "[LoginActivity] logging in publish with permissions " + permissions );
				loginManager.logInWithPublishPermissions( this, permissions );
				break;
			default:
				AIR.dispatchEvent( AIRFacebookEvent.LOGIN_ERROR,
						StringUtils.getEventErrorJSON( mListenerID, "Unknown permission type " + type )
				);
				finish();
				return;
		}
	}

	/**
	 *
	 *
	 * Login callbacks
	 *
	 *
	 */

	private void onLoginSucceeded( LoginResult loginResult ) {
		AIR.log( "[LoginActivity] login callback - success" );
		AIR.dispatchEvent(
				AIRFacebookEvent.LOGIN_SUCCESS,
				String.format(
						StringUtils.locale,
						"{ \"granted_permissions\": \"%s\", \"denied_permissions\": \"%s\", \"access_token\": \"%s\", \"listenerID\": %d }",
						loginResult.getRecentlyGrantedPermissions().toString(),
						loginResult.getRecentlyDeniedPermissions().toString(),
						loginResult.getAccessToken().getToken(),
						mListenerID
				)
		);
		finish();
	}

	private void onLoginCancelled() {
		AIR.log( "[LoginActivity] login callback - cancelled" );
		AIR.dispatchEvent( AIRFacebookEvent.LOGIN_CANCEL, String.format( StringUtils.locale, "{ \"listenerID\": %d }", mListenerID ) );
		finish();
	}

	private void onLoginFailed( FacebookException error ) {
		AIR.log( "[LoginActivity] login callback - error: " + error.getMessage() );
		AIR.dispatchEvent( AIRFacebookEvent.LOGIN_ERROR,
				StringUtils.getEventErrorJSON( mListenerID, error.getMessage() )
		);
		finish();
	}

	/**
	 *
	 *
	 * Overridden Activity API
	 *
	 *
	 */

	@Override
	public void onBackPressed() {
		finish();
	}

	@Override
	protected void onActivityResult( int requestCode, int resultCode, Intent data ) {
		super.onActivityResult( requestCode, resultCode, data );
		mCallbackManager.onActivityResult( requestCode, resultCode, data );
	}

	/**
	 *
	 *
	 * Helper objects initialization
	 *
	 *
	 */

	private void initHelperObjects() {
		/* Callback manager */
		mCallbackManager = CallbackManager.Factory.create();
		/* Login callback */
		mLoginCallback = new FacebookCallback<LoginResult>() {
			@Override
			public void onSuccess( LoginResult loginResult ) {
				onLoginSucceeded( loginResult );
			}

			@Override
			public void onCancel() {
				onLoginCancelled();
			}

			@Override
			public void onError( FacebookException error ) {
				onLoginFailed( error );
			}
		};
	}

}