package com.marpies.utils {

    public class Logger {

        private static const TAG:String = "[AIRFacebookDemo]";

        public static function log( message:String ):void {
            trace( TAG, message );
        }

    }

}
