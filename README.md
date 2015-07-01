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
2. Update "Bundle identifier", "URL types", "FacebookAppID" and "FacebookDisplayName" with your facebook app information. See [Facebook iOS SDK](https://developers.facebook.com/docs/ios/getting-started) for more details.

<img src='https://raw.githubusercontent.com/exchangegroup/load-facebook-profile-ios-swift/master/graphics/facebook_demo_update_info_plist.png' width='616' alt='change plist'>

## Setup in your app

1. Add Facebook SDK to your app. Follow instructions on Facebook developer pages. See [Facebook iOS SDK](https://developers.facebook.com/docs/ios/getting-started)
2. Add [FacebookUserLoader.swift](https://github.com/exchangegroup/load-facebook-profile-ios-swift/blob/master/LoadFacebookProfileKit/FacebookUserLoader.swift) and [TegFacebookUser.swift](https://github.com/exchangegroup/load-facebook-profile-ios-swift/blob/master/LoadFacebookProfileKit/TegFacebookUser.swift) to your project.

#### Setup with Carthage

Alternatively, if you are using Carthage, you can add the following to your Cartfile and run `carthage update`

```
github "exchangegroup/load-facebook-profile-ios-swift" ~> 3.0
```

## Usage

```Swift
import LoadFacebookProfileKit

let loader = FacebookUserLoader() // Keep strong reference

...

loader.load(askEmail: true,
  onError: { },
  onSuccess: { user in
    // User has logged in with Facebook
  }
)
```

## Profile fields can be empty

Please note that user may deny sharing all or some of the profile information. There is no guarantee, for example, that your app will get email address.

## Verifying user ID on server side

In order to authenticate a user one needs to verify its `facebook user id` on server side. Send the following request from your server and compare the returned user id with the one loaded by `TegFacebookUserLoader.load` function.

```
https://graph.facebook.com/me?fields=id&access_token=YOUR_ACCCESS_TOKEN
```

## Unit tests

Sometimes it is useful to bypass the Facebook login in Facebook. Here is how to setup fake Facebook responses that will be used when calling `load` method of `FacebookUserLoader` object.

```Swift
// Call `onSuccess` with the supplied user without touching Facebook SDK.
FacebookUserLoader.simulateSuccessUser = TegFacebookUser(id: "fake user id",
  accessToken: "test access token",
  email: "test@email.com",
  firstName: "test first name",
  lastName: "test last name",
  name: "test name"
)
```

```Swift
// Delay used to simulate Facebook response. If 0 response is returned synchronously.
FacebookUserLoader.simulateLoadAfterDelay = 0.1
```

```Swift
// Call `onError` function without touching Facebook SDK.
FacebookUserLoader.simulateError = true
```
