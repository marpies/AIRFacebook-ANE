# AIRFacebook | Facebook extension for Adobe AIR (iOS & Android)

AIRFacebook offers a rich and cross-platform API to the latest Facebook SDK for iOS and Android.

This is a demo application highlighting the core features of the extension. This repository also includes test version of the ANE (inside assets folder) that you are free to use during your development. In order to publish an application that uses this ANE you need to [obtain a license](https://gumroad.com/l/airFB).

### Key features

* User authentication and permission management
* Content sharing (links, photos) to Facebook feed or via Messenger
* Sharing custom Open Graph stories
* Sending Game Requests and receiving events from notifications
* Sending App invitations
* Open Graph queries
* Scores & achievements for games

### Requirements

* iOS 7+
* Android 2.3.3+ (ANE v1.2.x), Android 4.0.3+ (ANE v1.3.x)
* Adobe AIR 18+

### Change log

#### July 12, 2016

* UPDATED Facebook SDK for Android to version 4.13.2

See [full change log](http://nativeextensions.marpies.com/facebook/changelog.txt) for previous updates.

### Using the ANE

For instructions on how to set up your app with the ANE and code snippets on using some of the API read the following guides:
* [Setting up with AIR app](http://marpies.com/2015/09/setup-adobe-air-with-facebook/)
* [Getting started with ANE's API](http://marpies.com/2015/09/getting-started-with-airfacebook-api/)
* [Using listener interfaces](http://marpies.com/2015/09/using-airfacebook-listener-interfaces/)
* [FAQ](http://marpies.com/2015/09/airfacebook-faq/)

### Running the demo application

After going through the guide [Setting up with AIR app](http://marpies.com/2015/09/setup-adobe-air-with-facebook/), enter your Facebook app ID in the [LoginScreen](src/com/marpies/demo/facebook/screens/LoginScreen.as#L61) class. Add [Starling](http://gamua.com/starling/) and [Feathers](http://feathersui.com) libraries to your project, set [Startup class](https://github.com/marpies/AIRFacebook-ANE/blob/master/src/Startup.as) as your main/document class, compile and run as usually.

### API reference

* [ActionScript docs](http://nativeextensions.marpies.com/facebook/docs/)

### Author

Demo application and ANE has been written by [Marcel Piestansky](http://marpies.com).

### License

You are given permission to use the ANE in agreement with the following license and copyright terms.
Read the [EULA](LICENSE.txt) before downloading and using this software.

### Credits

Demo application uses the following libraries:
* [Starling Framework by Daniel Sperl](https://twitter.com/PrimaryFeather)
* [Feathers UI by Josh Tynjala](https://twitter.com/joshtynjala)
