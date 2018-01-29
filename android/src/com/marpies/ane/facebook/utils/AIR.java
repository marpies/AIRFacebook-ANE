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

import android.content.Intent;
import android.content.pm.ResolveInfo;
import android.os.Bundle;
import android.util.Log;
import com.marpies.ane.facebook.AIRFacebookExtensionContext;

public class AIR {

	private static final String TAG = "AIRFacebook";
	private static Boolean mLogEnabled;

	private static AIRFacebookExtensionContext mContext;

	public static void log( String message ) {
		if( mLogEnabled ) {
			Log.i( TAG, message );
		}
	}

	public static void dispatchEvent( String eventName, String message ) {
		mContext.dispatchStatusEventAsync( eventName, message );
	}

	public static void startActivity( Class<?> activityClass, Bundle extras ) {
		Intent intent = new Intent( mContext.getActivity().getApplicationContext(), activityClass );
		ResolveInfo info = mContext.getActivity().getPackageManager().resolveActivity( intent, 0 );
		if( info == null ) {
			log( "Activity " + activityClass.getSimpleName() + " could not be started. Make sure you specified the activity in the android manifest." );
			return;
		}
		intent.putExtras( extras );
		mContext.getActivity().startActivity( intent );
	}

	/**
	 *
	 *
	 * Getters / Setters
	 *
	 *
	 */

	public static AIRFacebookExtensionContext getContext() {
		return mContext;
	}
	public static void setContext( AIRFacebookExtensionContext context ) {
		mContext = context;
	}

	public static Boolean getLogEnabled() {
		return mLogEnabled;
	}
	public static void setLogEnabled( Boolean value ) {
		mLogEnabled = value;
	}
}
