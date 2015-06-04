package com.marpies.demo.facebook.screens {

    import com.marpies.ane.facebook.AIRFacebook;
    import com.marpies.ane.facebook.events.AIRFacebookShareEvent;
    import com.marpies.utils.Constants;
    import com.marpies.utils.Logger;
    import com.marpies.utils.VerticalLayoutBuilder;

    import feathers.controls.Button;
    import feathers.controls.Check;
    import feathers.controls.Header;
    import feathers.controls.Label;
    import feathers.controls.PanelScreen;
    import feathers.controls.TextInput;
    import feathers.layout.VerticalLayout;

    import flash.display.Bitmap;

    import starling.display.DisplayObject;
    import starling.display.Image;
    import starling.events.Event;

    public class ShareOpenGraphStoryScreen extends BaseScreen {

        [Embed(source="/../assets/starling-logo.png")]
        protected static const STARLING_LOGO:Class;

        private var mStarlingLogoImage:Image;
        private var mStarlingLogoBitmap:Bitmap;

        private var mHeadingLabel:Label;
        private var mTitleLabel:Label;
        private var mTitleInput:TextInput;
        private var mActionTypeLabel:Label;
        private var mActionTypeInput:TextInput;
        private var mObjectTypeLabel:Label;
        private var mObjectTypeInput:TextInput;
        private var mImageURLLabel:Label;
        private var mImageURLInput:TextInput;
        private var mShareBitmapCheck:Check;
        private var mShareButton:Button;

        public function ShareOpenGraphStoryScreen() {
            super();
        }

        override protected function initialize():void {
            super.initialize();

            layout = new VerticalLayoutBuilder()
                    .setGap( 10 )
                    .setPadding( 10 )
                    .setHorizontalAlign( VerticalLayout.HORIZONTAL_ALIGN_CENTER )
                    .build();

            title = "Share Open Graph story";
            width = Constants.stageWidth;
            height = Constants.stageHeight;

            /* Heading label */
            mHeadingLabel = new Label();
            mHeadingLabel.text = "Note the following info must match your Facebook app settings.";
            addChild( mHeadingLabel );

            /* Action type */
                /* Label */
            mActionTypeLabel = new Label();
            mActionTypeLabel.text = "Action type:";
            addChild( mActionTypeLabel );
                /* Input */
            mActionTypeInput = new TextInput();
            mActionTypeInput.width = Constants.stageWidth >> 1;
            mActionTypeInput.text = "app_namespace:craft";
            addChild( mActionTypeInput );

            /* Object type */
                /* Label */
            mObjectTypeLabel = new Label();
            mObjectTypeLabel.text = "Object type:";
            addChild( mObjectTypeLabel );
                /* Input */
            mObjectTypeInput = new TextInput();
            mObjectTypeInput.width = Constants.stageWidth >> 1;
            mObjectTypeInput.text = "app_namespace:weapon";
            addChild( mObjectTypeInput );

            /* Title */
                /* Label */
            mTitleLabel = new Label();
            mTitleLabel.text = "Title:";
            addChild( mTitleLabel );
                /* Input */
            mTitleInput = new TextInput();
            mTitleInput.width = Constants.stageWidth >> 1;
            mTitleInput.text = "Cool weapon";
            addChild( mTitleInput );

            /* Image URL */
                /* Label */
            mImageURLLabel = new Label();
            mImageURLLabel.text = "Image URL:";
            addChild( mImageURLLabel );
                /* Input */
            mImageURLInput = new TextInput();
            mImageURLInput.width = Constants.stageWidth >> 1;
            mImageURLInput.text = "http://gamua.com/img/home/starling-look-bored.png";
            addChild( mImageURLInput );

            /* Share bitmap Check */
            mShareBitmapCheck = new Check();
            mShareBitmapCheck.label = "Share Bitmap instead of image URL";
            mShareBitmapCheck.addEventListener( Event.CHANGE, onShareBitmapChange );
            addChild( mShareBitmapCheck );

            /* Add Starling logo image */
            mStarlingLogoBitmap = new STARLING_LOGO();
            mStarlingLogoImage = Image.fromBitmap( mStarlingLogoBitmap, false, Constants.scaleFactor );
            mStarlingLogoImage.alpha = 0.5;
            addChild( mStarlingLogoImage );

            /* Share button on the right of the header */
            mShareButton = new Button();
            mShareButton.styleNameList.add( Button.ALTERNATE_STYLE_NAME_FORWARD_BUTTON );
            mShareButton.label = "SHARE";
            mShareButton.isEnabled = AIRFacebook.isSupported && AIRFacebook.canShareOpenGraphStory;
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

        private function onShareBitmapChange():void {
            mImageURLInput.isEnabled = !mShareBitmapCheck.isSelected;
            mStarlingLogoImage.alpha = mShareBitmapCheck.isSelected ? 1.0 : 0.5;
        }

        private function onShareButtonTriggered( event:Event ):void {
            AIRFacebook.addEventListener( AIRFacebookShareEvent.SHARE_RESULT, onShareResult );
            AIRFacebook.shareOpenGraphStory(
                    mActionTypeInput.text,
                    mObjectTypeInput.text,
                    mTitleInput.text,
                    mShareBitmapCheck.isSelected ? mStarlingLogoBitmap.bitmapData : mImageURLInput.text,
                    null // Could be for example { "app_namespace:weapon_rarity": "LEGENDARY" }
            );
        }

        private function onShareResult( event:AIRFacebookShareEvent ):void {
            AIRFacebook.removeEventListener( AIRFacebookShareEvent.SHARE_RESULT, onShareResult );
            if( event.errorMessage ) {
                Logger.log( "Share Open Graph story error: " + event.errorMessage );
            } else if( event.wasCancelled ) {
                Logger.log( "Share Open Graph story cancelled" );
            } else {
                Logger.log( "Share Open Graph story success, post ID: " + event.postID );
            }
        }

    }

}
