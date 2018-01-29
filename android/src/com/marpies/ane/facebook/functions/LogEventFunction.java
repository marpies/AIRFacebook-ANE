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
import com.facebook.appevents.AppEventsLogger;
import com.marpies.ane.facebook.utils.AIR;
import com.marpies.ane.facebook.utils.FREObjectUtils;

public class LogEventFunction extends BaseFunction {

	private static AppEventsLogger mLogger = null;
	private static final double EPSILON = 0.0000001;

	@Override
	public FREObject call( FREContext context, FREObject[] args ) {
		super.call( context, args );

		String eventName = FREObjectUtils.getStringFromFREObject( args[0] );
		Bundle parameters = null;
		if( args[1] != null ) {
			parameters = FREObjectUtils.getBundleFromFREArray( (FREArray) args[1] );
		}
		double valueToSum = FREObjectUtils.getDoubleFromFREObject( args[2] );

		if( parameters != null ) {
			if( isZero( valueToSum ) ) {
				getLogger().logEvent( eventName, parameters );
			} else {
				getLogger().logEvent( eventName, valueToSum, parameters );
			}
		} else {
			if( isZero( valueToSum ) ) {
				getLogger().logEvent( eventName );
			} else {
				getLogger().logEvent( eventName, valueToSum );
			}
		}

		AIR.log( "Logging event " + eventName + "." );

		return null;
	}

	public boolean isZero( double value ) {
		return value >= -EPSILON && value <= EPSILON;
	}

	private AppEventsLogger getLogger() {
		if( mLogger == null ) {
			mLogger = AppEventsLogger.newLogger( AIR.getContext().getActivity() );
		}
		return mLogger;
	}

}
