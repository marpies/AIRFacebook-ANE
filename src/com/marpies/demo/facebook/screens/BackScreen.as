package com.marpies.demo.facebook.screens {

    import com.marpies.demo.facebook.events.ScreenEvent;

    import feathers.controls.Button;
    import feathers.controls.PanelScreen;

    import starling.display.DisplayObject;
    import starling.events.Event;

    public class BackScreen extends PanelScreen {

        protected var mBackButton:Button;

        public function BackScreen() {
            super();
        }

        override protected function initialize():void {
            super.initialize();

            /* Add default menu button to the header */
            mBackButton = new Button();
            mBackButton.styleNameList.add( Button.ALTERNATE_STYLE_NAME_BACK_BUTTON );
            mBackButton.label = "BACK";
            mBackButton.addEventListener( Event.TRIGGERED, onBackButtonTriggered );
            headerProperties.leftItems = new <DisplayObject>[
                mBackButton
            ];
            backButtonHandler = onBackButton;
        }

        private function onBackButtonTriggered():void {
            popScreen();
        }

        private function onBackButton():void {
            popScreen();
        }

        private function popScreen():void {
            dispatchEventWith( ScreenEvent.POP );
        }

    }

}
