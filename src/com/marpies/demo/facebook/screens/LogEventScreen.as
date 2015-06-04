package com.marpies.demo.facebook.screens {

    import com.marpies.ane.facebook.AIRFacebook;
    import com.marpies.utils.Constants;
    import com.marpies.utils.Logger;
    import com.marpies.utils.VerticalLayoutBuilder;

    import feathers.controls.Button;
    import feathers.controls.Label;
    import feathers.controls.PickerList;
    import feathers.controls.TextInput;
    import feathers.layout.VerticalLayout;

    import flash.text.SoftKeyboardType;

    import starling.display.DisplayObject;
    import starling.events.Event;

    public class LogEventScreen extends BaseScreen {

        private var mEventNameLabel:Label;
        private var mEventNameInput:TextInput;
        private var mParametersKeyLabel:Label;
        private var mParametersKeyInput:TextInput;
        private var mParametersValueLabel:Label;
        private var mParametersValueInput:TextInput;
        private var mValueToSumLabel:Label;
        private var mValueToSumInput:TextInput;
        private var mSendButton:Button;

        public function LogEventScreen() {
            super();
        }

        override protected function initialize():void {
            super.initialize();

            layout = new VerticalLayoutBuilder()
                    .setGap( 10 )
                    .setPadding( 10 )
                    .setHorizontalAlign( VerticalLayout.HORIZONTAL_ALIGN_CENTER )
                    .build();

            title = "Log app event";
            width = Constants.stageWidth;
            height = Constants.stageHeight;

            /* Request path */
                /* Label */
            mEventNameLabel = new Label();
            mEventNameLabel.text = "Event name:";
            addChild( mEventNameLabel );
                /* Input */
            mEventNameInput = new TextInput();
            mEventNameInput.width = Constants.stageWidth >> 1;
            mEventNameInput.text = "killed_boss";
            addChild( mEventNameInput );

            /* Parameters key */
                /* Label */
            mParametersKeyLabel = new Label();
            mParametersKeyLabel.text = "Parameters key:";
            addChild( mParametersKeyLabel );
                /* Input */
            mParametersKeyInput = new TextInput();
            mParametersKeyInput.width = Constants.stageWidth >> 2;
            mParametersKeyInput.text = "name";
            addChild( mParametersKeyInput );

            /* Parameters value */
                /* Label */
            mParametersValueLabel = new Label();
            mParametersValueLabel.text = "Parameters values:";
            addChild( mParametersValueLabel );
                /* Input */
            mParametersValueInput = new TextInput();
            mParametersValueInput.width = Constants.stageWidth >> 1;
            mParametersValueInput.text = "Big boned boss";
            addChild( mParametersValueInput );

            /* ValueToSum value */
                /* Label */
            mValueToSumLabel = new Label();
            mValueToSumLabel.text = "Value to sum:";
            addChild( mValueToSumLabel );
                /* Input */
            mValueToSumInput = new TextInput();
            mValueToSumInput.width = Constants.stageWidth >> 1;
            mValueToSumInput.text = "0.0";
            mValueToSumInput.textEditorProperties.softKeyboardType = SoftKeyboardType.NUMBER;
            addChild( mValueToSumInput );

            /* Send button on the right of the header */
            mSendButton = new Button();
            mSendButton.styleNameList.add( Button.ALTERNATE_STYLE_NAME_FORWARD_BUTTON );
            mSendButton.label = "LOG EVENT";
            mSendButton.isEnabled = AIRFacebook.isSupported;
            mSendButton.addEventListener( Event.TRIGGERED, onLogEventButtonTriggered );
            headerProperties.rightItems = new <DisplayObject> [
                mSendButton
            ];
        }

        /**
         *
         *
         * Button handlers
         *
         *
         */

        private function onLogEventButtonTriggered( event:Event ):void {
            var params:Object = null;
            if( mParametersKeyInput.text != "" ) {
                params = { };
                params[mParametersKeyInput.text] = mParametersValueInput.text;
            }
            AIRFacebook.logEvent( mEventNameInput.text, params, Number( mValueToSumInput.text ) );
            Logger.log( "Logging Facebook event: " + mEventNameInput.text );
        }

    }

}
