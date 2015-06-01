import Quick
import Nimble
import FBSDKLoginKit
import FBSDKCoreKit
import BrightFutures
import LoadFacebookProfileKit

class TegFacebookUserLoaderSpec: QuickSpec {
  override func spec() {
    describe("loader") {
      var loader: FacebookUserLoader!
      
      beforeEach {
        loader = FacebookUserLoaderFactory.userLoader
      }
      
      context("on failure") {
        it("should return an error") {
          let future =  loader.load(askEmail: true)
          expect(future.error?.nsError.domain).toEventually(equal(TegFacebookUserLoaderErrorDomain))
          expect(future.error?.nsError.code).toEventually(equal(200))
        }
        
        it("should return an underlying error") {
          let future =  loader.load(askEmail: true)
          expect(future.error?.nsError.userInfo.flatMap { $0[NSUnderlyingErrorKey] as? NSError }?.domain).toEventually(equal(FBSDKErrorDomain))
          expect(future.error?.nsError.userInfo.flatMap { $0[NSUnderlyingErrorKey] as? NSError }?.code).toEventually(equal(FBSDKErrorCode.GraphRequestGraphAPIErrorCode.rawValue))
        }
      }
    }
  }
}
