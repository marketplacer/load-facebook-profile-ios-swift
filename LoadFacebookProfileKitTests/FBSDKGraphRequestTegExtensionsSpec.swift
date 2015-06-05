import Quick
import Nimble
import FBSDKLoginKit
import FBSDKCoreKit
import BrightFutures
import LoadFacebookProfileKit

class FBSDKGraphRequestTegExtensionsSpec: QuickSpec {
  override func spec() {
    var request: FBSDKGraphRequest!
    
    beforeEach {
      request = FBSDKGraphRequest(graphPath: "me", parameters: nil)
    }
    
    context("on failure") {
      it("should return an error") {
        let (_, future: Future<[String: AnyObject], TegFacebookUserLoaderError>) = request.startWithCompletionHandler()
        expect(future.error?.nsError.domain).toEventually(equal(TegFacebookUserLoaderErrorDomain))
        expect(future.error?.nsError.code).toEventually(equal(200))
      }
      
      it("should return an underlying error") {
        let (_, future: Future<[String: AnyObject], TegFacebookUserLoaderError>) = request.startWithCompletionHandler()
        expect(future.error?.nsError.userInfo.flatMap { $0[NSUnderlyingErrorKey] as? NSError }?.domain).toEventually(equal(FBSDKErrorDomain))
        expect(future.error?.nsError.userInfo.flatMap { $0[NSUnderlyingErrorKey] as? NSError }?.code).toEventually(equal(FBSDKErrorCode.GraphRequestGraphAPIErrorCode.rawValue))
      }
    }
  }
}
