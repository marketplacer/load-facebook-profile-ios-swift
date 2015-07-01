import Foundation
import FBSDKLoginKit
import BrightFutures
import Result

// MARK: - Factory

public protocol FacebookUserLoader: class {
  func load(askEmail askEmail: Bool, onSuccess: (TegFacebookUser)->())
}

public class FacebookUserLoaderFactory {
  public class var userLoader: FacebookUserLoader {
    if isUITesting() {
      return FakeUITestsFacebookUserLoader()
    } else {
      return TegFacebookUserLoader()
    }
  }
  
  private class func isUITesting() -> Bool {
    let environment = NSProcessInfo.processInfo().environment
    let runningUITests =  environment["RUNNING_UI_TESTS"]
    return runningUITests == "YES"
  }
}

// MARK: - TegFacebookUserLoader

class TegFacebookUserLoader: FacebookUserLoader {
  private let loginManager: FBSDKLoginManager
  private var currentConnection: FBSDKGraphRequestConnection?
  
  init() {
    loginManager = FBSDKLoginManager()
  }
  
  deinit {
    cancel()
  }
  
  func load(askEmail askEmail: Bool, onSuccess: (TegFacebookUser)->()) {
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
    
    let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
    
    currentConnection = graphRequest.startWithCompletionHandler { [weak self] connection, result, error in
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


// MARK: - UI Tests

class FakeUITestsFacebookUserLoader: FacebookUserLoader {
  func load(askEmail askEmail: Bool, onSuccess: (TegFacebookUser)->()) {
    let fakeUser = TegFacebookUser(id: "fake-user-id",
      accessToken: "fake-access-token", email: nil, firstName: nil, lastName: nil, name: nil)
    
    onSuccess(fakeUser)
  }
}
