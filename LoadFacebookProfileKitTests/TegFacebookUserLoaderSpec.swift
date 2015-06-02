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
      
      describe("load") {
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
      
      describe("loaderE") {
        context("on failure") {
          it("should return an error") {
            let future =  loader.loadE(askEmail: true)
            expect(future.error?.domain).toEventually(equal(TegFacebookUserLoaderErrorDomain))
            expect(future.error?.code).toEventually(equal(200))
          }
          
          it("should return an underlying error") {
            let future =  loader.loadE(askEmail: true)
            expect(future.error?.userInfo.flatMap { $0[NSUnderlyingErrorKey] as? NSError }?.domain).toEventually(equal(FBSDKErrorDomain))
            expect(future.error?.userInfo.flatMap { $0[NSUnderlyingErrorKey] as? NSError }?.code).toEventually(equal(FBSDKErrorCode.GraphRequestGraphAPIErrorCode.rawValue))
          }
        }
        
      }
      
    }
  }
}
