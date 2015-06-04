package com.marpies.demo.facebook.screens {

    import com.marpies.demo.facebook.data.FacebookPermissions;
    import com.marpies.demo.facebook.display.FacebookPermissionItemRenderer;
    import com.marpies.utils.Constants;

    import feathers.controls.GroupedList;
    import feathers.controls.renderers.DefaultGroupedListItemRenderer;
    import feathers.controls.renderers.IGroupedListItemRenderer;
    import feathers.data.HierarchicalCollection;
    import feathers.layout.AnchorLayout;

    import starling.events.Event;

    public class PermissionsScreen extends BackScreen {

        private var mPermissions:Vector.<String>;

        private var mList:GroupedList;

        public function PermissionsScreen() {
            super();
        }

        override protected function initialize():void {
            super.initialize();

            title = "Set permissions";
            width = Constants.stageWidth;
            height = Constants.stageHeight;
            layout = new AnchorLayout();
            padding = 10;

            mList = new GroupedList();
            mList.width = Constants.stageWidth - 30;
            mList.dataProvider = new HierarchicalCollection( FacebookPermissions.LIST );
            mList.typicalItem = { text: "user_education_history", isSelected: false };
            mList.isSelectable = true;
            mList.hasElasticEdges = false;
            mList.addEventListener( "permissionChanged", onPermissionChanged );
            mList.itemRendererFactory = function ():IGroupedListItemRenderer {
                var renderer:DefaultGroupedListItemRenderer = new FacebookPermissionItemRenderer();
                //enable the quick hit area to optimize hit tests when an item
                //is only selectable and doesn't have interactive children.
                renderer.isQuickHitAreaEnabled = true;
                renderer.labelField = "text";
                return renderer;
            };
            addChild( mList );
        }

        private function onPermissionChanged( event:Event ):void {
            event.stopImmediatePropagation();
            /* Either add or remove the permission */
            if( event.data.isSelected ) {
                mPermissions.push( event.data.text );
            } else {
                mPermissions.splice( mPermissions.indexOf( event.data.text ), 1 );
            }
        }

        /**
         *
         *
         * Getters / Setters
         *
         *
         */

        public function get permissions():Vector.<String> {
            return mPermissions;
        }

        public function set permissions( value:Vector.<String> ):void {
            mPermissions = value;
        }

    }

}
