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

package com.marpies.ane.facebook.graph {

	import com.marpies.ane.facebook.listeners.IAIRFacebookOpenGraphListener;

	import flash.events.IEventDispatcher;

	/**
	 * Interface providing Facebook Open Graph APIs.
	 */
	public interface IAIRFacebookOpenGraph extends IEventDispatcher {

		/**
		 * Queries Open Graph with a GET request that allows reading Open Graph data.
		 * If successful, results are returned in raw and JSON format. Only certain
		 * graph requests can be expected to succeed if user is not logged in.
		 *
		 * @param path Open Graph path to query, e.g. <code>/me</code> or <code>/me/friends</code>.
		 * @param parameters Additional parameters to the query, e.g. <code>{ fields: "id,link,name" }</code>
		 * @param listener Object that will be notified about the Open Graph request result.
		 *
		 * @event openGraphRequestResult com.marpies.ane.facebook.events.AIRFacebookOpenGraphEvent Dispatched when
		 *        the result of the request is obtained.
		 *
		 * @see http://developers.facebook.com/docs/graph-api
		 */
		function sendGETRequest( path:String, parameters:Object = null, listener:IAIRFacebookOpenGraphListener = null ):void;

		/**
		 * Sends Open Graph POST request that allows creating and updating data on Open Graph.
		 * If successful, result JSON typically contains ID of the newly created/updated post.
		 * Your app must be granted <code>publish_actions</code> permission to succeed with this call.
		 *
		 * @param path Open Graph path where data will be created/updated, e.g. <code>/me/feed</code>.
		 * @param parameters Additional parameters to the POST request,
		 *                   e.g. <code>{ message: "Hello world from Seattle.", place: "110843418940484" }</code>.
		 * @param listener Object that will be notified about the Open Graph request result.
		 *
		 * @event openGraphRequestResult com.marpies.ane.facebook.events.AIRFacebookOpenGraphEvent Dispatched when
		 *        the result of the request is obtained.
		 *
		 * @see http://developers.facebook.com/docs/graph-api
		 */
		function sendPOSTRequest( path:String, parameters:Object = null, listener:IAIRFacebookOpenGraphListener = null ):void;

		/**
		 * Sends Open Graph DELETE request that allows deleting graph nodes.
		 * If successful, result JSON typically contains only confirmation of the operation.
		 * Your app must be granted <code>publish_actions</code> permission to succeed with this call.
		 *
		 * @param nodeID ID of Open Graph node, for example a post from user's feed.
		 * @param listener Object that will be notified about the Open Graph request result.
		 *
		 * @event openGraphRequestResult com.marpies.ane.facebook.events.AIRFacebookOpenGraphEvent Dispatched when
		 *        the result of the request is obtained.
		 *
		 * @see http://developers.facebook.com/docs/graph-api
		 */
		function sendDELETERequest( nodeID:String, listener:IAIRFacebookOpenGraphListener = null ):void;

		/**
		 * Posts achievement for logged in user. Your app must be in the Games category
		 * and the achievement must be enabled for your app before it can be completed by your users.
		 * Your app must be granted <code>publish_actions</code> permission to succeed with this call.
		 *
		 * @param achievementURL URL of HTML page that represents your achievement.
		 * @param listener Object that will be notified about the Open Graph request result.
		 *
		 * @event openGraphRequestResult com.marpies.ane.facebook.events.AIRFacebookOpenGraphEvent Dispatched when
		 *        the result of the request is obtained.
		 *
		 * @see http://developers.facebook.com/docs/games/achievements
		 */
		function postAchievement( achievementURL:String, listener:IAIRFacebookOpenGraphListener = null ):void;

		/**
		 * Posts score for logged in user. Your app must be in the Games category.
		 * Your app must be granted <code>publish_actions</code> permission to succeed with this call.
		 *
		 * @param score Score with value greater than zero.
		 * @param listener Object that will be notified about the Open Graph request result.
		 *
		 * @event openGraphRequestResult com.marpies.ane.facebook.events.AIRFacebookOpenGraphEvent Dispatched when
		 *        the result of the request is obtained.
		 *
		 * @see http://developers.facebook.com/docs/games/scores
		 */
		function postScore( score:int, listener:IAIRFacebookOpenGraphListener = null ):void;

		/**
		 * Requests score for logged in user and if your app was granted <code>user_friends</code>
		 * permission then the result JSON also contains score for every user's friend
		 * who has authorized your app. Result JSON typically contains <code>data</code> object
		 * of type <code>Array</code> that contains users ordered by score from highest to lowest.
		 *
		 * @event openGraphRequestResult com.marpies.ane.facebook.events.AIRFacebookOpenGraphEvent Dispatched when
		 *        the result of the request is obtained.
		 * @param listener Object that will be notified about the Open Graph request result.
		 *
		 * @see http://developers.facebook.com/docs/games/scores
		 */
		function requestScores( listener:IAIRFacebookOpenGraphListener = null ):void;

	}

}
