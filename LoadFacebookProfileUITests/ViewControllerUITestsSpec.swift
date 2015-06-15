import Foundation
import Quick
import Nimble
import XCTest

class ViewControllerUITestsSpec: QuickSpec {
  override func spec() {
    
    beforeSuite {
      // In UI tests it is usually best to stop immediately when a failure occurs.
      self.continueAfterFailure = false
      
      let app = XCUIApplication()
      app.launchEnvironment["RUNNING_UI_TESTS"] = "YES"
      app.launch()
    }
    
    describe("Login") {
      it("Should successfully login") {
        // Tap on login button
        let app = XCUIApplication()
        app.buttons["Login with Facebook"].tap()
        
        // Check if logged in
        let userText = app.staticTexts.matchingPredicate(NSPredicate(format: "label CONTAINS 'fake-user-id' AND label CONTAINS 'fake-access-token'")).element
        expect(userText.exists).toEventually(beTrue())
      }
    }
  }
}
