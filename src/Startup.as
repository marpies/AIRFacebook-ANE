package {

    import com.marpies.utils.Constants;

    import flash.desktop.NativeApplication;
    import flash.display.Sprite;
    import flash.display.StageAlign;
    import flash.display.StageDisplayState;
    import flash.display.StageScaleMode;
    import flash.display3D.Context3DProfile;
    import flash.events.Event;
    import flash.geom.Rectangle;
    import flash.system.Capabilities;
    import flash.utils.clearInterval;
    import flash.utils.setTimeout;

    import starling.core.Starling;
    import starling.events.Event;
    import starling.utils.HAlign;
    import starling.utils.RectangleUtil;
    import starling.utils.ScaleMode;
    import starling.utils.VAlign;

    [SWF(frameRate="60", backgroundColor="#1E2038")]
    public class Startup extends Sprite {

        private var mStarling:Starling;

        private var mBaseRect:Rectangle;
        private var mScreenRect:Rectangle;
        private var mViewport:Rectangle;
        private var mViewportBaseRatioWidth:Number;
        private var mViewportBaseRatioHeight:Number;

        private var mAssetsScale:Number;
        private var mHandleLostContext:Boolean;

        private var mTimeoutId:int = -1;

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

            setStageAndViewPort();

            initStarling();
        }

        private function initStarling():void {
            /* Initialize and start the Starling instance */
            Starling.handleLostContext = mHandleLostContext;
            mStarling = new Starling( Main, stage, mViewport, null, "auto", Context3DProfile.BASELINE );
            mStarling.stage.stageWidth = mScreenRect.width / mViewportBaseRatioWidth;
            mStarling.stage.stageHeight = mScreenRect.height / mViewportBaseRatioHeight;
            mStarling.addEventListener( starling.events.Event.ROOT_CREATED, onStarlingReady );

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
         * Helpers
         *
         *
         */

        private function setStageAndViewPort():void {
            mBaseRect = new Rectangle( 0, 0, Constants.IPAD_WIDTH, Constants.IPAD_HEIGHT );
            mScreenRect = new Rectangle( 0, 0, stage.stageWidth, stage.stageHeight );
            mViewport = RectangleUtil.fit( mBaseRect, mScreenRect, ScaleMode.SHOW_ALL );
            mViewportBaseRatioWidth = mViewport.width / mBaseRect.width;
            mViewportBaseRatioHeight = mViewport.height / mBaseRect.height;
            mViewport.copyFrom( mScreenRect );
            mViewport.x = 0;
            mViewport.y = 0;

            /* Set assets scale based on the iPad non-retina size */
            mAssetsScale = mScreenRect.width / 1024;
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
