import UIKit
import LoadFacebookProfileKit

class ViewController: UIViewController {
  @IBOutlet weak var loginLogoutButton: UIButton!
  @IBOutlet weak var userInfoLabel: UILabel!
  
  private let loader = FacebookUserLoader()
  
  required init(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    stubUserForUITests()
    
    userInfoLabel.text = ""
  }
  
  @IBAction func onLoginWithFacebookButtonTapped(sender: AnyObject) {
    userInfoLabel.text = ""
  
    loader.load(askEmail: true, onError: { [weak self] in
      self?.userInfoLabel.text = "Error occured"
    },
    onSuccess: { [weak self] user in
      self?.onUserLoaded(user)
    })
  }
  
  private func onUserLoaded(user: TegFacebookUser) {
    var fields = ["User id: \(user.id)"]
    
    if let name = user.name {
      fields.append("Name: \(name)")
    }
    
    if let email = user.email {
      fields.append("Email: \(email)")
    }
    
    fields.append("Access token: \(user.accessToken)")
    
    let outputText = "\n\n".join(fields)
    
    userInfoLabel.text = outputText
    print(outputText)
  }
  
  private func stubUserForUITests() {
    if ViewController.isUITesting() {
      FacebookUserLoader.simulateSuccessUser = TegFacebookUser(id: "fake-user-id",
        accessToken: "fake-access-token",
        email: nil,
        firstName: nil,
        lastName: nil,
        name: nil)
    }
  }
  
  private class func isUITesting() -> Bool {
    let environment = NSProcessInfo.processInfo().environment
    let runningUITests =  environment["RUNNING_UI_TESTS"]
    return runningUITests == "YES"
  }
}

