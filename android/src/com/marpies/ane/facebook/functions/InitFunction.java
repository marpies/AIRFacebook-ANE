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

import com.adobe.fre.FREContext;
import com.adobe.fre.FREObject;
import com.facebook.FacebookSdk;
import com.marpies.ane.facebook.data.AIRFacebookEvent;
import com.marpies.ane.facebook.utils.AIR;
import com.marpies.ane.facebook.utils.AIRFacebookProfileTracker;
import com.marpies.ane.facebook.utils.CachedAccessTokenLoader;
import com.marpies.ane.facebook.utils.FREObjectUtils;

public class InitFunction extends BaseFunction implements FacebookSdk.InitializeCallback {

	@Override
	public FREObject call( FREContext freContext, FREObject[] args ) {
		super.call( freContext, args );

		if( FacebookSdk.isInitialized() ) return null;

		String appID = FREObjectUtils.getStringFromFREObject( args[0] );
		Boolean showLogs = FREObjectUtils.getBooleanFromFREObject( args[2] );
		int listenerID = FREObjectUtils.getIntFromFREObject( args[3] );
		AIR.setLogEnabled( showLogs );

		/* Call init with the Application ID */
		FacebookSdk.setApplicationId( appID );
		FacebookSdk.sdkInitialize( AIR.getContext().getActivity().getApplicationContext(), this );

		/* Start tracking profile changes */
		AIRFacebookProfileTracker.startTracking();
		/* Check cached access token */
		CachedAccessTokenLoader.load( listenerID );

		return null;
	}

	@Override
	public void onInitialized() {
		AIR.log( "Facebook SDK initialized | v" + FacebookSdk.getSdkVersion() );

		AIR.dispatchEvent( AIRFacebookEvent.SDK_INIT, "" );
	}

}
