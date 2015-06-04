package com.marpies.utils {

    import starling.core.Starling;

    public class Constants {

        private static var mScaleFactor:Number;
        private static var mAssetsScale:Number;
        private static var mStageWidth:int;
        private static var mStageHeight:int;

        public static const IPHONE_4_WIDTH:int = 480;
        public static const IPHONE_4_HEIGHT:int = 320;
        public static const IPHONE_5_WIDTH:int = 568;
        public static const IPHONE_5_HEIGHT:int = 320;
        public static const IPAD_WIDTH:int = 512;
        public static const IPAD_HEIGHT:int = 384;

        public static const MDPI:int = 200;
        public static const LDPI:int = 149;

        public static const SCREEN_7_INCH:Number = 7.0;

        public static function init( stageWidth:int, stageHeight:int, assetsScale:Number ):void {
            mStageWidth = stageWidth;
            mStageHeight = stageHeight;
            mScaleFactor = Starling.contentScaleFactor;
            mAssetsScale = assetsScale;
        }

        public static function get stageWidth():int {
            return mStageWidth;
        }

        public static function get stageHeight():int {
            return mStageHeight;
        }

        public static function get scaleFactor():Number {
            return mScaleFactor;
        }

        public static function get assetsScaleFactor():Number {
            return mAssetsScale;
        }

    }

}
