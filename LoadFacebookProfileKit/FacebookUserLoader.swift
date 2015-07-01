public protocol FacebookUserLoader: class {
  func load(askEmail askEmail: Bool, onSuccess: (TegFacebookUser)->())
}