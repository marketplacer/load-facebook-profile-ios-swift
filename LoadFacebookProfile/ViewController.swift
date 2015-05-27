import UIKit

class ViewController: UIViewController {
  @IBOutlet weak var loginLogoutButton: UIButton!
  @IBOutlet weak var userInfoLabel: UILabel!
  
  private let loader: TegFacebookUserLoader
  
  required init(coder aDecoder: NSCoder) {
    loader = TegFacebookUserLoader()
    
    super.init(coder: aDecoder)
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    userInfoLabel.text = ""
  }
  
  @IBAction func onLoginWithFacebookButtonTapped(sender: AnyObject) {
    userInfoLabel.text = ""
    
    loader.load(askEmail: true) { user in
      self.onUserLoaded(user)
    }
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
    
    let outputText = join("\n\n", fields)
    
    userInfoLabel.text = outputText
    println(outputText)
  }
}

