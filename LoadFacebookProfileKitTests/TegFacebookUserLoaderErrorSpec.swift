import Foundation
import Quick
import Nimble
import LoadFacebookProfileKit

class TegFacebookUserLoaderErrorSpec: QuickSpec {
  override func spec() {
    describe ("nsError") {
      var error: NSError!
      
      context("Parsing") {
        beforeEach {
          error = TegFacebookUserLoaderError.Parsing.nsError
        }
        
        it("should have a valid domain") {
          expect(error.domain) == TegFacebookUserLoaderErrorDomain
        }
        
        it("should have a valid code") {
          expect(error.code) == 100
        }
      }
      
      context("Parsing") {
        var underlyingError: NSError!
        
        context("with an error") {
          beforeEach {
            underlyingError = NSError(domain: "test-underlying-error", code: 1005, userInfo: nil)
            error = TegFacebookUserLoaderError.GraphRequest(error: underlyingError).nsError
          }
          
          it("should have a valid domain") {
            expect(error.domain) == TegFacebookUserLoaderErrorDomain
          }
          
          it("should have a valid code") {
            expect(error.code) == 200
          }
          
          it("should have an underlying error") {
            let expectedUnderlyingError: NSError? = error.userInfo.flatMap { $0[NSUnderlyingErrorKey] as? NSError }
            expect(expectedUnderlyingError) == underlyingError
          }
        }
        
        context("without an error") {
          beforeEach {
            error = TegFacebookUserLoaderError.GraphRequest(error: nil).nsError
          }
          
          it("should have a valid domain") {
            expect(error.domain) == TegFacebookUserLoaderErrorDomain
          }
          
          it("should have a valid code") {
            expect(error.code) == 200
          }
          
          it("should have an no underlying error") {
            let expectedUnderlyingError: NSError? = error.userInfo.flatMap { $0[NSUnderlyingErrorKey] as? NSError }
            expect(expectedUnderlyingError).to(beNil())
          }
        }
      }
      
      context("LoginFailed") {
        var underlyingError: NSError!
        
        context("with an error") {
          beforeEach {
            underlyingError = NSError(domain: "test-underlying-error", code: 1005, userInfo: nil)
            error = TegFacebookUserLoaderError.LoginFailed(error: underlyingError).nsError
          }
          
          it("should have a valid domain") {
            expect(error.domain) == TegFacebookUserLoaderErrorDomain
          }
          
          it("should have a valid code") {
            expect(error.code) == 300
          }
          
          it("should have an underlying error") {
            let expectedUnderlyingError: NSError? = error.userInfo.flatMap { $0[NSUnderlyingErrorKey] as? NSError }
            expect(expectedUnderlyingError) == underlyingError
          }
        }
        
        context("without an error") {
          beforeEach {
            error = TegFacebookUserLoaderError.LoginFailed(error: nil).nsError
          }
          
          it("should have a valid domain") {
            expect(error.domain) == TegFacebookUserLoaderErrorDomain
          }
          
          it("should have a valid code") {
            expect(error.code) == 300
          }
          
          it("should have an no underlying error") {
            let expectedUnderlyingError: NSError? = error.userInfo.flatMap { $0[NSUnderlyingErrorKey] as? NSError }
            expect(expectedUnderlyingError).to(beNil())
          }
        }
      }
      
      context("LoginCanceled") {
        beforeEach {
          error = TegFacebookUserLoaderError.LoginCanceled.nsError
        }
        
        it("should have a valid domain") {
          expect(error.domain) == TegFacebookUserLoaderErrorDomain
        }
        
        it("should have a valid code") {
          expect(error.code) == 301
        }
      }
      
      context("AccessToken") {
        beforeEach {
          error = TegFacebookUserLoaderError.AccessToken.nsError
        }
        
        it("should have a valid domain") {
          expect(error.domain) == TegFacebookUserLoaderErrorDomain
        }
        
        it("should have a valid code") {
          expect(error.code) == 302
        }
      }
    }
  }
}
