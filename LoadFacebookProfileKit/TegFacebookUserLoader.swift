import Foundation
import FBSDKLoginKit
import BrightFutures
import Result
import Box

// MARK: - Factory

public protocol FacebookUserLoader: class {
  func load(#askEmail: Bool) -> Future<TegFacebookUser, TegFacebookUserLoaderError>
  func loadE(#askEmail: Bool) -> Future<TegFacebookUser, NSError>
}

public class FacebookUserLoaderFactory {
  public class var userLoader: FacebookUserLoader {
    if isKIFing() {
      return FakeKIFFacebookUserLoader()
    } else if isTesting() {
      return FakeFacebookUserLoader()
    } else {
      return TegFacebookUserLoader()
    }
  }
  
  private class func isKIFing() -> Bool {
    return NSClassFromString("KIFTestActor") != nil
  }
  
  class func isTesting() -> Bool {
    return NSClassFromString("XCTest") != nil
  }
}

// MARK: - TegFacebookUserLoader

public class TegFacebookUserLoader: FacebookUserLoader {
  private let loginManager: FBSDKLoginManager
  
  public init() {
    loginManager = FBSDKLoginManager()
  }
  
  public func load(#askEmail: Bool) -> Future<TegFacebookUser, TegFacebookUserLoaderError> {
    logOut()
    
    return login(askEmail: askEmail).flatMap(f: loadFacebookMeInfo)
  }
  
  public func loadE(#askEmail: Bool) -> Future<TegFacebookUser, NSError> {
    return load(askEmail: true).convertTegFacebookUserLoaderErrorToNSError()
  }
  
  private func login(#askEmail: Bool) -> Future<FBSDKLoginManagerLoginResult, TegFacebookUserLoaderError> {
    var permissions = ["public_profile"]
    
    if askEmail {
      permissions.append("email")
    }
    
    return loginManager.logInWithReadPermissions(permissions)
  }
  
  private func loadFacebookMeInfo(loginResult: FBSDKLoginManagerLoginResult) -> Future<TegFacebookUser, TegFacebookUserLoaderError> {
    let request = FBSDKGraphRequest(graphPath: "me", parameters: nil)
    let (_, future: Future<[String: AnyObject], TegFacebookUserLoaderError>) = request.startWithCompletionHandler()
    
    return future.flatMap { result in
      TegFacebookUser.parse(result, accessToken: loginResult.token?.tokenString)
    }
  }
  
  private func logOut() {
    loginManager.logOut()
  }
}

// MARK: - KIF Tests

class FakeKIFFacebookUserLoader: FacebookUserLoader {
  func load(#askEmail: Bool) -> Future<TegFacebookUser, TegFacebookUserLoaderError> {
    let fakeUser = TegFacebookUser(id: "fake-user-id", accessToken: "fake-access-token", email: nil, firstName: nil, lastName: nil, name: nil)
    return Future<TegFacebookUser, TegFacebookUserLoaderError>.completeAfter(1, withValue: fakeUser)
  }
  
  func loadE(#askEmail: Bool) -> Future<TegFacebookUser, NSError> {
    let future: Future<TegFacebookUser, TegFacebookUserLoaderError> = load(askEmail: true)
    return load(askEmail: true).convertTegFacebookUserLoaderErrorToNSError()
  }
}

// MARK: - Tests

class FakeFacebookUserLoader: FacebookUserLoader {
  func load(#askEmail: Bool) -> Future<TegFacebookUser, TegFacebookUserLoaderError> {
    let token = FBSDKAccessToken(tokenString: "test-token", permissions: nil, declinedPermissions: nil, appID: "test-app-id", userID: "test-user-id", expirationDate: NSDate(timeIntervalSinceNow: 120), refreshDate: NSDate(timeIntervalSinceNow: 240))
    let loginResult = FBSDKLoginManagerLoginResult(token: token, isCancelled: false, grantedPermissions: Set<NSObject>(), declinedPermissions:  Set<NSObject>())
    
    return loadFacebookMeInfo(loginResult)
  }
  
  func loadE(#askEmail: Bool) -> Future<TegFacebookUser, NSError> {
    let future: Future<TegFacebookUser, TegFacebookUserLoaderError> = load(askEmail: true)
    return load(askEmail: true).convertTegFacebookUserLoaderErrorToNSError()
  }
  
  private func loadFacebookMeInfo(loginResult: FBSDKLoginManagerLoginResult) -> Future<TegFacebookUser, TegFacebookUserLoaderError> {
    let request = FBSDKGraphRequest(graphPath: "me", parameters: nil)
    let (_, future: Future<[String: AnyObject], TegFacebookUserLoaderError>) = request.startWithCompletionHandler()
    
    return future.flatMap { result in
      TegFacebookUser.parse(result, accessToken: loginResult.token?.tokenString)
    }
  }
}
