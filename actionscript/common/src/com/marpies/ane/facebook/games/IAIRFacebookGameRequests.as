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

package com.marpies.ane.facebook.games {

	import com.marpies.ane.facebook.listeners.IAIRFacebookGameRequestInvokeListener;
	import com.marpies.ane.facebook.listeners.IAIRFacebookGameRequestListener;
	import com.marpies.ane.facebook.listeners.IAIRFacebookOpenGraphListener;
	import com.marpies.ane.facebook.listeners.IAIRFacebookUserGameRequestsListener;

	import flash.events.IEventDispatcher;

	/**
	 * Interface providing Facebook Game Requests APIs.
	 */
	public interface IAIRFacebookGameRequests extends IEventDispatcher {

		/**
		 * Opens up web dialog to send the specified game request.
		 *
		 * @param message Message that users receiving the request will see; maximum 60 characters.
		 * @param actionType Used when defining additional context about the nature of the request. Use either
		 *                   a value from <code>AIRFacebookGameRequestActionType</code> class or <code>null</code>
		 *                   which means value of <code>AIRFacebookGameRequestActionType.NONE</code> will be used.
		 * @param title Optional title for the dialog; maximum 50 characters.
		 * @param objectID Open Graph ID of an object that is being sent or asked for.
		 *                 Only valid (and required) for request types <code>AIRFacebookGameRequestActionType.SEND</code>
		 *                 and <code>AIRFacebookGameRequestActionType.ASK_FOR</code>.
		 * @param friendsFilter Controls the set of friends user sees in the multi-friend selector dialog.
		 *                      Use <code>AIRFacebookGameRequestFilter.APP_USERS</code> to only display friends who are
		 *                      existing users of your app, or <code>AIRFacebookGameRequestFilter.APP_NON_USERS</code> to
		 *                      only display friends who have previously not authenticated your app.
		 *                      If <code>null</code>, the multi-friend selector will display all of the user's friends.
		 * @param data Optional data which can be used for tracking; maximum 255 characters.
		 * @param suggestedFriends An array of user IDs that will be included in the dialog as the first suggested friends.
		 *                         Cannot be used together with <code>friendsFilter</code>.
		 * @param recipients List of user IDs, usernames or invite tokens of people to send the request to. If this is
		 *                   not specified, a friend selector will be displayed and the user can select up to 50 friends.
		 * @param listener Object that will be notified about the request result.
		 *
		 * @event gameRequestRequestResult com.marpies.ane.facebook.events.AIRFacebookGameRequestEvent Dispatched when
		 *        the result of the request is obtained.
		 *
		 * @see #canShowDialog
		 * @see com.marpies.ane.facebook.data.AIRFacebookGameRequestActionType
		 * @see com.marpies.ane.facebook.data.AIRFacebookGameRequestFilter
		 * @see http://developers.facebook.com/docs/games/requests
		 * @see http://developers.facebook.com/tools/object-browser
		 */
		function showDialog( message:String,
										actionType:String = null,
										title:String = null,
										objectID:String = null,
										friendsFilter:String = null,
										data:String = null,
										suggestedFriends:Vector.<String> = null,
										recipients:Vector.<String> = null,
										listener:IAIRFacebookGameRequestListener = null ):void;

		/**
		 * Requests game requests which were sent to the logged in user.
		 *
		 * @param fields Set of fields to pass to the request. Supported values are <code>id</code>, <code>from</code>,
		 *               <code>to</code>, <code>message</code>, <code>action_type</code>, <code>application</code>,
		 *               <code>data</code>, <code>object</code>, <code>created_time</code>. If no fields are specified
		 *               then each app request in the result contains <code>id</code>, <code>from</code>, <code>to</code>,
		 *               <code>message</code>, <code>action_type</code>, <code>created_time</code> and <code>application</code>.
		 * @param listener Object that will be notified about the request result.
		 *
		 * @event userGameRequestsRequestResult com.marpies.ane.facebook.events.AIRFacebookUserGameRequestsEvent Dispatched when
		 *        the result of the request is obtained.
		 *
		 * @see #deleteGameRequest()
		 * @see http://developers.facebook.com/docs/games/requests
		 */
		function loadUserGameRequests( fields:Vector.<String> = null, listener:IAIRFacebookUserGameRequestsListener = null ):void;

		/**
		 * Deletes app request from the Facebook. The requests are never deleted automatically, it is a
		 * developer's responsibility to do so on user's behalf, typically after the user accepted the request.
		 *
		 * <p>Since this is simply an Open Graph DELETE request your app must be granted <code>publish_actions</code>
		 * permission to succeed with this call.</p>
		 *
		 * <p>If successful, result JSON typically contains only confirmation of the operation.</p>
		 *
		 * @param requestID ID of the app request to delete.
		 * @param listener Object that will be notified about the request result.
		 *
		 * @event openGraphRequestResult com.marpies.ane.facebook.events.AIRFacebookOpenGraphEvent Dispatched when
		 *        the result of the request is obtained.
		 *
		 * @see #requestUserGameRequests()
		 * @see http://developers.facebook.com/docs/games/requests
		 */
		function deleteGameRequest( requestID:String, listener:IAIRFacebookOpenGraphListener = null ):void;

		/**
		 * Adds object that will be notified when your application is invoked from a Game Request notification.
		 * This object is retained for as long as the extension is active or until
		 * <code>AIRFacebook.removeGameRequestInvokeListener()</code> is called.
		 *
		 * @param listener Object to be notified when your application is invoked from a Game Request notification.
		 *
		 * @see #removeGameRequestInvokeListener()
		 */
		function addGameRequestInvokeListener( listener:IAIRFacebookGameRequestInvokeListener ):void;

		/**
		 * Removes object that was added earlier using <code>addGameRequestInvokeListener</code>.
		 *
		 * @param listener Object to remove.
		 *
		 * @see #addGameRequestInvokeListener()
		 */
		function removeGameRequestInvokeListener( listener:IAIRFacebookGameRequestInvokeListener ):void;

		/**
		 * Call this to find out if a Game Request dialog can be presented on current device.
		 *
		 * @see #showDialog()
		 */
		function get canShowDialog():Boolean;

	}

}
