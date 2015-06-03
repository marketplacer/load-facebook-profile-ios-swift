import Foundation
import FBSDKLoginKit
import BrightFutures

extension FBSDKLoginManager {
  public func logInWithReadPermissions(permissions: [String]) -> Future<FBSDKLoginManagerLoginResult, TegFacebookUserLoaderError> {
    let promise = Promise<FBSDKLoginManagerLoginResult, TegFacebookUserLoaderError>()
    
    logInWithReadPermissions(permissions) { result, error in
      if error != nil {
        promise.failure(.LoginFailed(error: error))
      } else if result == nil {
        promise.failure(.LoginFailed(error: nil))
      } else if result.isCancelled {
        promise.failure(.LoginCanceled)
      } else {
        promise.success(result)
      }
    }
    
    return promise.future
  }
}
