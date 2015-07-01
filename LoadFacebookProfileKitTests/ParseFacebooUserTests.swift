import Foundation
import XCTest
@testable import LoadFacebookProfileKit

class FacebookUserParserTests: XCTestCase {
  var dictionary: [String: AnyObject]!
  
  override func setUp() {
    super.setUp()
  }
  
  func testParse() {
    dictionary = [
      "id": "test-id",
      "email": "test-email",
      "first_name": "test-first-name",
      "last_name": "test-last-name",
      "name": "test-name"
    ]
    
    let result = FacebookUserLoader.parseMeData(dictionary, accessToken: "test-access-token")!
    XCTAssertEqual("test-id", result.id)
    XCTAssertEqual("test-access-token", result.accessToken)
    XCTAssertEqual("test-email", result.email!)
    XCTAssertEqual("test-first-name", result.firstName!)
    XCTAssertEqual("test-last-name", result.lastName!)
    XCTAssertEqual("test-name", result.name!)
  }
  
  func testParse_withMissingOptionalFields() {
    dictionary = [
      "id": "test-id"
    ]
    
    let result = FacebookUserLoader.parseMeData(dictionary, accessToken: "test-access-token")!
    XCTAssertEqual("test-id", result.id)
    XCTAssertEqual("test-access-token", result.accessToken)
    XCTAssert(result.email == nil)
    XCTAssert(result.firstName == nil)
    XCTAssert(result.lastName == nil)
    XCTAssert(result.name == nil)
  }
  
  func testParseWhenIdIsNotFound() {
    dictionary = [
      "email": "test-email",
      "first_name": "test-first-name",
      "last_name": "test-last-name",
      "name": "test-name"
    ]
    
    let result = FacebookUserLoader.parseMeData(dictionary, accessToken: "test-access-token")
    XCTAssert(result == nil)
  }
}