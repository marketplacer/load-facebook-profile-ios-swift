import Foundation
import FBSDKLoginKit
import BrightFutures

extension FBSDKGraphRequest {
  func start<T>() -> (FBSDKGraphRequestConnection!, Future<T, TegFacebookUserLoaderError>) {
    let promise = Promise<T, TegFacebookUserLoaderError>()
    
    let connection = startWithCompletionHandler { connection, result, error in
      if let error = error {
        promise.failure(.GraphRequest(error: error))
      } else if let result = result as? T {
        promise.success(result)
      } else {
        promise.failure(.GraphRequest(error: nil))
      }
    }
    
    return (connection, promise.future)
  }
}
