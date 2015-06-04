package {

    import com.marpies.ane.facebook.AIRFacebook;
    import com.marpies.demo.facebook.display.MenuList;
    import com.marpies.demo.facebook.events.ScreenEvent;
    import com.marpies.demo.facebook.screens.AppInviteScreen;
    import com.marpies.demo.facebook.screens.GameRequestScreen;
    import com.marpies.demo.facebook.screens.LogEventScreen;
    import com.marpies.demo.facebook.screens.LoginScreen;
    import com.marpies.demo.facebook.screens.OpenGraphRequestScreen;
    import com.marpies.demo.facebook.screens.PermissionsScreen;
    import com.marpies.demo.facebook.screens.Screens;
    import com.marpies.demo.facebook.screens.ShareLinkScreen;
    import com.marpies.demo.facebook.screens.ShareOpenGraphStoryScreen;
    import com.marpies.demo.facebook.screens.SharePhotoScreen;
    import com.marpies.utils.AlertManager;

    import feathers.controls.Drawers;

    import feathers.controls.StackScreenNavigator;
    import feathers.controls.StackScreenNavigatorItem;
    import feathers.motion.Fade;
    import feathers.motion.Slide;
    import feathers.themes.MetalWorksMobileTheme;

    import starling.display.Sprite;
    import starling.events.Event;

    public class Main extends Sprite {

        private var mMenu:MenuList;
        private var mDrawers:Drawers;
        private var mScreenNavigator:StackScreenNavigator;

        public function Main() {
            super();
        }

        public function start():void {
            new MetalWorksMobileTheme();

            init();
        }

        /**
         *
         *
         * Private API
         *
         *
         */

        private function init():void {
            const forceSupport:Boolean = true;
            if( AIRFacebook.isSupported || forceSupport ) {
                /* List of permissions. Shared between Permissions and Login screens. */
                const permissions:Vector.<String> = new <String>[];

                /* Screen navigator */
                mScreenNavigator = new StackScreenNavigator();
                mScreenNavigator.pushTransition = Fade.createFadeInTransition();
                mScreenNavigator.popTransition = Fade.createFadeOutTransition();

                /* Login screen */
                const loginScreenItem:StackScreenNavigatorItem = new StackScreenNavigatorItem( LoginScreen );
                loginScreenItem.setScreenIDForPushEvent( "show" + Screens.PERMISSIONS, Screens.PERMISSIONS );
                loginScreenItem.properties.permissions = permissions;
                mScreenNavigator.addScreen( Screens.LOGIN, loginScreenItem );

                /* Permissions screen */
                const permissionsScreenItem:StackScreenNavigatorItem = new StackScreenNavigatorItem( PermissionsScreen, null, ScreenEvent.POP );
                permissionsScreenItem.properties.permissions = permissions;
                mScreenNavigator.addScreen( Screens.PERMISSIONS, permissionsScreenItem );

                /* Share link screen */
                mScreenNavigator.addScreen( Screens.SHARE_LINK, new StackScreenNavigatorItem( ShareLinkScreen ) );

                /* Share photo screen */
                mScreenNavigator.addScreen( Screens.SHARE_PHOTO, new StackScreenNavigatorItem( SharePhotoScreen ) );

                /* Share Open Graph story screen */
                mScreenNavigator.addScreen( Screens.SHARE_OPEN_GRAPH_STORY, new StackScreenNavigatorItem( ShareOpenGraphStoryScreen ) );

                /* Open Graph request screen */
                mScreenNavigator.addScreen( Screens.OPEN_GRAPH_REQUEST, new StackScreenNavigatorItem( OpenGraphRequestScreen ) );

                /* Game Request screen */
                mScreenNavigator.addScreen( Screens.GAME_REQUEST, new StackScreenNavigatorItem( GameRequestScreen ) );

                /* App invite screen */
                mScreenNavigator.addScreen( Screens.APP_INVITE, new StackScreenNavigatorItem( AppInviteScreen ) );

                /* Log event screen */
                mScreenNavigator.addScreen( Screens.LOG_EVENT, new StackScreenNavigatorItem( LogEventScreen ) );

                /* Set root screen */
                mScreenNavigator.rootScreenID = Screens.LOGIN;

                /* Menu list for the Drawers */
                mMenu = new MenuList();
                mMenu.addEventListener( ScreenEvent.SWITCH, onScreenSwitch );

                /* Drawers */
                mDrawers = new Drawers( mScreenNavigator );
                mDrawers.leftDrawer = mMenu;
                mDrawers.clipDrawers = false;
                mDrawers.leftDrawerToggleEventType = ScreenEvent.TOGGLE_MENU;
                addChild( mDrawers );
            } else {
                AlertManager.show(
                        "notSupported",
                        "Unsupported platform",
                        "AIRFacebook is not supported on this platform."
                );
            }
        }

        private function onScreenSwitch( event:Event ):void {
            mScreenNavigator.pushScreen( event.data.screen );
            mDrawers.toggleLeftDrawer();
        }

    }

}
