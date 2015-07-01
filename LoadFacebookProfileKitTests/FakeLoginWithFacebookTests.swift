import Foundation
import XCTest
@testable import LoadFacebookProfileKit

class FakeLoginWithFacebookTests: XCTestCase {
  var dictionary: [String: AnyObject]!
  
  override func setUp() {
    super.setUp()
  }
  
  override func tearDown() {
    super.tearDown()
    FacebookUserLoader.simulateLoadAfterDelay = 0.1
    FacebookUserLoader.simulateSuccessUser = nil
    FacebookUserLoader.simulateError = false
  }
  
  func testLoadUser() {
    FacebookUserLoader.simulateSuccessUser = TegFacebookUser(id: "fake user id",
      accessToken: "test access tokeb",
      email: "test@email.com",
      firstName: "test first name",
      lastName: "test last name",
      name: "test name"
    )
    
    let loader = FacebookUserLoader()
    
    var errorReturned = false
    var userReturned: TegFacebookUser?
    
    let expectation = expectationWithDescription("load facebook profile")
    
    loader.load(askEmail: true, onError: {
        errorReturned = true
      },
      onSuccess: { user in
        expectation.fulfill()
        userReturned = user
      }
    )
    
    waitForExpectationsWithTimeout(1) { error in }
    
    XCTAssertFalse(errorReturned)
    XCTAssertEqual("test@email.com", userReturned!.email!)
  }
  
  func testLoadUser_synchronously() {
    FacebookUserLoader.simulateSuccessUser = TegFacebookUser(id: "fake user id",
      accessToken: "test access tokeb",
      email: "test@email.com",
      firstName: "test first name",
      lastName: "test last name",
      name: "test name"
    )
    
    FacebookUserLoader.simulateLoadAfterDelay = 0
    
    let loader = FacebookUserLoader()
    
    var errorReturned = false
    var userReturned: TegFacebookUser?
    
    
    
    loader.load(askEmail: true, onError: {
      errorReturned = true
      },
      onSuccess: { user in
        userReturned = user
      }
    )
    
    XCTAssertFalse(errorReturned)
    XCTAssertEqual("test@email.com", userReturned!.email!)
  }
  
  func testLoadUser_returnError() {
    FacebookUserLoader.simulateError = true
    
    let loader = FacebookUserLoader()
    
    var errorReturned = false
    var userReturned: TegFacebookUser?
    
    let expectation = expectationWithDescription("load facebook profile")
    
    loader.load(askEmail: true, onError: {
        errorReturned = true
        expectation.fulfill()
      },
      onSuccess: { user in
        userReturned = user
      }
    )
    
    waitForExpectationsWithTimeout(1) { error in }
    
    XCTAssert(errorReturned)
    XCTAssert(userReturned == nil)
  }
  
  func testLoadUser_returnErrorSynchronously() {
    FacebookUserLoader.simulateError = true
    FacebookUserLoader.simulateLoadAfterDelay = 0
    
    let loader = FacebookUserLoader()
    
    var errorReturned = false
    var userReturned: TegFacebookUser?
    
    
    loader.load(askEmail: true, onError: {
        errorReturned = true
      },
      onSuccess: { user in
        userReturned = user
      }
    )
    
    XCTAssert(errorReturned)
    XCTAssert(userReturned == nil)
  }

}