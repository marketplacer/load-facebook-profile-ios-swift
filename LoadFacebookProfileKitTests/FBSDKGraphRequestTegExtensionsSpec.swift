import Quick
import Nimble
import FBSDKLoginKit
import FBSDKCoreKit
import BrightFutures
import OHHTTPStubs
import Foundation
@testable import LoadFacebookProfileKit

class FBSDKGraphRequestTegExtensionsSpec: QuickSpec {
  override func spec() {
    var request: FBSDKGraphRequest!
    
    beforeEach {
      request = FBSDKGraphRequest(graphPath: "me", parameters: nil)
    }
    
    context("on success") {
      beforeEach {
        OHHTTPStubs.stubRequestsPassingTest({ $0.URL!.host == "graph.facebook.com" }) { _ in
          let meResponse = ["id": "test-user-id"]
          let data = try! NSJSONSerialization.dataWithJSONObject(meResponse, options:.PrettyPrinted)
          
          return OHHTTPStubsResponse(data: data, statusCode: 200, headers: nil)
        }
      }
      
      afterEach {
        OHHTTPStubs.removeAllStubs()
      }
      
      it("should return an error") {
        let closure: (connection: FBSDKGraphRequestConnection!, future: Future<[String: AnyObject], TegFacebookUserLoaderError>) = request.start()
        let dictionary: NSDictionary = ["id": "test-user-id"]
        expect(closure.future.value).toEventually(equal(dictionary), timeout: 2.0)
      }
    }
    
    
    context("on failure") {
      it("should return an error") {
        let closure: (connection: FBSDKGraphRequestConnection!, future: Future<[String: AnyObject], TegFacebookUserLoaderError>) = request.start()
        
        let underlyingError = NSError(domain: "com.facebook.sdk.core", code: 8, userInfo: [
          "com.facebook.sdk:FBSDKGraphRequestErrorCategoryKey": 0,
          "com.facebook.sdk:FBSDKGraphRequestErrorHTTPStatusCodeKey": 400,
          "com.facebook.sdk:FBSDKErrorDeveloperMessageKey": "An active access token must be used to query information about the current user.",
          "com.facebook.sdk:FBSDKGraphRequestErrorGraphErrorCode": 2500,
          "com.facebook.sdk:FBSDKGraphRequestErrorParsedJSONResponseKey":
            [
              "body":
              [
                "error": [
                  "code": 2500,
                  "message": "An active access token must be used to query information about the current user.",
                  "type": "OAuthException"
                ]
              ],
              "code": 400]])
        
        expect(closure.future.error).toEventually(equal(TegFacebookUserLoaderError.GraphRequest(error: underlyingError)), timeout: 2.0)
      }
    }
  }
}
