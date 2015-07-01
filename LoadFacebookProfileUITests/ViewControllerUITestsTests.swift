import Foundation
import XCTest

class ViewControllerUITestsTests: XCTestCase {
  func testAuthenticateWithFacebook() {
    self.continueAfterFailure = false
    
    if #available(iOS 9.0, *) {
      let app = XCUIApplication()
      app.launchEnvironment["RUNNING_UI_TESTS"] = "YES"
      app.launch()
      
      // Tap on login button
      app.buttons["Login with Facebook"].tap()
      
      // Check if logged in
      let predicate = NSPredicate(format: "label CONTAINS 'fake-user-id' AND label CONTAINS 'fake-access-token'")
      let userText = app.staticTexts.matchingPredicate(predicate).element
      
      XCTAssert(userText.exists)
    }
  }
}
