# Load Facebook user profile with Facebook SDK on iOS using Swift

This is a demo app and a helper function for loading Facebook user profile.

## Setup

1. Add Facebook SDK to your app. One needs to create a Facebook app, add Facebook SDK framework to your project and setup plist keys. Follow instructions on Facebook developer pages.

2. Copy `TegFacebookUserLoader.swift` and `TegFacebookUser.swift` into your project.

## Usage

```
TegFacebookUserLoader.load(askEmail: false) { user in
  // user is loaded
}
```

## Verifying user ID on server side

In order to login the user one needs to verify its user id on server side. In order to do it, send the following request from your server and compare the returned user id with the one loaded by `TegFacebookUserLoader.load` function.

```
https://graph.facebook.com/me?fields=id&access_token=YOUR_ACCCESS_TOKEN
```
