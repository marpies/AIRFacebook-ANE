/*
 * Copyright (c) 2018 Marcel Piestansky
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 * http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */

package com.marpies.ane.facebook;

import android.app.Activity;
import android.content.Intent;
import android.net.Uri;
import android.os.Bundle;
import android.os.Handler;
import com.facebook.CallbackManager;
import com.facebook.FacebookCallback;
import com.facebook.FacebookException;
import com.facebook.internal.FacebookDialogBase;
import com.facebook.share.Sharer;
import com.facebook.share.model.*;
import com.facebook.share.widget.AppInviteDialog;
import com.facebook.share.widget.GameRequestDialog;
import com.facebook.share.widget.MessageDialog;
import com.facebook.share.widget.ShareDialog;
import com.marpies.ane.facebook.data.AIRFacebookEvent;
import com.marpies.ane.facebook.data.AIRFacebookShareType;
import com.marpies.ane.facebook.data.AIRFacebookSharedBitmap;
import com.marpies.ane.facebook.utils.*;

import java.util.ArrayList;
import java.util.List;

public class ShareActivity extends Activity {

	public static String extraPrefix = "com.marpies.ane.facebook.ShareActivity";
	private static AIRFacebookShareType mShareType;
	private static AIRFacebookShareType mShareCallbackType;

	private CallbackManager mCallbackManager;

	private int mListenerID;

	@Override
	protected void onCreate( Bundle savedInstanceState ) {
		super.onCreate( savedInstanceState );

		/* Callback manager */
		mCallbackManager = CallbackManager.Factory.create();

		mShareCallbackType = AIRFacebookShareType.NONE;

		Bundle extras = getIntent().getExtras();
		mListenerID = extras.getInt( extraPrefix + ".listenerID", -1 );
		/* Check the share type */
		mShareType = AIRFacebookShareType.valueOf( extras.getString( extraPrefix + ".type" ) );
		switch( mShareType ) {
			case LINK:
			case MESSAGE_LINK:
				shareLink( extras );
				return;
			case PHOTO:
			case MESSAGE_PHOTO:
				sharePhoto( extras );
				return;
			case OPEN_GRAPH_STORY:
				shareOpenGraphStory( extras );
				return;
			case APP_INVITE:
				showAppInviteDialog( extras );
				return;
			case GAME_REQUEST:
				showGameRequestDialog( extras );
				return;
			default:
				AIR.log( "[ShareActivity] - Unknown share type " + mShareType.toString() );
		}
	}

	/**
	 *
	 *
	 * Private API
	 *
	 *
	 */

	private void shareLink( Bundle extras ) {
		ShareLinkContent content = ShareLinkContentBuilder.getContentForParameters( extras );
		AIR.log( "[ShareActivity] sharing link content." );
		shareContentWithNativeUI( content, mShareType == AIRFacebookShareType.MESSAGE_LINK );
	}

	private void sharePhoto( final Bundle extras ) {
		SharePhotoContentBuilder.createContentForParameters( extras, new SharePhotoContentBuilderCallback() {
			@Override
			public void onPhotoContentBuilderSucceeded( SharePhotoContent content ) {
				AIR.log( "[ShareActivity] sharing photo with UI - success" );
				shareContentWithNativeUI( content, mShareType == AIRFacebookShareType.MESSAGE_PHOTO );
			}

			@Override
			public void onPhotoContentBuilderFailed( String errorMessage ) {
				AIR.log( "[ShareActivity] sharing photo with UI - error " + errorMessage );
				AIR.dispatchEvent( AIRFacebookEvent.SHARE_ERROR, StringUtils.getEventErrorJSON( mListenerID, errorMessage ) );
				onShareFinish();
			}
		} );
	}

	private void shareOpenGraphStory( Bundle extras ) {
		String objectType = extras.getString( extraPrefix + ".objectType" );
		/* Create an object */
		ShareOpenGraphObject.Builder object = new ShareOpenGraphObject.Builder()
				.putString( "og:type", objectType )
				.putString( "og:title", extras.getString( extraPrefix + ".title" ) );
		/* Add extra object properties, if any */
		if( extras.containsKey( extraPrefix + ".objectProperties" ) ) {
			Bundle properties = extras.getBundle( extraPrefix + ".objectProperties" );
			for( String key : properties.keySet() ) {
				object.putString( key, properties.getString( key ) );
			}
		}
		/* Add image, if specified */
		if( AIRFacebookSharedBitmap.DATA != null ) {
			object.putPhoto( "og:image", new SharePhoto.Builder().setBitmap( AIRFacebookSharedBitmap.DATA ).build() );
		} else if( extras.containsKey( extraPrefix + ".imageURL" ) ) {
			object.putPhoto( "og:image", new SharePhoto.Builder().setImageUrl( Uri.parse( extras.getString( extraPrefix + ".imageURL" ) ) ).build() );
		}

		/* Create an action */
		ShareOpenGraphAction.Builder action = new ShareOpenGraphAction.Builder()
				.setActionType( extras.getString( extraPrefix + ".actionType" ) )
//				.putBoolean( "fb:explicitly_shared", true )	// todo explicitly_shared or is this by default?
				.putObject( objectType, object.build() );

		/* Create the content */
		ShareOpenGraphContent content = new ShareOpenGraphContent.Builder()
				.setPreviewPropertyName( objectType )
				.setAction( action.build() )
				.build();

		AIR.log( "[ShareActivity] sharing Open Graph story." );

		shareContentWithNativeUI( content, false );
	}

	private void shareContentWithNativeUI( ShareContent content, Boolean useMessenger ) {
		FacebookDialogBase<ShareContent, Sharer.Result> dialogBase;
		if( useMessenger ) {
			dialogBase = new MessageDialog( this );
		} else {
			dialogBase = new ShareDialog( this );
		}
		dialogBase.registerCallback( mCallbackManager, getShareCallback() );
		dialogBase.show( content );
	}

	private void showAppInviteDialog( Bundle extras ) {
		AppInviteContent.Builder content = new AppInviteContent.Builder()
				.setApplinkUrl( extras.getString( extraPrefix + ".appLinkURL" ) );
		if( extras.containsKey( extraPrefix + ".imageURL" ) ) {
			content.setPreviewImageUrl( extras.getString( extraPrefix + ".imageURL" ) );
		}

		AIR.log( "[ShareActivity] showing AppInvite dialog." );

		AppInviteDialog dialog = new AppInviteDialog( this );
		dialog.registerCallback( mCallbackManager, getAppInviteCallback() );
		dialog.show( content.build() );
	}

	private void showGameRequestDialog( Bundle extras ) {
		GameRequestContent.Builder content = new GameRequestContent.Builder()
				.setMessage( extras.getString( extraPrefix + ".message" ) );
		if( extras.containsKey( extraPrefix + ".actionType" ) ) {
			GameRequestContent.ActionType actionType = GameRequestContent.ActionType.valueOf( extras.getString( extraPrefix + ".actionType" ) );
			content.setActionType( actionType );
		}
		if( extras.containsKey( extraPrefix + ".title" ) ) {
			content.setTitle( extras.getString( extraPrefix + ".title" ) );
		}
		if( extras.containsKey( extraPrefix + ".objectID" ) ) {
			content.setObjectId( extras.getString( extraPrefix + ".objectID" ) );
		}
		if( extras.containsKey( extraPrefix + ".friendsFilter" ) ) {
			GameRequestContent.Filters filter = GameRequestContent.Filters.valueOf( extras.getString( extraPrefix + ".friendsFilter" ) );
			AIR.log( "Setting friends filter to " + filter.toString() );
			content.setFilters( filter );
		}
		if( extras.containsKey( extraPrefix + ".data" ) ) {
			content.setData( extras.getString( extraPrefix + ".data" ) );
		}
		if( extras.containsKey( extraPrefix + ".suggestedFriends" ) ) {
			content.setSuggestions( extras.getStringArrayList( extraPrefix + ".suggestedFriends" ) );
		}
		if( extras.containsKey( extraPrefix + ".recipients" ) ) {
			content.setRecipients( extras.getStringArrayList( extraPrefix + ".recipients" ) );
		}

		AIR.log( "[ShareActivity] showing GameRequest dialog." );

		GameRequestDialog dialog = new GameRequestDialog( this );
		dialog.registerCallback( mCallbackManager, getGameRequestCallback() );
		dialog.show( content.build() );
	}

	/**
	 *
	 *
	 * Callbacks
	 *
	 *
	 */

	/**
	 * Content Share callbacks
	 */

	private void onShareSucceeded( Sharer.Result shareResult ) {
		mShareCallbackType = AIRFacebookShareType.LINK; // Just one of possible values, does not matter
		AIR.log( "[ShareActivity] share callback - success, post ID: " + shareResult.getPostId() );
		String postID = shareResult.getPostId();
		/* When shared using Messenger, post ID is null and would result in crash
		 * therefore the post ID value must be checked when passing to dispatch event call */
		AIR.dispatchEvent(
				AIRFacebookEvent.SHARE_SUCCESS,
				(postID == null) ?
				StringUtils.getListenerJSONString( mListenerID ) :
				StringUtils.getSingleValueJSONString( mListenerID, "postID", postID )
		);

		onShareFinish();
	}

	private void onShareCancelled() {
		mShareCallbackType = AIRFacebookShareType.LINK; // Just one of possible values, does not matter
		AIR.log( "[ShareActivity] share callback - cancelled" );
		AIR.dispatchEvent( AIRFacebookEvent.SHARE_CANCEL, StringUtils.getListenerJSONString( mListenerID ) );

		onShareFinish();
	}

	private void onShareError( FacebookException error ) {
		mShareCallbackType = AIRFacebookShareType.LINK; // Just one of possible values, does not matter
		AIR.log( "[ShareActivity] share callback - error: " + error.getMessage() );
		AIR.dispatchEvent( AIRFacebookEvent.SHARE_ERROR, StringUtils.getEventErrorJSON( mListenerID, error.getMessage() ) );

		onShareFinish();
	}

	/**
	 * App Invite callbacks
	 */

	private void onAppInviteSucceeded( AppInviteDialog.Result inviteResult ) {
		mShareCallbackType = AIRFacebookShareType.APP_INVITE;
		AIR.log( "[ShareActivity] app invite callback - success" );
		AIR.dispatchEvent( AIRFacebookEvent.SHARE_SUCCESS, StringUtils.getSingleValueJSONString( mListenerID, "appInvite", "true" ) );

		// inviteResult.getData() contains only 'didComplete' Boolean

		onShareFinish();
	}

	private void onAppInviteCancelled() {
		mShareCallbackType = AIRFacebookShareType.APP_INVITE;
		AIR.log( "[ShareActivity] app invite callback - cancelled" );
		dispatchAppInviteCancel();
	}

	private void onAppInviteError( FacebookException error ) {
		mShareCallbackType = AIRFacebookShareType.APP_INVITE;
		AIR.log( "[ShareActivity] app invite callback - error: " + error.getMessage() );
		AIR.dispatchEvent( AIRFacebookEvent.SHARE_ERROR, String.format(
				StringUtils.locale,
				"{ \"listenerID\": %d, \"errorMessage\": \"%s\", \"appInvite\": \"true\" }",
				mListenerID,
				StringUtils.removeLineBreaks( error.getMessage() )
		) );

		onShareFinish();
	}

	private void dispatchAppInviteCancel() {
		AIR.dispatchEvent( AIRFacebookEvent.SHARE_CANCEL, StringUtils.getSingleValueJSONString( mListenerID, "appInvite", "true" ) );
		onShareFinish();
	}

	/**
	 * Game Request callbacks
	 */

	private void onGameRequestSucceeded( GameRequestDialog.Result gameRequestResult ) {
		mShareCallbackType = AIRFacebookShareType.GAME_REQUEST;
		AIR.log( "[ShareActivity] game request callback - success" );
		AIR.dispatchEvent(
				AIRFacebookEvent.GAME_REQUEST_SUCCESS,
				String.format(
						StringUtils.locale,
						"{ \"request_id\": \"%s\", \"recipients\": %s, \"listenerID\": %d }",
						gameRequestResult.getRequestId(),
						gameRequestResult.getRequestRecipients().toString(),
						mListenerID
				)
		);

		onShareFinish();
	}

	private void onGameRequestCancelled() {
		mShareCallbackType = AIRFacebookShareType.GAME_REQUEST;
		AIR.log( "[ShareActivity] game request callback - cancelled" );
		AIR.dispatchEvent( AIRFacebookEvent.GAME_REQUEST_CANCEL, StringUtils.getListenerJSONString( mListenerID ) );

		onShareFinish();
	}

	private void onGameRequestError( FacebookException error ) {
		mShareCallbackType = AIRFacebookShareType.GAME_REQUEST;
		AIR.log( "[ShareActivity] game request callback - error: " + error.getMessage() );
		AIR.dispatchEvent( AIRFacebookEvent.GAME_REQUEST_ERROR, StringUtils.getEventErrorJSON( mListenerID, error.getMessage() ) );

		onShareFinish();
	}

	private void onShareFinish() {
		/* Clear shared bitmap if there is one */
		if( AIRFacebookSharedBitmap.DATA != null ) {
			AIRFacebookSharedBitmap.DATA.recycle();
			AIRFacebookSharedBitmap.DATA = null;
		}
		finish();
	}

	/**
	 *
	 *
	 * Overridden Activity API
	 *
	 *
	 */

	@Override
	public void onBackPressed() {
		onShareFinish();
	}

	@Override
	protected void onActivityResult( int requestCode, int resultCode, Intent data ) {
		super.onActivityResult( requestCode, resultCode, data );
		mCallbackManager.onActivityResult( requestCode, resultCode, data );

		new Handler().postDelayed( new Runnable() {
			@Override
			public void run() {
				/* If mShareCallbackType is NONE then it means the callback was not called */
				if( mShareCallbackType == AIRFacebookShareType.NONE && mShareType == AIRFacebookShareType.APP_INVITE ) {
					dispatchAppInviteCancel();
				}
			}
		}, 50 );
	}

	/**
	 *
	 *
	 * Callbacks getters
	 *
	 *
	 */

	private FacebookCallback<Sharer.Result> getShareCallback() {
		return new FacebookCallback<Sharer.Result>() {
			@Override
			public void onSuccess( Sharer.Result result ) {
				onShareSucceeded( result );
			}

			@Override
			public void onCancel() {
				onShareCancelled();
			}

			@Override
			public void onError( FacebookException error ) {
				onShareError( error );
			}
		};
	}

	private FacebookCallback<GameRequestDialog.Result> getGameRequestCallback() {
		return new FacebookCallback<GameRequestDialog.Result>() {
			@Override
			public void onSuccess( GameRequestDialog.Result result ) {
				onGameRequestSucceeded( result );
			}

			@Override
			public void onCancel() {
				onGameRequestCancelled();
			}

			@Override
			public void onError( FacebookException error ) {
				onGameRequestError( error );
			}
		};
	}

	private FacebookCallback<AppInviteDialog.Result> getAppInviteCallback() {
		return new FacebookCallback<AppInviteDialog.Result>() {
			@Override
			public void onSuccess( AppInviteDialog.Result result ) {
				onAppInviteSucceeded( result );
			}

			@Override
			public void onCancel() {
				onAppInviteCancelled();
			}

			@Override
			public void onError( FacebookException error ) {
				onAppInviteError( error );
			}
		};
	}

}