package com.marpies.demo.facebook.events {

    import starling.events.Event;

    public class ScreenEvent extends Event {

        public static const SWITCH:String = "switch";
        public static const TOGGLE_MENU:String = "toggleMenu";
        public static const POP:String = "pop";

        public function ScreenEvent( type:String, bubbles:Boolean = false, data:Object = null ) {
            super( type, bubbles, data );
        }

    }

}
