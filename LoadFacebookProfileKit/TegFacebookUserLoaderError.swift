import Foundation
import BrightFutures

public enum TegFacebookUserLoaderError: ErrorType {
  case Parsing
  case GraphRequest(error: NSError?)
  case LoginFailed(error: NSError?)
  case LoginCanceled
  case AccessToken
}

extension TegFacebookUserLoaderError: Equatable {}

public func == (lhs: TegFacebookUserLoaderError, rhs: TegFacebookUserLoaderError) -> Bool {
  switch (lhs, rhs) {
  case (.Parsing, .Parsing): return true
  case (.GraphRequest(let lError), .GraphRequest(let rError)): return lError == rError
  case (.LoginFailed(let lError), .LoginFailed(let rError)): return lError == rError
  case (.LoginCanceled, .LoginCanceled): return true
  case (.AccessToken, .AccessToken): return true
  default: return false
  }
}

extension TegFacebookUserLoaderError {
  var asUserInfo: [NSObject : AnyObject]? {
    var underlyingError: NSError?
    switch self {
    case .GraphRequest(let error):
      underlyingError = error
    case .LoginFailed(let error):
      underlyingError = error
    default: break
    }
    
    return underlyingError.map { [NSUnderlyingErrorKey: $0] }
  }
}

