import Quick
import Nimble
import LoadFacebookProfile
import KIFFramework

class ViewControllerKIFSpec: QuickSpec {
  override func spec() {
    describe("Login") {
      it("Should successfully login") {
        // MARK: - Tap on login button
        self.tester().tapViewWithAccessibilityLabel("Login with Facebook")
        
        // MARK: - Check if logged in
        self.tester().waitForViewWithAccessibilityLabel("User id: fake-user-id\n\nAccess token: fake-access-token")
      }
    }
  }
}
