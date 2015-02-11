# iOS demo app to load Facebook user profile using Facebook SDK

This demo uses code to get Facebook profile, user id and access token. It does not use the Facebook login button UI from the SDK.

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