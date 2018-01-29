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
import com.marpies.ane.facebook.LoginActivity;
import com.marpies.ane.facebook.utils.AIR;
import com.marpies.ane.facebook.utils.FREObjectUtils;

public class LoginWithPermissionsFunction extends BaseFunction {

	@Override
	public FREObject call( FREContext context, FREObject[] args ) {
		super.call( context, args );

		String[] permissions = (args[0] == null) ? null : FREObjectUtils.getArrayOfStringFromFREArray( (FREArray) args[0] );
		String permissionType = FREObjectUtils.getStringFromFREObject( args[1] );	// Either READ or PUBLISH
		int listenerID = FREObjectUtils.getIntFromFREObject( args[2] );

		Bundle extras = new Bundle();
		if( permissions != null ) {
			extras.putStringArray( LoginActivity.extraPrefix + ".permissions", permissions );
		}
		extras.putString( LoginActivity.extraPrefix + ".permission_type", permissionType );
		extras.putInt( LoginActivity.extraPrefix + ".listenerID", listenerID );

		AIR.startActivity( LoginActivity.class, extras );

		return null;
	}

}
