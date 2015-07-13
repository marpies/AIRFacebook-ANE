package com.marpies.demo.facebook.screens {

    import com.marpies.ane.facebook.AIRFacebook;
    import com.marpies.ane.facebook.data.AIRFacebookGameRequest;
    import com.marpies.ane.facebook.data.AIRFacebookGameRequestFilter;
    import com.marpies.ane.facebook.data.AIRFacebookGameRequestType;
    import com.marpies.ane.facebook.events.AIRFacebookGameRequestEvent;
    import com.marpies.ane.facebook.events.AIRFacebookOpenGraphEvent;
    import com.marpies.ane.facebook.events.AIRFacebookUserGameRequestsEvent;
    import com.marpies.utils.Constants;
    import com.marpies.utils.HorizontalLayoutBuilder;
    import com.marpies.utils.Logger;
    import com.marpies.utils.VerticalLayoutBuilder;

    import feathers.controls.Button;
    import feathers.controls.Label;
    import feathers.controls.LayoutGroup;
    import feathers.controls.PickerList;
    import feathers.controls.TextInput;
    import feathers.data.ListCollection;
    import feathers.layout.VerticalLayout;

    import starling.display.DisplayObject;
    import starling.events.Event;

    public class GameRequestScreen extends BaseScreen {

        private var mRequestTypeLabel:Label;
        private var mRequestTypeDropdown:PickerList;
        private var mFilterTypeLabel:Label;
        private var mFilterTypeDropdown:PickerList;
        private var mMessageLabel:Label;
        private var mMessageInput:TextInput;
        private var mTitleLabel:Label;
        private var mTitleInput:TextInput;
        private var mObjectIDLabel:Label;
        private var mObjectIDInput:TextInput;
        private var mDataLabel:Label;
        private var mDataInput:TextInput;
        private var mFriendIDLabel:Label;
        private var mFriendIDInput:TextInput;
        private var mAppRequestsDropdown:PickerList;
        private var mRequestAppRequestsButton:Button;
        private var mDeleteAppRequestButton:Button;
        private var mSendButton:Button;

        public function GameRequestScreen() {
            super();
        }

        override protected function initialize():void {
            super.initialize();

            title = "Game request";
            width = Constants.stageWidth;
            height = Constants.stageHeight;
            layout = new HorizontalLayoutBuilder()
                    .setGap( 20 )
                    .setPadding( 10 )
                    .build();

            /* Layout groups (columns) */
            const columnLayout:VerticalLayout = new VerticalLayoutBuilder().setGap( 10 ).setPadding( 10 ).build();
            const column1:LayoutGroup = new LayoutGroup();
            column1.layout = columnLayout;
            addChild( column1 );

            const column2:LayoutGroup = new LayoutGroup();
            column2.layout = columnLayout;
            addChild( column2 );

            /* Request type */
                /* Label */
            mRequestTypeLabel = new Label();
            mRequestTypeLabel.text = "Request type:";
            column1.addChild( mRequestTypeLabel );
                /* Dropdown */
            mRequestTypeDropdown = new PickerList();
            mRequestTypeDropdown.dataProvider = new ListCollection(
                    [
                        { text: AIRFacebookGameRequestType.ASK_FOR.toUpperCase() },
                        { text: AIRFacebookGameRequestType.SEND.toUpperCase() },
                        { text: AIRFacebookGameRequestType.TURN.toUpperCase() }
                    ]
            );
            mRequestTypeDropdown.typicalItem = "ASK_FOR";
            mRequestTypeDropdown.labelField = "text";
            mRequestTypeDropdown.listProperties.@itemRendererProperties.labelField = "text";
            mRequestTypeDropdown.addEventListener( Event.CHANGE, onRequestTypeChanged );
            column1.addChild( mRequestTypeDropdown );

            /* Filter type */
                /* Label */
            mFilterTypeLabel = new Label();
            mFilterTypeLabel.text = "Filter type:";
            column1.addChild( mFilterTypeLabel );
                /* Dropdown */
            mFilterTypeDropdown = new PickerList();
            mFilterTypeDropdown.dataProvider = new ListCollection(
                    [
                        { text: "None" },
                        { text: AIRFacebookGameRequestFilter.APP_USERS },
                        { text: AIRFacebookGameRequestFilter.APP_NON_USERS }
                    ]
            );
            mFilterTypeDropdown.typicalItem = "APPNONUSERS";
            mFilterTypeDropdown.labelField = "text";
            mFilterTypeDropdown.listProperties.@itemRendererProperties.labelField = "text";
            mFilterTypeDropdown.addEventListener( Event.CHANGE, onRequestTypeChanged );
            column1.addChild( mFilterTypeDropdown );

            /* Message */
                /* Label */
            mMessageLabel = new Label();
            mMessageLabel.text = "Message:";
            column1.addChild( mMessageLabel );
                /* Input */
            mMessageInput = new TextInput();
            mMessageInput.width = Constants.stageWidth >> 1;
            mMessageInput.text = "Gimme life or something..";
            column1.addChild( mMessageInput );

            /* Title */
                /* Label */
            mTitleLabel = new Label();
            mTitleLabel.text = "Title:";
            column1.addChild( mTitleLabel );
                /* Input */
            mTitleInput = new TextInput();
            mTitleInput.width = Constants.stageWidth >> 2;
            mTitleInput.text = "Game Request title";
            column1.addChild( mTitleInput );

            /* Object ID */
                /* Label */
            mObjectIDLabel = new Label();
            mObjectIDLabel.text = "Object ID:";
            column1.addChild( mObjectIDLabel );
                /* Input */
            mObjectIDInput = new TextInput();
            mObjectIDInput.width = Constants.stageWidth >> 2;
            mObjectIDInput.text = "744663038965383";    //
            column1.addChild( mObjectIDInput );

            /* Data */
                /* Label */
            mDataLabel = new Label();
            mDataLabel.text = "Data:";
            column1.addChild( mDataLabel );
                /* Input */
            mDataInput = new TextInput();
            mDataInput.width = Constants.stageWidth >> 1;
            mDataInput.text = "";
            column1.addChild( mDataInput );

            /* Friend ID */
                /* Label */
            mFriendIDLabel = new Label();
            mFriendIDLabel.text = "Friend ID:";
            column1.addChild( mFriendIDLabel );
                /* Input */
            mFriendIDInput = new TextInput();
            mFriendIDInput.width = Constants.stageWidth >> 2;
            mFriendIDInput.text = "";
            column1.addChild( mFriendIDInput );

            /* App requests - request and delete */
            mAppRequestsDropdown = new PickerList();
            mAppRequestsDropdown.typicalItem = "Select request";
            mAppRequestsDropdown.prompt = "Select request";
            mAppRequestsDropdown.labelField = "actionType";
            mAppRequestsDropdown.listProperties.@itemRendererProperties.labelField = "actionType";
            mAppRequestsDropdown.addEventListener( Event.CHANGE, onRequestTypeChanged );
            column2.addChild( mAppRequestsDropdown );

            /* App requests buttons */
            mRequestAppRequestsButton = new Button();
            mRequestAppRequestsButton.label = "Request game requests for user";
            mRequestAppRequestsButton.isEnabled = AIRFacebook.isSupported;
            mRequestAppRequestsButton.addEventListener( Event.TRIGGERED, onRequestUserGameRequestsButtonTriggered );
            column2.addChild( mRequestAppRequestsButton );
            mDeleteAppRequestButton = new Button();
            mDeleteAppRequestButton.label = "Delete game request";
            mDeleteAppRequestButton.isEnabled = AIRFacebook.isSupported;
            mDeleteAppRequestButton.nameList.add( Button.ALTERNATE_STYLE_NAME_DANGER_BUTTON );
            mDeleteAppRequestButton.addEventListener( Event.TRIGGERED, onDeleteUserGameRequestButtonTriggered );
            column2.addChild( mDeleteAppRequestButton );

            /* Send button on the right of the header */
            mSendButton = new Button();
            mSendButton.styleNameList.add( Button.ALTERNATE_STYLE_NAME_FORWARD_BUTTON );
            mSendButton.label = "SEND";
            mSendButton.isEnabled = AIRFacebook.isSupported && AIRFacebook.canShowGameRequestDialog;
            mSendButton.addEventListener( Event.TRIGGERED, onSendButtonTriggered );
            headerProperties.rightItems = new <DisplayObject> [
                mSendButton
            ];
        }

        /**
         *
         *
         * UI handlers
         *
         *
         */

        private function onSendButtonTriggered( event:Event ):void {
            AIRFacebook.addEventListener( AIRFacebookGameRequestEvent.REQUEST_RESULT, onRequestResult );
            const requestType:String = mRequestTypeDropdown.selectedItem.text.toLowerCase();
            const data:String = (mDataInput.text != "") ? mDataInput.text : null;
            const friendID:String = (mFriendIDInput.text != "") ? mFriendIDInput.text : null;
            const filter:String = (mFilterTypeDropdown.selectedIndex == 0) ? null : mFilterTypeDropdown.selectedItem.text;

            switch( requestType ) {
                case "askfor":
                    Logger.log( "Showing ASK_FOR dialog" );
                    AIRFacebook.showGameRequestDialog( requestType, mMessageInput.text, mTitleInput.text, mObjectIDInput.text, filter, data, null, friendID );
                    break;
                case "send":
                    Logger.log( "Showing SEND dialog" );
                    AIRFacebook.showGameRequestDialog( requestType, mMessageInput.text, mTitleInput.text, mObjectIDInput.text, filter, data, null, friendID );
                    break;
                case "turn":
                    Logger.log( "Showing TURN dialog" );
                    AIRFacebook.showGameRequestDialog( requestType, mMessageInput.text, mTitleInput.text, null, filter, data, null, friendID );
                    break;
            }
        }

        private function onRequestUserGameRequestsButtonTriggered():void {
            AIRFacebook.addEventListener( AIRFacebookUserGameRequestsEvent.REQUEST_RESULT, onUserGameRequestsResult );
            AIRFacebook.requestUserGameRequests( new <String>[
                "action_type",
                "application",
                "created_time",
                "data",
                "from",
                "id",
                "message",
                "object",
                "to"
            ] );
        }

        private function onDeleteUserGameRequestButtonTriggered():void {
            if( mAppRequestsDropdown.selectedIndex >= 0 ) {
                const request:AIRFacebookGameRequest = mAppRequestsDropdown.selectedItem as AIRFacebookGameRequest;
                if( request ) {
                    Logger.log( "Game request to delete: " + request.id + " " + request.message + " " + request.actionType );
                    AIRFacebook.addEventListener( AIRFacebookOpenGraphEvent.REQUEST_RESULT, onUserGameRequestDeleteResult );
                    AIRFacebook.deleteGameRequest( request.id );
                }
            }
        }

        private function onRequestTypeChanged():void {
            mObjectIDInput.isEnabled = mRequestTypeDropdown.selectedItem.text != "TURN";
        }

        /**
         *
         *
         * Result handlers
         *
         *
         */

        private function onRequestResult( event:AIRFacebookGameRequestEvent ):void {
            AIRFacebook.removeEventListener( AIRFacebookGameRequestEvent.REQUEST_RESULT, onRequestResult );
            if( event.errorMessage ) {
                Logger.log( "Game Request error: " + event.errorMessage );
            } else if( event.wasCancelled ) {
                Logger.log( "Game Request cancelled" );
            } else {
                Logger.log( "Game Request success, request ID: " + event.requestID + " and recipients: " + event.recipients );
            }
        }

        private function onUserGameRequestsResult( event:AIRFacebookUserGameRequestsEvent ):void {
            AIRFacebook.removeEventListener( AIRFacebookUserGameRequestsEvent.REQUEST_RESULT, onUserGameRequestsResult );
            if( event.errorMessage ) {
                Logger.log( "User game requests error" + event.errorMessage );
                return;
            }
            Logger.log( "User Game Requests result " + event.gameRequests );
            mAppRequestsDropdown.dataProvider = new ListCollection( event.gameRequests );
        }

        private function onUserGameRequestDeleteResult( event:AIRFacebookOpenGraphEvent ):void {
            AIRFacebook.removeEventListener( AIRFacebookOpenGraphEvent.REQUEST_RESULT, onUserGameRequestDeleteResult );
            if( event.errorMessage ) {
                Logger.log( "User game request DELETE error " + event.errorMessage );
                return;
            }

            Logger.log( "User game request DELETE success " + event.jsonResponse["success"] );

            AIRFacebook.addEventListener( AIRFacebookUserGameRequestsEvent.REQUEST_RESULT, onUserGameRequestsResult );
            AIRFacebook.requestUserGameRequests( new <String>[
                "action_type",
                "application",
                "created_time",
                "data",
                "from",
                "id",
                "message",
                "object",
                "to"
            ] );
        }

    }

}
