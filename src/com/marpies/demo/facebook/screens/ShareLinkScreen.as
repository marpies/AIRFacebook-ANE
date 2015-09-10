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

    import starling.display.DisplayObject;
    import starling.events.Event;

    public class ShareLinkScreen extends BaseScreen implements IAIRFacebookShareListener {

        private var mTitleLabel:Label;
        private var mTitleInput:TextInput;
        private var mDescriptionLabel:Label;
        private var mDescriptionInput:TextInput;
        private var mContentURLLabel:Label;
        private var mContentURLInput:TextInput;
        private var mImageURLLabel:Label;
        private var mImageURLInput:TextInput;
        private var mWithoutUIMessageLabel:Label;
        private var mWithoutUIMessageInput:TextInput;
        private var mShareWithoutUICheck:Check;
        private var mUseMessengerCheck:Check;
        private var mShareButton:Button;

        public function ShareLinkScreen() {
            super();
        }

        override protected function initialize():void {
            super.initialize();

            layout = new VerticalLayoutBuilder()
                    .setGap( 10 )
                    .setPadding( 10 )
                    .setHorizontalAlign( VerticalLayout.HORIZONTAL_ALIGN_CENTER )
                    .build();

            title = "Share link";
            width = Constants.stageWidth;
            height = Constants.stageHeight;

            /* Title */
                /* Label */
            mTitleLabel = new Label();
            mTitleLabel.text = "Title:";
            addChild( mTitleLabel );
                /* Label */
            mTitleInput = new TextInput();
            mTitleInput.width = Constants.stageWidth >> 1;
            mTitleInput.text = "Starling is awesome!";
            addChild( mTitleInput );

            /* Description */
                /* Label */
            mDescriptionLabel = new Label();
            mDescriptionLabel.text = "Description:";
            addChild( mDescriptionLabel );
                /* Label */
            mDescriptionInput = new TextInput();
            mDescriptionInput.width = Constants.stageWidth >> 1;
            mDescriptionInput.text = "And Feathers UI too! That's right, right? Right.";
            addChild( mDescriptionInput );

            /* Content URL */
                /* Label */
            mContentURLLabel = new Label();
            mContentURLLabel.text = "Content URL:";
            addChild( mContentURLLabel );
                /* Label */
            mContentURLInput = new TextInput();
            mContentURLInput.width = Constants.stageWidth >> 1;
            mContentURLInput.text = "http://gamua.com/starling";
            addChild( mContentURLInput );

            /* Image URL */
                /* Label */
            mImageURLLabel = new Label();
            mImageURLLabel.text = "Image URL:";
            addChild( mImageURLLabel );
                /* Text input */
            mImageURLInput = new TextInput();
            mImageURLInput.width = Constants.stageWidth >> 1;
            mImageURLInput.text = "http://gamua.com/img/starling/title-logo.png";
            addChild( mImageURLInput );

            /* Without UI message */
                /* Label */
            mWithoutUIMessageLabel = new Label();
            mWithoutUIMessageLabel.text = "Message when sharing without UI:";
            addChild( mWithoutUIMessageLabel );
                /* Text input */
            mWithoutUIMessageInput = new TextInput();
            mWithoutUIMessageInput.width = Constants.stageWidth >> 1;
            mWithoutUIMessageInput.text = "Hello, sharing link with you...";
            addChild( mWithoutUIMessageInput );

            /* Share without UI Check */
            mShareWithoutUICheck = new Check();
            mShareWithoutUICheck.label = "Share without native UI";
            addChild( mShareWithoutUICheck );

            /* Share using Messenger app */
            mUseMessengerCheck = new Check();
            mUseMessengerCheck.isEnabled = AIRFacebook.canShareLinkMessage;
            mUseMessengerCheck.label = "Share using Messenger app";
            addChild( mUseMessengerCheck );

            /* Share button on the right of the header */
            mShareButton = new Button();
            mShareButton.styleNameList.add( Button.ALTERNATE_STYLE_NAME_FORWARD_BUTTON );
            mShareButton.label = "SHARE";
            mShareButton.isEnabled = AIRFacebook.isSupported && AIRFacebook.canShareLink;
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
                AIRFacebook.shareLinkMessage(
                        mTitleInput.text,
                        mContentURLInput.text,
                        mDescriptionInput.text,
                        mImageURLInput.text,
                        this
                );
            } else {
                AIRFacebook.shareLink(
                        mTitleInput.text,
                        mContentURLInput.text,
                        mDescriptionInput.text,
                        mImageURLInput.text,
                        mShareWithoutUICheck.isSelected,
                        mWithoutUIMessageInput.text,
                        this
                );
            }
        }

        /**
         *
         *
         * AIRFacebook handlers (methods defined by IAIRFacebookShareListener interface)
         *
         *
         */

        public function onFacebookShareSuccess( postID:String ):void {
            Logger.log( "Share link success, post id: " + postID );
        }

        public function onFacebookShareCancel():void {
            Logger.log( "Share link cancelled" );
        }

        public function onFacebookShareError( errorMessage:String ):void {
            Logger.log( "Share link error: " + errorMessage );
        }

        /**
         * Event handlers (just for demonstration purposes)
         */

        private function onShareResult( event:AIRFacebookShareEvent ):void {
            AIRFacebook.removeEventListener( AIRFacebookShareEvent.SHARE_RESULT, onShareResult );
            if( event.errorMessage ) {
                Logger.log( "[EventHandler] Share link error: " + event.errorMessage );
            } else if( event.wasCancelled ) {
                Logger.log( "[EventHandler] Share link cancelled" );
            } else {
                Logger.log( "[EventHandler] Share link success, post id: " + event.postID );
            }
        }

    }

}
