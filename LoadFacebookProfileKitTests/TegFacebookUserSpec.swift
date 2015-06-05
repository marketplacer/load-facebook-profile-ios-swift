import Foundation
import Quick
import Nimble
import LoadFacebookProfileKit
import Result
import Box

class TegFacebookUserSpec: QuickSpec {
  override func spec() {
     var user: TegFacebookUser!
    
    describe("instantiation") {
      beforeEach {
        user = TegFacebookUser(id: "test-id", accessToken: "test-access-token", email: "test-email", firstName: "test-first-name", lastName: "test-last-name", name: "test-name")
      }
      
      it("should have a valid id") {
        expect(user.id) == "test-id"
      }
      
      it("should have a valid accessToken") {
        expect(user.accessToken) == "test-access-token"
      }
      
      it("should have a valid email") {
        expect(user.email) == "test-email"
      }
      
      it("should have a valid firstName") {
        expect(user.firstName) == "test-first-name"
      }
      
      it("should have a valid lastName") {
        expect(user.lastName) == "test-last-name"
      }
      
      it("should have a valid name") {
        expect(user.name) == "test-name"
      }
    }
    
    describe("parse") {
      var dictionary: [String: AnyObject]!
      var result: Result<TegFacebookUser, TegFacebookUserLoaderError>!
      
      context("with a dictionary with all values") {
        beforeEach {
          dictionary = [
            "id": "test-id",
            "email": "test-email",
            "first_name": "test-first-name",
            "last_name": "test-last-name",
            "name": "test-name"
          ]
          
          result = TegFacebookUser.parse(dictionary, accessToken: "test-access-token")
          user = result.value
        }
        
        it("should have a valid id") {
          expect(user.id) == "test-id"
        }
        
        it("should have a valid accessToken") {
          expect(user.accessToken) == "test-access-token"
        }
        
        it("should have a valid email") {
          expect(user.email) == "test-email"
        }
        
        it("should have a valid firstName") {
          expect(user.firstName) == "test-first-name"
        }
        
        it("should have a valid lastName") {
          expect(user.lastName) == "test-last-name"
        }
        
        it("should have a valid name") {
          expect(user.name) == "test-name"
        }
        
        it("should return no parsing error") {
          expect(result.error).to(beNil())
        }
      }
      
      context("with a dictionary with only the required values") {
        beforeEach {
          dictionary = [
            "id": "test-id",
            "last_name": 1
          ]
          
          result = TegFacebookUser.parse(dictionary, accessToken: "test-access-token")
          user = result.value
        }
        
        it("should have a valid id") {
          expect(user.id) == "test-id"
        }
        
        it("should have a valid accessToken") {
          expect(user.accessToken) == "test-access-token"
        }
        
        it("should have no email") {
          expect(user.email).to(beNil())
        }
        
        it("should have a no firstName") {
          expect(user.firstName).to(beNil())
        }
        
        it("should have no lastName") {
          expect(user.lastName).to(beNil())
        }
        
        it("should have no name") {
          expect(user.name).to(beNil())
        }
        
        it("should return no parsing error") {
          expect(result.error).to(beNil())
        }
      }
      
      context("with a dictionary missing required values") {
        beforeEach {
          dictionary = [
            "id": 10,
            "last_name": 1
          ]
          
          result = TegFacebookUser.parse(dictionary, accessToken: "test-access-token")
          user = result.value
        }
        
        it("should return no user") {
          expect(user).to(beNil())
        }
        
        it("should return parsing error") {
          let error: TegFacebookUserLoaderError = result.error!
          expect(error) == TegFacebookUserLoaderError.Parsing
        }
      }
      
      context("with valid dictionary but without an access token") {
        beforeEach {
          dictionary = [
            "id": "test-id",
            "email": "test-email",
            "first_name": "test-first-name",
            "last_name": "test-last-name",
            "name": "test-name"
          ]
          
          result = TegFacebookUser.parse(dictionary, accessToken: nil)
          user = result.value
        }
        
        it("should return no user") {
          expect(user).to(beNil())
        }
        
        it("should return parsing error") {
          let error: TegFacebookUserLoaderError = result.error!
          expect(error) == TegFacebookUserLoaderError.AccessToken
        }
      }
    }
  }
}
