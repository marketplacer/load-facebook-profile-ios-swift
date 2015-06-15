import Foundation
import BrightFutures

public extension Future {
  func convertTegFacebookUserLoaderErrorToNSError<T>() -> Future<T, NSError> {
    return self
      .map { $0 as! T}
      .mapError { error in
        let userInfo =  (error as? TegFacebookUserLoaderError)?.asUserInfo
        return  NSError(domain: error._domain, code: error._code, userInfo: userInfo)
    }
  }
}
