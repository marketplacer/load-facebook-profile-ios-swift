import Foundation
import FBSDKLoginKit
import BrightFutures
import Result

// MARK: - Factory

public protocol FacebookUserLoader: class {
  func load(askEmail askEmail: Bool) -> Future<TegFacebookUser, TegFacebookUserLoaderError>
  func loadE(askEmail askEmail: Bool) -> Future<TegFacebookUser, NSError>
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

// MARK: - FBSDKLoginManager Stubbing

public protocol FacebookLoginManager: class {
  func logInWithReadPermissions(permissions: [String]) -> Future<FBSDKLoginManagerLoginResult, TegFacebookUserLoaderError>
  func logOut()
}

extension FBSDKLoginManager: FacebookLoginManager {}

// MARK: - TegFacebookUserLoader

public class TegFacebookUserLoader: FacebookUserLoader {
  private let loginManager: FacebookLoginManager
  
  public init(loginManager: FacebookLoginManager = FBSDKLoginManager()) {
    self.loginManager = loginManager
  }
  
  public func load(askEmail askEmail: Bool) -> Future<TegFacebookUser, TegFacebookUserLoaderError> {
    logOut()
    
    return login(askEmail: askEmail).flatMap(f: loadFacebookMeInfo)
  }
  
  public func loadE(askEmail askEmail: Bool) -> Future<TegFacebookUser, NSError> {
    return load(askEmail: true).convertTegFacebookUserLoaderErrorToNSError()
  }
  
  private func login(askEmail askEmail: Bool) -> Future<FBSDKLoginManagerLoginResult, TegFacebookUserLoaderError> {
    var permissions = ["public_profile"]
    
    if askEmail {
      permissions.append("email")
    }
    
    return loginManager.logInWithReadPermissions(permissions)
  }
  
  private func loadFacebookMeInfo(loginResult: FBSDKLoginManagerLoginResult) -> Future<TegFacebookUser, TegFacebookUserLoaderError> {
    let request = FBSDKGraphRequest(graphPath: "me", parameters: nil)
    
    let closure: (connection: FBSDKGraphRequestConnection!, future: Future<[String: AnyObject], TegFacebookUserLoaderError>) = request.start()
    
    return closure.future.flatMap { result in
      TegFacebookUser.parse(result, accessToken: loginResult.token?.tokenString)
    }
  }
  
  private func logOut() {
    loginManager.logOut()
  }
}

// MARK: - UI Tests

class FakeUITestsFacebookUserLoader: FacebookUserLoader {
  func load(askEmail askEmail: Bool) -> Future<TegFacebookUser, TegFacebookUserLoaderError> {
    let fakeUser = TegFacebookUser(id: "fake-user-id", accessToken: "fake-access-token", email: nil, firstName: nil, lastName: nil, name: nil)
    return Future<TegFacebookUser, TegFacebookUserLoaderError>.completeAfter(1, withValue: fakeUser)
  }
  
  func loadE(askEmail askEmail: Bool) -> Future<TegFacebookUser, NSError> {
    return load(askEmail: true).convertTegFacebookUserLoaderErrorToNSError()
  }
}
