# Load Facebook user profile with Facebook SDK on iOS using Swift

This is a demo app and a helper function for loading Facebook user profile:

* Facebook user ID
* Access token
* Email
* First name
* Last name
* Name

Facebook user ID and access token can be used to authenticate Facebook user in your app.
The helper function can be useful for those who just need to load a Facebook user profile from code without using other SDK features. 

<img src="https://github.com/exchangegroup/load-facebook-profile-ios-swift/raw/master/graphics/load_facebook_profile_ios_swift.png" alt="Load Facebook user profile on iOS swift with Facebook SDK" width="320">

## To run this demo app

1. Open `Info.plist` file.

## Setup in your app

1. Add Facebook SDK to your app. Follow instructions on Facebook developer pages. See [Facebook iOS SDK](https://developers.facebook.com/docs/ios/getting-started)
1. Copy [TegFacebookUser.swift](https://raw.githubusercontent.com/exchangegroup/load-facebook-profile-ios-swift/master/LoadFacebookProfile/TegFacebookUser.swift) and [TegFacebookUserLoader.swift](https://raw.githubusercontent.com/exchangegroup/load-facebook-profile-ios-swift/master/LoadFacebookProfile/TegFacebookUserLoader.swift) into your project.

## Usage

```swift
let loader = TegFacebookUserLoader()
loader.load(askEmail: false) { user in
  // user profile is loaded
}
```

## Profile fields can be empty

Please note that user may deny sharing all or some of the profile information. There is no guarantee, for example, that your app will get email address.

## Verifying user ID on server side

In order to authenticate a user one needs to verify its `facebook user id` on server side. Send the following request from your server and compare the returned user id with the one loaded by `TegFacebookUserLoader.load` function.

```
https://graph.facebook.com/me?fields=id&access_token=YOUR_ACCCESS_TOKEN
```

## Repository home

https://github.com/exchangegroup/load-facebook-profile-ios-swift
