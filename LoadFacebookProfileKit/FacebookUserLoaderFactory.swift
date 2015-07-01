import Foundation

/**

Returns a Facebook loader instance. The purpose of this class is to return the real Facebook loader instance in the app and a fake one in UI tests.

*/
public class FacebookUserLoaderFactory {
  public class var userLoader: FacebookUserLoader {
    if isUITesting() {
      return FakeUITestsFacebookUserLoader()
    } else {
      return TegFacebookUserLoader()
    }
  }
  
  private class func isUITesting() -> Bool {
    let environment = NSProcessInfo.processInfo().environment
    let runningUITests =  environment["RUNNING_UI_TESTS"]
    return runningUITests == "YES"
  }
}