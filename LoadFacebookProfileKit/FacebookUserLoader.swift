import Foundation
import FBSDKLoginKit


/**

Load user profile information from Facebook.

*/
public class FacebookUserLoader {
  
  private var _loginManager: FBSDKLoginManager?
  
  private var loginManager: FBSDKLoginManager? {
    get {
      if FacebookUserLoader.isSimulated { return nil }
      
      if _loginManager == nil {
        _loginManager = FBSDKLoginManager()
      }
      
      return _loginManager
    }
  }
  
  private var currentConnection: FBSDKGraphRequestConnection?
  
  public init() { }
  
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
    if FacebookUserLoader.isSimulated {
      FacebookUserLoader.simulateError(onError)
      FacebookUserLoader.simulateSuccess(onSuccess)
      return
    }
    
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
    
    loginManager?.logInWithReadPermissions(permissions) { [weak self] result, error in
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
    loginManager?.logOut()
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
  
  // MARK: - Simulation for tests
  // -------------------------------
  
  /**
  
  If present, the `load` method will call `onSuccess` function immediatelly with the supplied user without touching Facebook SDK. Used in tests.
  
  */
  public static var simulateSuccessUser: TegFacebookUser?
  
  /// Delay used to simulate Facebook response. if 0 response is returned synchronously.
  public static var simulateLoadAfterDelay = 0.1
  
  
  /// If true the `load` method will call `onError` function immediatelly without touching Facebook SDK. Used in tests.
  public static var simulateError = false
  
  private class func simulateSuccess(onSuccess: (TegFacebookUser)->()) {
    if let successUser = simulateSuccessUser {
      runAfterDelay(simulateLoadAfterDelay) { onSuccess(successUser) }
    }
  }
  
  private class func simulateError(onError: ()->()) {
    if simulateError {
      runAfterDelay(simulateLoadAfterDelay) { onError() }
    }
  }
  
  /// Runs the block after the delay. If delay is 0 the block is called synchronously.
  private class func runAfterDelay(delaySeconds: Double, block: ()->()) {
    if delaySeconds == 0 {
      block()
    } else {
      let time = dispatch_time(DISPATCH_TIME_NOW, Int64(delaySeconds * Double(NSEC_PER_SEC)))
      dispatch_after(time, dispatch_get_main_queue(), block)
    }
  }
  
  /// Check if we are currently simulating the facebook loading, which is used in unit test.
  private static var isSimulated: Bool {
    if simulateSuccessUser != nil { return true }
    if simulateError { return true }
    return false
  }
}
