package com.marpies.utils {

    import feathers.controls.Alert;
    import feathers.data.ListCollection;

    import flash.utils.Dictionary;

    import starling.core.Starling;
    import starling.events.Event;

    public class AlertManager {

        private static var mAlerts:Dictionary;

        public static function show( id:String, title:String, message:String, buttons:ListCollection = null ):void {
            if( !mAlerts ) {
                mAlerts = new Dictionary();
            }

            if( id in mAlerts ) throw new Error( "Alert with ID '" + id + "' is already shown." );

            const alert:Alert = Alert.show( message, title, buttons );
            mAlerts[id] = alert;
            alert.addEventListener( Event.CLOSE, onAlertClosed );
        }

        public static function close( id:String, delay:Number = 0.0 ):void {
            if( id in mAlerts ) {
                if( delay > 0 ) {
                    Starling.juggler.delayCall( function():void {
                        closeAlert( id );
                    }, delay );
                } else {
                    closeAlert( id );
                }
            }
        }

        private static function closeAlert( id:String ):void {
            Alert( mAlerts[id] ).removeFromParent( true );
            delete mAlerts[id];
        }

        private static function onAlertClosed( event:Event ):void {
            const alert:Alert = Alert( event.currentTarget );
            alert.removeEventListener( Event.CLOSE, onAlertClosed );
            for ( var id:String in mAlerts ) {
                const storedAlert:Alert = Alert( mAlerts[id] );
                if( storedAlert == alert ) {
                    delete mAlerts[id];
                    return;
                }
            }
        }

    }

}
