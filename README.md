# Load Facebook user profile with Facebook SDK on iOS using Swift

This is a demo app and a helper function for loading Facebook user profile:

* Facebook user ID
* Access token
* Email
* First name
* Last name
* Name

Facebook user ID and access token can be used to authenticate Facebook user in your app.

## Setup

1. Add Facebook SDK to your app. One needs to create a Facebook app, add Facebook SDK framework to your project and setup plist keys. Follow instructions on Facebook developer pages.

2. Copy `TegFacebookUserLoader.swift` and `TegFacebookUser.swift` into your project.

## Usage

```swift
TegFacebookUserLoader.load(askEmail: false) { user in
  // user profile is loaded
}
```

## Profile fields can be empty

Please note that user may deny sharing all or some of the profile information. There is no guarantee, for example, that your app will get email address.

## Verifying user ID on server side

In order to login the user one needs to verify its user id on server side. Send the following request from your server and compare the returned user id with the one loaded by `TegFacebookUserLoader.load` function.

```
https://graph.facebook.com/me?fields=id&access_token=YOUR_ACCCESS_TOKEN
```

## Repository home

https://github.com/exchangegroup/load-facebook-profile-ios-swift
