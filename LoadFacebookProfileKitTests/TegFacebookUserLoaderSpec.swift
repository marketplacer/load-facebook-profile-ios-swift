import Quick
import Nimble
import FBSDKLoginKit
import FBSDKCoreKit
import BrightFutures
import LoadFacebookProfileKit
import OHHTTPStubs

class TegFacebookUserLoaderSpec: QuickSpec {
  override func spec() {
    describe("loader") {
      class StubbedFailFacebookLoginManager: FacebookLoginManager {
        func logInWithReadPermissions(permissions: [String]) -> Future<FBSDKLoginManagerLoginResult, TegFacebookUserLoaderError> {
          let underlyingError = NSError(domain: "test-domain", code: 101, userInfo: nil)
          return Future<FBSDKLoginManagerLoginResult, TegFacebookUserLoaderError>.failed(.GraphRequest(error: underlyingError))
        }
        
        func logOut() {
          // do nothing
        }
      }
      
      class StubbedSucceesFacebookLoginManager: FacebookLoginManager {
        func logInWithReadPermissions(permissions: [String]) -> Future<FBSDKLoginManagerLoginResult, TegFacebookUserLoaderError> {
          let token = FBSDKAccessToken(tokenString: "test-token-string", permissions: nil, declinedPermissions: nil, appID: "test-app-id", userID: "test-user-id", expirationDate: NSDate(timeIntervalSinceNow: 120), refreshDate: NSDate(timeIntervalSinceNow: 240))
          let result = FBSDKLoginManagerLoginResult(token: token, isCancelled: false, grantedPermissions: nil, declinedPermissions: nil)
          return Future<FBSDKLoginManagerLoginResult, TegFacebookUserLoaderError>.succeeded(result)
        }
        
        func logOut() {
          // do nothing
        }
      }
      
      var loader: FacebookUserLoader!
      
      describe("load") {
        context("on success") {
          beforeEach {
            loader = TegFacebookUserLoader(loginManager: StubbedSucceesFacebookLoginManager())
            
            OHHTTPStubs.stubRequestsPassingTest({ $0.URL!.host == "graph.facebook.com" }) { _ in
              let meResponse = ["id": "test-user-id"]
              let data = NSJSONSerialization.dataWithJSONObject(meResponse, options:.PrettyPrinted, error: nil)
              
              return OHHTTPStubsResponse(data: data!, statusCode: 200, headers: nil)
            }
          }
          
          afterEach {
            OHHTTPStubs.removeAllStubs()
          }
          
          it("should return an user") {
            let future =  loader.load(askEmail: true)
            expect(future.value?.id).toEventually(equal("test-user-id"))
          }
        }
        
        context("on failure") {
          beforeEach {
            loader = TegFacebookUserLoader(loginManager: StubbedFailFacebookLoginManager())
          }
          
          it("should return an error") {
            let future =  loader.load(askEmail: true)
            expect(future.error?.nsError.domain).toEventually(equal(TegFacebookUserLoaderErrorDomain))
            expect(future.error?.nsError.code).toEventually(equal(200))
          }
          
          it("should return an underlying error") {
            let future =  loader.load(askEmail: true)
            expect(future.error?.nsError.userInfo.flatMap { $0[NSUnderlyingErrorKey] as? NSError }?.domain).toEventually(equal("test-domain"))
            expect(future.error?.nsError.userInfo.flatMap { $0[NSUnderlyingErrorKey] as? NSError }?.code).toEventually(equal(101))
          }
        }
      }
      
      describe("loaderE") {
        context("on success") {
          beforeEach {
            loader = TegFacebookUserLoader(loginManager: StubbedSucceesFacebookLoginManager())
            
            OHHTTPStubs.stubRequestsPassingTest({ $0.URL!.host == "graph.facebook.com" }) { _ in
              let meResponse = ["id": "test-user-id"]
              let data = NSJSONSerialization.dataWithJSONObject(meResponse, options:.PrettyPrinted, error: nil)
              
              return OHHTTPStubsResponse(data: data!, statusCode: 200, headers: nil)
            }
          }
          
          afterEach {
            OHHTTPStubs.removeAllStubs()
          }
          
          it("should return an user") {
            let future =  loader.loadE(askEmail: true)
            expect(future.value?.id).toEventually(equal("test-user-id"))
          }
        }
        
        
        context("on failure") {
          beforeEach {
            loader = TegFacebookUserLoader(loginManager: StubbedFailFacebookLoginManager())
          }
          
          it("should return an error") {
            let future =  loader.loadE(askEmail: true)
            expect(future.error?.domain).toEventually(equal(TegFacebookUserLoaderErrorDomain))
            expect(future.error?.code).toEventually(equal(200))
          }
          
          it("should return an underlying error") {
            let future =  loader.loadE(askEmail: true)
            expect(future.error?.userInfo.flatMap { $0[NSUnderlyingErrorKey] as? NSError }?.domain).toEventually(equal("test-domain"))
            expect(future.error?.userInfo.flatMap { $0[NSUnderlyingErrorKey] as? NSError }?.code).toEventually(equal(101))
          }
        }
      }
    }
  }
}
