package com.marpies.demo.facebook.screens {

    import com.marpies.demo.facebook.events.ScreenEvent;

    import feathers.controls.Button;
    import feathers.controls.PanelScreen;

    import starling.display.DisplayObject;
    import starling.events.Event;

    public class BaseScreen extends PanelScreen {

        protected var mMenuButton:Button;

        public function BaseScreen() {
            super();
        }

        override protected function initialize():void {
            super.initialize();

            backButtonHandler = onBackButton;

            /* Add default menu button to the header */
            mMenuButton = new Button();
            mMenuButton.label = "MENU";
            mMenuButton.addEventListener( Event.TRIGGERED, onMenuButtonTriggered );
            headerProperties.leftItems = new <DisplayObject>[
                    mMenuButton
            ];
            backButtonHandler = onBackButton;
        }

        private function onMenuButtonTriggered():void {
            toggleMenu();
        }

        private function onBackButton():void {
            toggleMenu();
        }

        private function toggleMenu():void {
            dispatchEventWith( ScreenEvent.TOGGLE_MENU );
        }

    }

}
