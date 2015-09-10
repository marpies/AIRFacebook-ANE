package com.marpies.demo.facebook.screens {

    import com.marpies.ane.facebook.AIRFacebook;
    import com.marpies.ane.facebook.events.AIRFacebookShareEvent;
    import com.marpies.ane.facebook.listeners.IAIRFacebookAppInviteListener;
    import com.marpies.utils.Constants;
    import com.marpies.utils.Logger;
    import com.marpies.utils.VerticalLayoutBuilder;

    import feathers.controls.Button;
    import feathers.controls.Label;
    import feathers.controls.TextInput;
    import feathers.layout.AnchorLayoutData;
    import feathers.layout.VerticalLayout;

    import starling.events.Event;

    public class AppInviteScreen extends BaseScreen implements IAIRFacebookAppInviteListener {

        private var mInviteButton:Button;
        private var mAppLinkLabel:Label;
        private var mAppLinkInput:TextInput;
        private var mImageURLLabel:Label;
        private var mImageURLInput:TextInput;

        public function AppInviteScreen() {
            super();
        }

        override protected function initialize():void {
            super.initialize();

            title = "App invite";
            layout = new VerticalLayoutBuilder()
                    .setGap( 10 )
                    .setVerticalAlign( VerticalLayout.VERTICAL_ALIGN_MIDDLE )
                    .setHorizontalAlign( VerticalLayout.HORIZONTAL_ALIGN_CENTER )
                    .build();

            /* App link */
                /* Label */
            mAppLinkLabel = new Label();
            mAppLinkLabel.text = "App link:";
            addChild( mAppLinkLabel );
                /* Text input */
            mAppLinkInput = new TextInput();
            mAppLinkInput.width = Constants.stageWidth >> 1;
            mAppLinkInput.text = "http://fb.me/...";
            addChild( mAppLinkInput );

            /* Image URL */
                /* Label */
            mImageURLLabel = new Label();
            mImageURLLabel.text = "Image URL:";
            addChild( mImageURLLabel );
                /* Text input */
            mImageURLInput = new TextInput();
            mImageURLInput.width = Constants.stageWidth >> 1;
            mImageURLInput.text = "";
            addChild( mImageURLInput );

            /* App invite button */
            mInviteButton = new Button();
            mInviteButton.layoutData = new AnchorLayoutData( NaN, NaN, NaN, NaN, 0, 0 );
            mInviteButton.label = "Show app invite dialog";
            mInviteButton.addEventListener( Event.TRIGGERED, onInviteButtonTriggered );
            mInviteButton.isEnabled = AIRFacebook.isSupported;
            addChild( mInviteButton );
        }

        /**
         *
         *
         * UI handlers
         *
         *
         */

        private function onInviteButtonTriggered():void {
            /* This screen implements 'IAIRFacebookAppInviteListener', no need for event listener */
            //AIRFacebook.addEventListener( AIRFacebookShareEvent.SHARE_RESULT, onInviteDialogResult );

            AIRFacebook.showAppInviteDialog(
                    mAppLinkInput.text,
                    (mImageURLInput.text == "") ? null : mImageURLInput.text,
                    this
            )
        }

        /**
         *
         *
         * AIRFacebook handlers (methods defined by IAIRFacebookAppInviteListener interface)
         *
         *
         */

        public function onFacebookAppInviteSuccess():void {
            Logger.log( "App invitation was sent successfully." );
        }

        public function onFacebookAppInviteCancel():void {
            Logger.log( "App invitation was cancelled." );
        }

        public function onFacebookAppInviteError( errorMessage:String ):void {
            Logger.log( "Invite error: " + errorMessage );
        }

        /**
         * Event handlers (just for demonstration purposes)
         */

        private function onInviteDialogResult( event:AIRFacebookShareEvent ):void {
            AIRFacebook.removeEventListener( AIRFacebookShareEvent.SHARE_RESULT, onInviteDialogResult );
            if( event.errorMessage ) {
                Logger.log( "[EventHandler] Invite error: " + event.errorMessage );
            } else if( event.wasCancelled ) {
                Logger.log( "[EventHandler] App invitation was cancelled." );
            } else {
                Logger.log( "[EventHandler] App invitation was sent successfully." );
            }
        }

    }

}
