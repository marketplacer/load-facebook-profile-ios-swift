import Foundation
import FBSDKLoginKit


/**

Load user profile information from Facebook.

*/
public class FacebookUserLoader {
  private let loginManager: FBSDKLoginManager
  private var currentConnection: FBSDKGraphRequestConnection?
  
  /**

  If present, the `load` method will call `onSuccess` function immediatelly with the supplied user without touching Facebook SDK. It can be user in unit tests.
  
  */
  public static var simulateSuccessUser: TegFacebookUser?
  
  public init() {
    loginManager = FBSDKLoginManager()
  }
  
  deinit {
    cancel()
  }
  
  /**
  
  Loads Facebook user profile.
  
  - parameter askEmail: If true we ask Facebook to return user's email. User may reject this request and return no email.
  - parameter onError: A function that will be called in case of any error. It will also be called if users cancells the Facebook login.
  - parameter onSuccess: A function that will be called after user authenticates with Facebook. A user profile information is passed to the function.\
  */
  public func load(askEmail askEmail: Bool, onError:()->(), onSuccess: (TegFacebookUser)->()) {
    cancel()
    logOut()
    logInAndLoadUserProfile(askEmail, onError: onError, onSuccess: onSuccess)
  }
  
  func cancel() {
    currentConnection?.cancel()
    currentConnection = nil
  }
  
  private func logInAndLoadUserProfile(askEmail: Bool, onError: ()->(),
    onSuccess: (TegFacebookUser)->()) {
      
    var permissions = ["public_profile"]
    
    if askEmail {
      permissions.append("email")
    }
    
    loginManager.logInWithReadPermissions(permissions) { [weak self] result, error in
      if error != nil {
        onError()
        return
      }
      
      if result.isCancelled {
        onError()
        return
      }
      
      self?.loadFacebookMeInfo(onError, onSuccess: onSuccess)
    }
  }
  
  private func logOut() {
    loginManager.logOut()
  }
  
  /// Loads user profile information from Facebook.
  private func loadFacebookMeInfo(onError: ()->(), onSuccess: (TegFacebookUser) -> ()) {
    if FBSDKAccessToken.currentAccessToken() == nil {
      onError()
      return
    }
    
    let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: nil)
    
    currentConnection = graphRequest.startWithCompletionHandler { [weak self] connection, result, error in
      if error != nil {
        onError()
        return
      }
      
      if let userData = result as? NSDictionary,
        accessToken = self?.accessToken,
        user = FacebookUserLoader.parseMeData(userData, accessToken: accessToken) {
        
        onSuccess(user)
      } else {
        onError()
      }
    }
  }
  
  
  /// Parses user profile dictionary returned by Facebook SDK.
  class func parseMeData(data: NSDictionary, accessToken: String) -> TegFacebookUser? {
    if let id = data["id"] as? String {
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
