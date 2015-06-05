import Foundation
import BrightFutures

public let TegFacebookUserLoaderErrorDomain: String = "com.MarketPlacer.LoadFacebookProfileKit"

public enum TegFacebookUserLoaderError: ErrorType {
  case Parsing
  case GraphRequest(error: NSError?)
  case LoginFailed(error: NSError?)
  case LoginCanceled
  case AccessToken
  
  public var nsError: NSError {
    switch self {
    case .Parsing:
      return NSError(domain: TegFacebookUserLoaderErrorDomain, code: 100, userInfo: nil)
    case .GraphRequest(let error):
      let userInfo = error.map { [NSUnderlyingErrorKey: $0] }
      return NSError(domain: TegFacebookUserLoaderErrorDomain, code: 200, userInfo: userInfo)
    case .LoginFailed(let error):
      let userInfo = error.map { [NSUnderlyingErrorKey: $0] }
      return NSError(domain: TegFacebookUserLoaderErrorDomain, code: 300, userInfo: userInfo)
    case .LoginCanceled:
      return NSError(domain: TegFacebookUserLoaderErrorDomain, code: 301, userInfo: nil)
    case .AccessToken:
      return NSError(domain: TegFacebookUserLoaderErrorDomain, code: 302, userInfo: nil)
    }
  }
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
