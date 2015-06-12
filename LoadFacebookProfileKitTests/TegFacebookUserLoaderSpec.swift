import Quick
import Nimble
import FBSDKLoginKit
import FBSDKCoreKit
import BrightFutures
import OHHTTPStubs
@testable import LoadFacebookProfileKit

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
              let data = try! NSJSONSerialization.dataWithJSONObject(meResponse, options:.PrettyPrinted)
              
              return OHHTTPStubsResponse(data: data, statusCode: 200, headers: nil)
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
            let underlyingError = NSError(domain: "test-domain", code: 101, userInfo: nil)
            expect(future.error).toEventually(equal(TegFacebookUserLoaderError.GraphRequest(error: underlyingError)))
          }
        }
      }
      
      describe("loadE") {
        context("on success") {
          beforeEach {
            loader = TegFacebookUserLoader(loginManager: StubbedSucceesFacebookLoginManager())
            
            OHHTTPStubs.stubRequestsPassingTest({ $0.URL!.host == "graph.facebook.com" }) { _ in
              let meResponse = ["id": "test-user-id"]
              let data = try! NSJSONSerialization.dataWithJSONObject(meResponse, options:.PrettyPrinted)
              
              return OHHTTPStubsResponse(data: data, statusCode: 200, headers: nil)
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
            expect(future.error?.domain).toEventually(equal("LoadFacebookProfileKit.TegFacebookUserLoaderError"))
            expect(future.error?.code).toEventually(equal(1))
          }
          
          it("should return an underlying error") {
            let future =  loader.loadE(askEmail: true)
            expect((future.error?.userInfo[NSUnderlyingErrorKey] as? NSError)?.domain).toEventually(equal("test-domain"))
            expect((future.error?.userInfo[NSUnderlyingErrorKey] as? NSError)?.code).toEventually(equal(101))
          }
        }
      }
    }
    
    describe("FakeUITestsFacebookUserLoader") {
      var loader: FacebookUserLoader!
      
      beforeEach {
        loader = FakeUITestsFacebookUserLoader()
      }
      
      describe("load") {
        it("should return an user") {
          let future =  loader.load(askEmail: true)
          expect(future.value?.id).toEventually(equal("fake-user-id"), timeout: 2)
        }
      }
      
      describe("loadE") {
        it("should return an user") {
          let future =  loader.loadE(askEmail: true)
          expect(future.value?.id).toEventually(equal("fake-user-id"), timeout: 2)
        }
      }
    }
    
    describe("FacebookUserLoaderFactory") {
      var loader: FacebookUserLoader!
      
      beforeEach {
        loader = FacebookUserLoaderFactory.userLoader
      }
      
      context("when not testing UI") {
        it("should return a TegFacebookUserLoader") {
          expect(loader is TegFacebookUserLoader).to(beTrue())
        }
      }
    }
  }
}
