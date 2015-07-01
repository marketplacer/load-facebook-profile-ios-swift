
/**

Loads Facebook user profile.

*/
public protocol FacebookUserLoader: class {
  /**
  
  Loads Facebook user profile.

  - parameter askEmail: If true we ask Facebook to return user's email. User may reject this request and return no email.
  - parameter onError: A function that will be called in case of any error. It will also be called if users cancells the Facebook login.
  - parameter onSuccess: A function that will be called after user authenticates with Facebook. A user profile information is passed to the function.
  */
  func load(askEmail askEmail: Bool, onError: ()->(), onSuccess: (TegFacebookUser)->())
}