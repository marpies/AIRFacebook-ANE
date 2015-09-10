package com.marpies.demo.facebook.screens {

    import com.marpies.ane.facebook.AIRFacebook;
    import com.marpies.ane.facebook.events.AIRFacebookShareEvent;
    import com.marpies.ane.facebook.listeners.IAIRFacebookShareListener;
    import com.marpies.utils.Constants;
    import com.marpies.utils.Logger;
    import com.marpies.utils.VerticalLayoutBuilder;

    import feathers.controls.Button;
    import feathers.controls.Check;
    import feathers.controls.Label;
    import feathers.controls.TextInput;
    import feathers.layout.VerticalLayout;

    import flash.display.Bitmap;

    import starling.display.DisplayObject;
    import starling.display.Image;
    import starling.events.Event;

    public class SharePhotoScreen extends BaseScreen implements IAIRFacebookShareListener {

        [Embed(source="/../assets/starling-logo.png")]
        protected static const STARLING_LOGO:Class;

        private var mStarlingLogoImage:Image;
        private var mStarlingLogoBitmap:Bitmap;

        private var mTitleLabel:Label;
        private var mImageURLLabel:Label;
        private var mImageURLInput:TextInput;
        private var mWithoutUIMessageLabel:Label;
        private var mWithoutUIMessageInput:TextInput;
        private var mShareURLCheck:Check;
        private var mShareWithoutUICheck:Check;
        private var mUseMessengerCheck:Check;
        private var mShareButton:Button;

        public function SharePhotoScreen() {
            super();
        }

        override protected function initialize():void {
            super.initialize();

            layout = new VerticalLayoutBuilder()
                    .setGap( 10 )
                    .setPadding( 10 )
                    .setHorizontalAlign( VerticalLayout.HORIZONTAL_ALIGN_CENTER )
                    .build();

            title = "Share photo";
            width = Constants.stageWidth;
            height = Constants.stageHeight;

            /* Share title */
            mTitleLabel = new Label();
            mTitleLabel.text = "Sharing this image of starling bird!";
            mTitleLabel.styleNameList.add( Label.ALTERNATE_STYLE_NAME_HEADING );
            addChild( mTitleLabel );

            /* Add Starling logo image */
            mStarlingLogoBitmap = new STARLING_LOGO();
            mStarlingLogoImage = Image.fromBitmap( mStarlingLogoBitmap, false, Constants.scaleFactor );
            addChild( mStarlingLogoImage );

            /* Image URL */
                /* Label */
            mImageURLLabel = new Label();
            mImageURLLabel.text = "Image URL:";
            addChild( mImageURLLabel );
                /* Text input */
            mImageURLInput = new TextInput();
            mImageURLInput.width = Constants.stageWidth >> 1;
            mImageURLInput.text = "http://gamua.com/img/home/starling-look-bored.png";
            mImageURLInput.isEnabled = false;
            addChild( mImageURLInput );

            /* Without UI message */
                /* Label */
            mWithoutUIMessageLabel = new Label();
            mWithoutUIMessageLabel.text = "Message when sharing without UI:";
            addChild( mWithoutUIMessageLabel );
                /* Text input */
            mWithoutUIMessageInput = new TextInput();
            mWithoutUIMessageInput.width = Constants.stageWidth >> 1;
            mWithoutUIMessageInput.text = "Hello, sharing photo with you...";
            addChild( mWithoutUIMessageInput );

            /* Share URL Check */
            mShareURLCheck = new Check();
            mShareURLCheck.label = "Share URL instead of Bitmap";
            mShareURLCheck.addEventListener( Event.CHANGE, onShareURLCheckChange );
            addChild( mShareURLCheck );

            /* Share without UI Check */
            mShareWithoutUICheck = new Check();
            mShareWithoutUICheck.label = "Share without native UI";
            addChild( mShareWithoutUICheck );

            /* Share using Messenger app */
            mUseMessengerCheck = new Check();
            mUseMessengerCheck.isEnabled = AIRFacebook.canSharePhotoMessage;
            mUseMessengerCheck.label = "Share using Messenger app";
            addChild( mUseMessengerCheck );

            /* Share button on the right of the header */
            mShareButton = new Button();
            mShareButton.styleNameList.add( Button.ALTERNATE_STYLE_NAME_FORWARD_BUTTON );
            mShareButton.label = "Share";
            mShareButton.isEnabled = AIRFacebook.isSupported && AIRFacebook.canSharePhoto;
            mShareButton.addEventListener( Event.TRIGGERED, onShareButtonTriggered );
            headerProperties.rightItems = new <DisplayObject> [
                mShareButton
            ];
        }

        /**
         *
         *
         * UI handlers
         *
         *
         */

        private function onShareButtonTriggered( event:Event ):void {
            /* This screen implements 'IAIRFacebookShareListener', no need for event listener */
            //AIRFacebook.addEventListener( AIRFacebookShareEvent.SHARE_RESULT, onShareResult );

            if( mUseMessengerCheck.isSelected ) {
                AIRFacebook.sharePhotoMessage(
                        mShareURLCheck.isSelected ? mImageURLInput.text : mStarlingLogoBitmap.bitmapData,
                        false,
                        this
                );
            } else {
                AIRFacebook.sharePhoto(
                        mShareURLCheck.isSelected ? mImageURLInput.text : mStarlingLogoBitmap.bitmapData,
                        false,
                        mShareWithoutUICheck.isSelected,
                        mWithoutUIMessageInput.text,
                        this
                );
            }
        }

        private function onShareURLCheckChange( event:Event ):void {
            mStarlingLogoImage.alpha = mShareURLCheck.isSelected ? 0.5 : 1.0;
            mImageURLInput.isEnabled = mShareURLCheck.isSelected;
        }

        /**
         *
         *
         * AIRFacebook handlers (methods defined by IAIRFacebookShareListener interface)
         *
         *
         */

        public function onFacebookShareSuccess( postID:String ):void {
            Logger.log( "Share photo success, post id: " + postID );
        }

        public function onFacebookShareCancel():void {
            Logger.log( "Share photo cancelled" );
        }

        public function onFacebookShareError( errorMessage:String ):void {
            Logger.log( "Share photo error: " + errorMessage );
        }

        /**
         * Event handlers (just for demonstration purposes)
         */

        private function onShareResult( event:AIRFacebookShareEvent ):void {
            AIRFacebook.removeEventListener( AIRFacebookShareEvent.SHARE_RESULT, onShareResult );
            if( event.errorMessage ) {
                Logger.log( "[EventHandler] Share photo error: " + event.errorMessage );
            } else if( event.wasCancelled ) {
                Logger.log( "[EventHandler] Share photo cancelled" );
            } else {
                Logger.log( "[EventHandler] Share photo success, post id: " + event.postID );
            }
        }

    }

}
