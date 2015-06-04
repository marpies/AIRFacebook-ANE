package com.marpies.demo.facebook.display {

    import com.marpies.demo.facebook.events.ScreenEvent;
    import com.marpies.demo.facebook.screens.Screens;
    import com.marpies.utils.Constants;

    import feathers.controls.List;
    import feathers.controls.renderers.DefaultListItemRenderer;
    import feathers.controls.renderers.IListItemRenderer;
    import feathers.data.ListCollection;

    import starling.events.Event;

    public class MenuList extends List {

        public function MenuList() {
            super();
        }

        override protected function initialize():void {
            super.initialize();

            dataProvider = new ListCollection(
                    [
                        { screen: Screens.LOGIN, label: "Log in/out" },
                        { screen: Screens.SHARE_LINK, label: "Share link" },
                        { screen: Screens.SHARE_PHOTO, label: "Share photo" },
                        { screen: Screens.SHARE_OPEN_GRAPH_STORY, label: "Share Open Graph story" },
                        { screen: Screens.OPEN_GRAPH_REQUEST, label: "Open Graph requests" },
                        { screen: Screens.GAME_REQUEST, label: "Game Request requests" },
                        { screen: Screens.APP_INVITE, label: "App invite" },
                        { screen: Screens.LOG_EVENT, label: "Log app event" }
                    ]);
            minWidth = Constants.stageWidth >> 2;
            selectedIndex = 0;
            hasElasticEdges = false;
            itemRendererFactory = function():IListItemRenderer {
                const item:DefaultListItemRenderer = new DefaultListItemRenderer();
                item.labelField = "label";
                item.iconSourceField = "icon";
                return item;
            };
            clipContent = false;
            addEventListener( Event.CHANGE, onMenuChanged );
        }

        private function onMenuChanged():void {
            const screenName:String = selectedItem.screen as String;
            dispatchEventWith( ScreenEvent.SWITCH, false, { screen: screenName } );
        }

    }

}
