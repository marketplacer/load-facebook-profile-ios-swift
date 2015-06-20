import Foundation
import Quick
import Nimble
@testable import LoadFacebookProfileKit

class TegFacebookUserLoaderErrorSpec: QuickSpec {
  override func spec() {
    describe("equality") {
      describe("Parsing") {
        context("when Equal") {
          it("should be equal") {
            expect(TegFacebookUserLoaderError.Parsing) != TegFacebookUserLoaderError.Parsing
          }
        }
        
        context("when not Equal") {
          it("should not be equal") {
            expect(TegFacebookUserLoaderError.Parsing) != TegFacebookUserLoaderError.LoginCanceled
          }
        }
      }
      
      describe("GraphRequest") {
        context("when Equal") {
          context("with an error") {
            it("should be equal") {
              let error = NSError(domain: "test-domain", code: 100, userInfo: nil)
              expect(TegFacebookUserLoaderError.GraphRequest(error: error)) == TegFacebookUserLoaderError.GraphRequest(error: error)
            }
          }
          
          context("without an error") {
            it("should be equal") {
              expect(TegFacebookUserLoaderError.GraphRequest(error: nil)) == TegFacebookUserLoaderError.GraphRequest(error: nil)
            }
          }
        }
        
        context("when not Equal") {
          context("with different  error") {
            it("should not be equal") {
              let error = NSError(domain: "test-domain", code: 100, userInfo: nil)
              let error2 = NSError(domain: "test-domain", code: 200, userInfo: nil)
              expect(TegFacebookUserLoaderError.GraphRequest(error: error)) != TegFacebookUserLoaderError.GraphRequest(error: error2)
            }
          }
          
          context("without an error") {
            it("should not be equal") {
              expect(TegFacebookUserLoaderError.GraphRequest(error: nil)) != TegFacebookUserLoaderError.AccessToken
            }
          }
        }
      }
      
      describe("LoginFailed") {
        context("when Equal") {
          context("with an error") {
            it("should be equal") {
              let error = NSError(domain: "test-domain", code: 100, userInfo: nil)
              expect(TegFacebookUserLoaderError.LoginFailed(error: error)) == TegFacebookUserLoaderError.LoginFailed(error: error)
            }
          }
          
          context("without an error") {
            it("should be equal") {
              expect(TegFacebookUserLoaderError.LoginFailed(error: nil)) == TegFacebookUserLoaderError.LoginFailed(error: nil)
            }
          }
        }
        
        context("when not Equal") {
          context("with different  error") {
            it("should not be equal") {
              let error = NSError(domain: "test-domain", code: 100, userInfo: nil)
              let error2 = NSError(domain: "test-domain", code: 200, userInfo: nil)
              expect(TegFacebookUserLoaderError.LoginFailed(error: error)) != TegFacebookUserLoaderError.LoginFailed(error: error2)
            }
          }
          
          context("without an error") {
            it("should not be equal") {
              expect(TegFacebookUserLoaderError.LoginFailed(error: nil)) != TegFacebookUserLoaderError.AccessToken
            }
          }
        }
      }
      
      describe("LoginCanceled") {
        context("when Equal") {
          it("should be equal") {
            expect(TegFacebookUserLoaderError.LoginCanceled) == TegFacebookUserLoaderError.LoginCanceled
          }
        }
        
        context("when not Equal") {
          it("should not be equal") {
            expect(TegFacebookUserLoaderError.LoginCanceled) != TegFacebookUserLoaderError.Parsing
          }
        }
      }
      
      describe("AccessToken") {
        context("when Equal") {
          it("should be equal") {
            expect(TegFacebookUserLoaderError.AccessToken) == TegFacebookUserLoaderError.AccessToken
          }
        }
        
        context("when not Equal") {
          it("should not be equal") {
            expect(TegFacebookUserLoaderError.AccessToken) != TegFacebookUserLoaderError.Parsing
          }
        }
      }
    }
    
    describe("asUserInfo") {
      describe("Parsing") {
        it("should an underlying error") {
          let userInfo = TegFacebookUserLoaderError.Parsing.asUserInfo as? [String: NSError]
          expect(userInfo?[NSUnderlyingErrorKey]).to(beNil())
        }
      }
      
      describe("GraphRequest") {
        context("with an error") {
          it("should an underlying error") {
            let error = NSError(domain: "test-domain", code: 100, userInfo: nil)
            let userInfo = TegFacebookUserLoaderError.GraphRequest(error: error).asUserInfo as? [String: NSError]
             expect(userInfo?[NSUnderlyingErrorKey]) == error
          }
        }
        
        context("without an error") {
          it("should an underlying error") {
            let userInfo = TegFacebookUserLoaderError.GraphRequest(error: nil).asUserInfo as? [String: NSError]
            expect(userInfo?[NSUnderlyingErrorKey]).to(beNil())
          }
        }
      }
      
      describe("LoginFailed") {
        context("with an error") {
          it("should an underlying error") {
            let error = NSError(domain: "test-domain", code: 100, userInfo: nil)
            let userInfo = TegFacebookUserLoaderError.LoginFailed(error: error).asUserInfo as? [String: NSError]
            expect(userInfo?[NSUnderlyingErrorKey]) == error
          }
        }
        
        context("without an error") {
          it("should an underlying error") {
            let userInfo = TegFacebookUserLoaderError.LoginFailed(error: nil).asUserInfo as? [String: NSError]
            expect(userInfo?[NSUnderlyingErrorKey]).to(beNil())
          }
        }
      }
    }
    
    describe("LoginCanceled") {
      it("should an underlying error") {
        let userInfo = TegFacebookUserLoaderError.LoginCanceled.asUserInfo as? [String: NSError]
        expect(userInfo?[NSUnderlyingErrorKey]).to(beNil())
      }
    }
    
    describe("AccessToken") {
      it("should an underlying error") {
        let userInfo = TegFacebookUserLoaderError.AccessToken.asUserInfo as? [String: NSError]
        expect(userInfo?[NSUnderlyingErrorKey]).to(beNil())
      }
    }
  }
}
