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

import java.util.Locale;

public class StringUtils {

	public static final Locale locale = new Locale("en","US");

	public static String getEventErrorJSON( final int listenerID, String errorMessage ) {
		return String.format(
				locale,
				"{ \"listenerID\": %d, \"errorMessage\": \"%s\" }",
				listenerID,
				removeLineBreaks( errorMessage ).replace( "\"", "\\\"" )
		);
	}

	public static String getSingleValueJSONString( final int listenerID, String key, String value ) {
		return String.format(
				locale,
				"{ \"listenerID\": %d, \"%s\": \"%s\" }",
				listenerID,
				key,
				value
		);
	}

	public static String getListenerJSONString( final int listenerID ) {
		return String.format( locale, "{ \"listenerID\": %d }", listenerID );
	}

	public static String removeLineBreaks( String message ) {
		return message.replace( "\n", "" ).replace( "\r", "" );
	}

}
