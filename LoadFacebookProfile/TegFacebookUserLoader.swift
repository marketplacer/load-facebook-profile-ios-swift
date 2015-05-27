import Foundation
import FBSDKCoreKit
import FBSDKLoginKit

protocol FacebookUserLoader: class {
  func load(#askEmail: Bool, onSuccess: (TegFacebookUser)->())
  func cancel()
}

class FacebookUserLoaderFactory {
  class var userLoader: FacebookUserLoader {
    if isKIFing() {
      return FakeFacebookUserLoader()
    } else {
      return TegFacebookUserLoader()
    }
  }
  
  private class func isKIFing() -> Bool {
    return NSClassFromString("KIFTestActor") != nil
  }
}

class TegFacebookUserLoader: FacebookUserLoader {
  private let loginManager: FBSDKLoginManager
  private var currentConnection: FBSDKGraphRequestConnection?
  
  init() {
    loginManager = FBSDKLoginManager()
  }
  
  deinit {
    cancel()
  }
  
  func load(#askEmail: Bool, onSuccess: (TegFacebookUser)->()) {
    cancel()
    logOut()
    logInAndLoadUserProfile(askEmail, onSuccess: onSuccess)
  }
  
  func cancel() {
    currentConnection?.cancel()
    currentConnection = nil
  }
  
  private func logInAndLoadUserProfile(askEmail: Bool, onSuccess: (TegFacebookUser)->()) {
    var permissions = ["public_profile"]
    
    if askEmail {
      permissions.append("email")
    }
    
    loginManager.logInWithReadPermissions(permissions) { [weak self] result, error in
      if error != nil { return }
      if result.isCancelled { return }
      
      self?.loadFacebookMeInfo(onSuccess)
    }
  }
  
  private func logOut() {
    loginManager.logOut()
  }
  
  private func loadFacebookMeInfo(onSuccess: (TegFacebookUser) -> ()) {
    if FBSDKAccessToken.currentAccessToken() == nil { return }
    currentConnection = FBSDKGraphRequest(graphPath: "me", parameters: nil).startWithCompletionHandler { [weak self] connection, result, error in
      if error != nil { return }
      
      if let userData = result as? NSDictionary,
        let user = self?.parseMeData(userData) {
          onSuccess(user)
      }
    }
  }
  
  private func parseMeData(data: NSDictionary) -> TegFacebookUser? {
    if let id = data["id"] as? String,
      let accessToken = accessToken {
        return TegFacebookUser(
          id: id,
          accessToken: accessToken,
          email: data["email"] as? String,
          firstName: data["first_name"] as? String,
          lastName: data["last_name"] as? String,
          name: data["name"] as? String)
    }
    
    return nil
  }
  
  private var accessToken: String? {
    return FBSDKAccessToken.currentAccessToken().tokenString
  }
}

class FakeFacebookUserLoader: FacebookUserLoader {
  func load(#askEmail: Bool, onSuccess: (TegFacebookUser)->()) {
    TegQ.runAfterDelay(1) { [weak self] in
      let fakeUser = TegFacebookUser(id: "fake-user-id", accessToken: "fake-access-token", email: nil, firstName: nil, lastName: nil, name: nil)
      onSuccess(fakeUser)
    }
  }
  
  func cancel() {
    // Do nothing
  }
}
