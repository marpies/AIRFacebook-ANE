package com.marpies.utils {

    public class ObjectUtils {

        public static function printObject( object:Object, indent:String = "" ):void {
            for( var key:String in object ) {
                const value:Object = object[key];
                if( value is Array ) {
                    Logger.log( indent + key + " -> Array( " + value + " )" );
                } else {
                    Logger.log( indent + key + " -> " + value );
                }
                printObject( value, indent + "  " );
            }
        }

    }

}
