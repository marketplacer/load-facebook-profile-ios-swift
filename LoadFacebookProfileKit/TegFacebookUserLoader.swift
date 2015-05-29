import Foundation
import FBSDKLoginKit
import BrightFutures
import Result
import Box

public protocol FacebookUserLoader: class {
  func load(#askEmail: Bool) -> Future<TegFacebookUser, TegFacebookUserLoaderError>
}

public class FacebookUserLoaderFactory {
  public class var userLoader: FacebookUserLoader {
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

public class TegFacebookUserLoader: FacebookUserLoader {
  private let loginManager: FBSDKLoginManager
  
  public init() {
    loginManager = FBSDKLoginManager()
  }
  
  public func load(#askEmail: Bool) -> Future<TegFacebookUser, TegFacebookUserLoaderError> {
    logOut()
    
    return login(askEmail: askEmail).flatMap(f: loadFacebookMeInfo)
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

class FakeFacebookUserLoader: FacebookUserLoader {
  func load(#askEmail: Bool) -> Future<TegFacebookUser, TegFacebookUserLoaderError> {
    let fakeUser = TegFacebookUser(id: "fake-user-id", accessToken: "fake-access-token", email: nil, firstName: nil, lastName: nil, name: nil)
    return Future<TegFacebookUser, TegFacebookUserLoaderError>.completeAfter(1, withValue: fakeUser)
  }
}
