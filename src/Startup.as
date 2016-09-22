package {

    import com.marpies.utils.Constants;

    import feathers.utils.ScreenDensityScaleFactorManager;

    import flash.desktop.NativeApplication;
    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageDisplayState;
    import flash.display.StageScaleMode;
    import flash.display3D.Context3DProfile;
    import flash.events.Event;
    import flash.system.Capabilities;
    import flash.utils.clearInterval;
    import flash.utils.setTimeout;

    import starling.core.Starling;
    import starling.events.Event;

    [SWF(frameRate="60", backgroundColor="#1E2038")]
    public class Startup extends Sprite {

        private var mStarling:Starling;

        private var mAssetsScale:Number;
        private var mHandleLostContext:Boolean;

        private var mTimeoutId:int = -1;
        private var mScreenDensityManager:ScreenDensityScaleFactorManager;

        public function Startup() {
            stage.align = StageAlign.TOP_LEFT;
            stage.scaleMode = StageScaleMode.NO_SCALE;
            stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;

            stage.addEventListener( flash.events.Event.RESIZE, onStageResize );
        }

        private function onStageResize( event:flash.events.Event ):void {
            stage.removeEventListener( flash.events.Event.RESIZE, onStageResize );
            if( mTimeoutId != -1 ) {
                clearInterval( mTimeoutId );
            }
            mTimeoutId = setTimeout( init, 50 );
        }

        /**
         *
         *
         * Initialization
         *
         *
         */

        private function init():void {
            /* Handle screen size etc. */
            var iOS:Boolean = (Capabilities.manufacturer.indexOf( "Mac" ) != -1) || (Capabilities.manufacturer.indexOf( "iOS" ) != -1);
            mHandleLostContext = !iOS;

            initStarling();
        }

        private function initStarling():void {
            /* Initialize and start the Starling instance */
            mStarling = new Starling( Main, stage, null, null, "auto", Context3DProfile.BASELINE );
            mStarling.skipUnchangedFrames = true;
            mStarling.addEventListener( starling.events.Event.ROOT_CREATED, onStarlingReady );

            mScreenDensityManager = new ScreenDensityScaleFactorManager( mStarling );

            /* Handle application Activation & Deactivation */
            NativeApplication.nativeApplication.addEventListener( flash.events.Event.ACTIVATE, onActivate );
            NativeApplication.nativeApplication.addEventListener( flash.events.Event.DEACTIVATE, onDeactivate );
        }

        /**
         *
         *
         * Signal / Event handlers
         *
         *
         */

        private function onStarlingReady( event:starling.events.Event, root:Main ):void {
            /* Initialize Constants and load assets */
            Constants.init( mStarling.stage.stageWidth, mStarling.stage.stageHeight, mAssetsScale );

            /* Start Starling */
            mStarling.start();

            /* Start Main */
            root.start();
        }

        /**
         *
         *
         * Application activate/deactivate handlers
         *
         *
         */

        private function onActivate( event:flash.events.Event ):void {
            mStarling.start();
        }

        private function onDeactivate( event:flash.events.Event ):void {
            mStarling.stop( true );
        }

    }

}
