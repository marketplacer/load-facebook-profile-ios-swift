import Foundation
import BrightFutures

public let TegFacebookUserLoaderErrorDomain: String = "com.MarketPlacer.LoadFacebookProfileKit"

public enum TegFacebookUserLoaderError: ErrorType {
  case Parsing
  case GraphRequest(error: NSError?)
  case LoginFailed(error: NSError?)
  case LoginCanceled
  
  public var nsError: NSError {
    switch self {
    case .Parsing:
      return NSError(domain: TegFacebookUserLoaderErrorDomain, code: 100, userInfo: nil)
    case .GraphRequest(let error):
      let userInfo = error.map { [NSUnderlyingErrorKey: $0] }
      return NSError(domain: TegFacebookUserLoaderErrorDomain, code: 101, userInfo: userInfo)
    case .LoginFailed(let error):
      let userInfo = error.map { [NSUnderlyingErrorKey: $0] }
      return NSError(domain: TegFacebookUserLoaderErrorDomain, code: 102, userInfo: userInfo)
    case .LoginCanceled:
      return NSError(domain: TegFacebookUserLoaderErrorDomain, code: 103, userInfo: nil)
    }
  }
}
