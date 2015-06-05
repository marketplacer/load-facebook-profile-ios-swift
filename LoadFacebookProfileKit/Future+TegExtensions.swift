import Foundation
import BrightFutures

extension Future {
  func convertTegFacebookUserLoaderErrorToNSError<T>() -> Future<T, NSError> {
    return self
      .map { $0 as! T}
      .mapError { $0.nsError}
  }
}
