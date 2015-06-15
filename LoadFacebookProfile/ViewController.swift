import UIKit
import BrightFutures
import LoadFacebookProfileKit

class ViewController: UIViewController {
  @IBOutlet weak var loginLogoutButton: UIButton!
  @IBOutlet weak var userInfoLabel: UILabel!
  
  private let loader: FacebookUserLoader
  
  var token: InvalidationToken
  
  required init(coder aDecoder: NSCoder) {
    loader = FacebookUserLoaderFactory.userLoader
    token = InvalidationToken()
    
    super.init(coder: aDecoder)
  }
  
  deinit {
    token.invalidate()
  }
  
  override func viewDidLoad() {
    super.viewDidLoad()
    userInfoLabel.text = ""
  }
  
  @IBAction func onLoginWithFacebookButtonTapped(sender: AnyObject) {
    userInfoLabel.text = ""
    
    token.invalidate()
    token = InvalidationToken()
    
    loader.loadE(askEmail: true)
      .onSuccess(token: token) { [weak self] user in
        self?.onUserLoaded(user)
      }.onFailure(token: token) { [weak self] error in
        self?.userInfoLabel.text = error.localizedDescription
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
    
    let outputText = "\n\n".join(fields)
    
    userInfoLabel.text = outputText
    print(outputText)
  }
}

