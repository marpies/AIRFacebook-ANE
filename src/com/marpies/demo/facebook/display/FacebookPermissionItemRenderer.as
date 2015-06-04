package com.marpies.demo.facebook.display {

    import feathers.controls.renderers.DefaultGroupedListItemRenderer;

    import starling.events.Event;

    public class FacebookPermissionItemRenderer extends DefaultGroupedListItemRenderer {

        public function FacebookPermissionItemRenderer() {
            super();
        }

        override public function get isSelected():Boolean {
            if( data ) {
                return data.isSelected;
            }
            return false;
        }

        override public function set isSelected( value:Boolean ):void {
            if( data ) {
                data.isSelected = !data.isSelected;
                invalidate( INVALIDATION_FLAG_SELECTED );
                invalidate( INVALIDATION_FLAG_STATE );
                dispatchEventWith( "permissionChanged", true, data );
            }
        }
    }

}
