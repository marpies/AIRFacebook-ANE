# AIRFacebook | Facebook extension for Adobe AIR (iOS & Android)

AIRFacebook offers a rich and cross-platform API to Facebook SDK for iOS and Android. Easily implement social interaction in your Adobe AIR app and make it available to the millions of people using Facebook today!

## Features

* User authentication and permission management
* Content sharing (links, photos) to Facebook feed or via Messenger
* Sharing custom Open Graph stories
* Sending Game Requests
* Open Graph queries
* Scores & achievements for games

## Native SDK versions

* iOS `v4.38.0`
* Android `v4.38.0`

## Getting started

Download the extension from the [releases page](../../releases/).

* com.marpies.ane.facebook.ane
  * Use this package when packaging apps for iOS and Android.
* com.marpies.ane.facebook-iOS-simulator.ane
  * Use this package when packaging apps for iOS simulator only.
* com.marpies.ane.facebook-no-iOS-frameworks.ane, iOS-frameworks.zip
  * Use this package if you are having trouble packaging your iOS app. You need to put the contents of `iOS-frameworks.zip` to `AIR_SDK/lib/aot/stub`.

When upgrading from AIRFacebook `v1.x`, see [Upgrade notes for AIRFacebook 2.0.0](https://marpies.com/2018/02/upgrade-notes-for-airfacebook-2-0-0).

Follow [this guide](https://marpies.com/2018/02/setup-adobe-air-facebook-v2) to learn how to create your Facebook app id and make the necessary adjustments to your app descriptor.

### iOS patch

Copy the `libclang_rt.ios` file from the [ios_patch](ios_patch/) directory to `AIR_SDK/lib/aot/lib`.

### Using the extension

For a quick overview of some of the API read the following guides:

* [Getting started with AIRFacebook API](https://marpies.com/2018/02/getting-started-airfacebook-api-v2/)
* [Using listener interfaces](https://marpies.com/2015/09/using-airfacebook-listener-interfaces/)
* [FAQ](https://marpies.com/2015/09/airfacebook-faq/)
* [ActionScript documentation](https://marpies.github.io/docs/airfacebook-ane/)

### Requirements

* iOS 8+
* Android 4.0.3+
* Adobe AIR 30+

## Build ANE

ANT build scripts are available in the [build](build/) directory. Edit [build.properties](build/build.properties) to correspond with your local setup.

### Older versions downloads (ZIP)

* [v1.5.0](https://marpies.com/files/AIRFacebook_1.5.0.zip)
* [v1.4.5](https://marpies.com/files/AIRFacebook_1.4.5.zip)
* [v1.3.5](https://marpies.com/files/AIRFacebook_1.3.5.zip)
* [v1.2.1](https://marpies.com/files/AIRFacebook_1.2.1.zip)

## Author

The ANE has been developed by [Marcel Piestansky](https://twitter.com/marpies) and is distributed under [Apache License, version 2.0](http://www.apache.org/licenses/LICENSE-2.0.html).