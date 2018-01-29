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

package com.marpies.ane.facebook {

    import com.marpies.ane.facebook.data.BasicUserProfile;
    import com.marpies.ane.facebook.data.ExtendedUserProfile;
    import com.marpies.ane.facebook.games.IAIRFacebookGameRequests;
    import com.marpies.ane.facebook.graph.IAIRFacebookOpenGraph;
    import com.marpies.ane.facebook.listeners.IAIRFacebookBasicUserProfileListener;
    import com.marpies.ane.facebook.listeners.IAIRFacebookCachedAccessTokenListener;
    import com.marpies.ane.facebook.listeners.IAIRFacebookDeferredAppLinkListener;
    import com.marpies.ane.facebook.listeners.IAIRFacebookExtendedUserProfileListener;
    import com.marpies.ane.facebook.listeners.IAIRFacebookLoginListener;
    import com.marpies.ane.facebook.listeners.IAIRFacebookLogoutListener;
    import com.marpies.ane.facebook.listeners.IAIRFacebookSDKInitListener;
    import com.marpies.ane.facebook.listeners.IAIRFacebookUserFriendsListener;
    import com.marpies.ane.facebook.listeners.IAIRFacebookUserProfilePictureListener;
    import com.marpies.ane.facebook.share.IAIRFacebookShare;

    import flash.events.IEventDispatcher;

    /**
     * Interface providing Facebook SDK APIs.
     */
    public interface IAIRFacebook extends IEventDispatcher {

        /**
         * Initializes extension context and native Facebook SDK.
         *
         * @param applicationId Facebook application id.
         * @param cachedAccessTokenListener Object that will be notified whether cached access token was found or not.
         * @param basicUserProfileListener Object that will be notified when basic user profile is ready. This object will
         *                                 be notified only once, either shortly after initialization (i.e. if cached access
         *                                 token was found) or after the first successful login. If user logs out you can add
         *                                 the listener object again using <code>AIRFacebook.addBasicUserProfileListener</code>.
         * @param sdkInitListener Object that will be notified when native Facebook SDK is initialized.
         *
         * @return <code>true</code> if the extension context was created, <code>false</code> otherwise.
         *
         * @event sdkInit com.marpies.ane.facebook.events.AIRFacebookEvent Dispatched when the Facebook SDK is initialized,
         *        making the rest of the API safe to use. Considering the initialization may take slightly longer on Android
         *        in some rare cases, it is recommended to make this event's handler a starting point in using AIRFacebook's API.
         *        Listener for this event should be added before calling <code>AIRFacebook.init()</code>.
         * @event cachedAccessTokenResult com.marpies.ane.facebook.events.AIRFacebookCachedAccessTokenEvent Dispatched shortly
         *        after initialization with information whether cached access token was found or not.
         * @event profileReady com.marpies.ane.facebook.events.AIRFacebookBasicUserProfileEvent Dispatched only if a cached
         *        access token is found. Provides basic information about logged in user.
         *
         * @see #settings
         */
        function init( applicationId:String,
                       cachedAccessTokenListener:IAIRFacebookCachedAccessTokenListener = null,
                       basicUserProfileListener:IAIRFacebookBasicUserProfileListener = null,
                       sdkInitListener:IAIRFacebookSDKInitListener = null ):Boolean;

        /**
         * Adds object that will be notified when basic user profile is ready. This object is retained for as long
         * as the extension is active or until <code>AIRFacebook.removeBasicUserProfileListener()</code> is called.
         *
         * <p>Since the listener added using <code>AIRFacebook.init()</code> is only called once, this method is useful
         * for adding a listener again, for example after user logs out.</p>
         *
         * @param listener Object to be notified when basic user profile is ready.
         */
        function addBasicUserProfileListener( listener:IAIRFacebookBasicUserProfileListener ):void;

        /**
         * Removes object that was added earlier using <code>addBasicUserProfileListener</code>.
         * @param listener Object to remove.
         */
        function removeBasicUserProfileListener( listener:IAIRFacebookBasicUserProfileListener ):void;

        /**
         * Attempts to log out current user and clear cached access token.
         *
         * @param confirm Set to <code>true</code> to display native dialog asking user to confirm log out.
         * @param title Value for the title of the log out confirmation dialog.
         * @param message Value for the message of the log out confirmation dialog.
         * @param confirmLabel Label for the confirm button.
         * @param cancelLabel Label for the cancel button.
         * @param listener Object that will be notified about the logout result.
         *
         * @event logoutResult com.marpies.ane.facebook.events.AIRFacebookLogoutEvent Dispatched when the result of the
         *        logout process is obtained.
         */
        function logout( confirm:Boolean = false,
                         title:String = "Log out from Facebook?",
                         message:String = "You will not be able to connect with friends!",
                         confirmLabel:String = "Log out",
                         cancelLabel:String = "Cancel",
                         listener:IAIRFacebookLogoutListener = null ):void;

        /**
         * Requests user's profile picture and optionally loads the picture. Basic user's profile
         * must be ready in order to succeed with this call.
         *
         * @param width  The desired width for the profile picture, must be greater than 0.
         * @param height The desired height for the profile picture, must be greater than 0.
         * @param autoLoad Set to <code>true</code> if you want the picture to be loaded.
         * @param listener Object that will be notified about the auto-loaded profile picture.
         *
         * @return The URI of the profile picture, or <code>null</code> if user's profile is not ready to be accessed.
         *
         * @event profilePictureLoadResult com.marpies.ane.facebook.events.AIRFacebookUserProfilePictureEvent Dispatched
         *        if <code>autoLoad</code> is set to <code>true</code>.
         *
         * @see #isBasicUserProfileReady
         */
        function requestUserProfilePicture( width:int, height:int, autoLoad:Boolean = false, listener:IAIRFacebookUserProfilePictureListener = null ):String;

        /**
         * Requests extended user profile that may contain additional user properties
         * depending on the permissions that were granted to your app.
         * If forcing the refresh or the request has not been made earlier then listen
         * to <code>AIRFacebookExtendedUserProfileEvent.PROFILE_LOADED</code> to get the result of this request.
         *
         * <p>If asynchronous request is not necessary then a cached value is returned.</p>
         *
         * @param fields Set of fields to pass to the request, e.g. <code>name</code> or <code>link</code>.
         *               These fields represent the user's properties which will be available to read,
         *               provided your app has necessary permissions to obtain them.
         * @param forceRefresh Set to <code>true</code> if you want to refresh user data, for example
         *                     after your app was granted new permission.
         * @param listener Object that will be notified (if cached value is not used) about the request result.
         * @return Cached <code>ExtendedUserProfile</code> from earlier request,
         *         or <code>null</code> if cache does not exist or refresh is enforced.
         *
         * @event profileLoaded com.marpies.ane.facebook.events.AIRFacebookExtendedUserProfileEvent Dispatched
         *        if cached value is not used.
         */
        function requestExtendedUserProfile( fields:Vector.<String> = null, forceRefresh:Boolean = false, listener:IAIRFacebookExtendedUserProfileListener = null ):ExtendedUserProfile;

        /**
         * Requests user friends. Only those friends who have also installed your app are contained in the result.
         *
         * @param fields Set of fields to pass to the request, e.g. <code>name</code> or <code>link</code>.
         *               These fields represent the friends' properties which will be available to read,
         *               provided your app has necessary permissions to obtain them.
         * @param listener Object that will be notified about the request result.
         *
         * @event userFriendsRequestResult com.marpies.ane.facebook.events.AIRFacebookUserFriendsEvent Dispatched when the result
         *        of the request is obtained.
         */
        function requestUserFriends( fields:Vector.<String> = null, listener:IAIRFacebookUserFriendsListener = null ):void;

        /**
         * Allows checking if a particular permission is granted.
         *
         * @param permission Permission to check for.
         *
         * @return <code>true</code> if permission is granted, <code>false</code> otherwise.
         */
        function isPermissionGranted( permission:String ):Boolean;

        /**
         * If user is not logged in then initiates user login with read permissions
         * otherwise requests read permissions which have not been granted yet.
         *
         * @param permissions List of read permissions to request.
         * @param listener Object that will be notified about the login result.
         *
         * @event loginResult com.marpies.ane.facebook.events.AIRFacebookLoginEvent Dispatched when the result
         *        of the login process is obtained.
         */
        function loginWithReadPermissions( permissions:Vector.<String> = null, listener:IAIRFacebookLoginListener = null ):void;

        /**
         * If user is not logged in then initiates user login with publish permissions
         * otherwise requests publish permissions which have not been granted yet.
         *
         * @param permissions List of publish permissions to request.
         * @param listener Object that will be notified about the login result.
         *
         * @event loginResult com.marpies.ane.facebook.events.AIRFacebookLoginEvent Dispatched when the result
         *        of the login process is obtained.
         */
        function loginWithPublishPermissions( permissions:Vector.<String> = null, listener:IAIRFacebookLoginListener = null ):void;

        /**
         * Logs an application event for Facebook analytics.
         *
         * <p>Example logging of a purchase:</p>
         * <listing version="3.0">
         * const params:Object = {};
         * params[AIRFacebookAppEvent.EVENT_PARAM_CURRENCY] = "USD";
         * params[AIRFacebookAppEvent.EVENT_PARAM_CONTENT_TYPE] = "shoes";
         * params[AIRFacebookAppEvent.EVENT_PARAM_CONTENT_ID] = "HDFU-8452";
         * AIRFacebook.logEvent( AIRFacebookAppEvent.EVENT_NAME_PURCHASED, params, 23.50 );
         * </listing>
         *
         * @param eventName  Event name used to denote the event. Choose amongst the <code>EVENT_NAME</code>
         *                   constants in <code>AIRFacebookAppEvent</code> when possible, or create your own.
         *                   Event names should be 40 characters or less, alphanumeric, and can include spaces,
         *                   underscores or hyphens, but must not have a space or hyphen as the first character.
         * @param parameters Key-value object specifying parameters to log with the event. Insights will allow
         *                   looking at the logs of these events via different parameter values. You can log on
         *                   the order of 10 parameters with each distinct <code>eventName</code>. It is advisable
         *                   to limit the number of unique values provided for each parameter in the thousands.
         *                   As an example, do not attempt to provide a unique parameter value for each unique
         *                   user in your app. You will not get meaningful aggregate reporting on so many parameter
         *                   values. Parameter values in the object must be of type <code>String</code>.
         * @param valueToSum Value to associate with the event which will be summed up in Insights for
         *                   across all instances of the event, so that average values can be determined, etc.
         *
         * @see com.marpies.ane.facebook.events.AIRFacebookAppEvent
         * @see http://developers.facebook.com/docs/app-events
         */
        function logEvent( eventName:String, parameters:Object = null, valueToSum:Number = 0.0 ):void;

        /**
         * Fetches deferred app link data.
         * @param listener Object that will be notified about the request result.
         *
         * @event deferredAppLinkRequestResult com.marpies.ane.facebook.events.AIRFacebookDeferredAppLinkEvent Dispatched
         *        when the result of the request is obtained.
         */
        function fetchDeferredAppLink( listener:IAIRFacebookDeferredAppLinkListener = null ):void;

        /**
         * Disposes native extension context.
         */
        function dispose():void;

        /**
         * Returns object that provides Facebook Open Graph API.
         */
        function get openGraph():IAIRFacebookOpenGraph;

        /**
         * Returns object that provides Facebook Game Requests API.
         */
        function get gameRequests():IAIRFacebookGameRequests;

        /**
         * Returns object that provides Facebook sharing API.
         */
        function get share():IAIRFacebookShare;

        /**
         * Returns Facebook and extension settings.
         * Changes only take effect when set before calling <code>AIRFacebook.instance.init()</code>.
         *
         * @see #init()
         */
        function get settings():AIRFacebookSettings;

        /**
         * Returns the Facebook app id.
         */
        function get applicationId():String;

		/**
         * Returns <code>true</code> if the Facebook SDK is supported on current platform.
         */
        function get isSupported():Boolean;

		/**
         * Returns <code>true</code> if the Facebook SDK has been successfully initialized.
         */
        function get isInitialized():Boolean;

        /**
         * Returns <code>true</code> if the user is logged in and her basic profile is ready to be accessed.
         * This property still may be <code>false</code> when accessed inside of a login handler. Listen to
         * <code>AIRFacebookBasicUserProfileEvent.PROFILE_READY</code> or add listener object using
         * <code>AIRFacebook.addBasicUserProfileListener</code> to be notified when the user's profile is ready
         * to be accessed.
         *
         * @see #basicUserProfile
         */
        function get isBasicUserProfileReady():Boolean;

        /**
         * Returns basic user profile. This property still may return <code>null</code> when accessed
         * inside of a login handler. Listen to <code>AIRFacebookBasicUserProfileEvent.PROFILE_READY</code>
         * or add listener object using <code>AIRFacebook.addBasicUserProfileListener</code> to be notified
         * when the user's profile is ready to be accessed.
         *
         * @see #isBasicUserProfileReady
         */
        function get basicUserProfile():BasicUserProfile;

        /**
         * Returns <code>true</code> if user successfully went through Facebook login process or a valid
         * access token was loaded during initialization, <code>false</code> otherwise. This property
         * may return <code>false</code> shortly after a call to <code>AIRFacebook.init()</code> method even if a cached
         * access token may exist. To find out if user's token was loaded after initialization listen to
         * <code>AIRFacebookCachedAccessTokenEvent.RESULT</code> or specify a listener object when calling
         * <code>AIRFacebook.init()</code> method.
         *
         * <p>Note: user's profile may not be ready to access even when this property returns <code>true</code>,
         * especially when trying to access user's profile inside of a login handler.
         * To find out if you can access user's profile use <code>isBasicUserProfileReady</code> instead.</p>
         */
        function get isUserLoggedIn():Boolean;

        /**
         * Returns access token granted for the logged in user or <code>null</code> if no user is logged in.
         */
        function get accessToken():String;

        /**
         * Returns expiration timestamp (in milliseconds) of the current
         * access token or 0 if there is no access token.
         */
        function get accessTokenExpirationTimestamp():Number;

        /**
         * Returns <code>true</code> if the current access token is expired or does not exist,
         * <code>false</code> otherwise.
         */
        function get isAccessTokenExpired():Boolean;

        /**
         * Returns a list of granted permissions.
         */
        function get grantedPermissions():Vector.<String>;

        /**
         * Returns a list of permissions which were denied by the user during the login process.
         */
        function get deniedPermissions():Vector.<String>;

        /**
         * Returns version of the native Facebook SDK.
         */
        function get sdkVersion():String;

    }

}
