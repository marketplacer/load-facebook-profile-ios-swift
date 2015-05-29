import Foundation
import BrightFutures

public enum TegFacebookUserLoaderError: ErrorType {
  case Parsing, GraphRequest(error: NSError?), LoginFailed(error: NSError?), LoginCanceled
  
  public var nsError: NSError {
    switch self {
    case .Parsing:
      return NSError(domain: "com.marketplacer.loadfacebookprofilekit", code: 100, userInfo: nil)
    case .GraphRequest(let error):
      return error ?? NSError(domain: "com.marketplacer.loadfacebookprofilekit", code: 101, userInfo: nil)
    case .LoginFailed(let error):
      return error ?? NSError(domain: "com.marketplacer.loadfacebookprofilekit", code: 102, userInfo: nil)
    case .LoginCanceled:
      return NSError(domain: "com.marketplacer.loadfacebookprofilekit", code: 103, userInfo: nil)
    }
  }
}
