//
//  Created by Evgenii Neumerzhitckii on 11/02/2015.
//  Copyright (c) 2015 The Exchange Group Pty Ltd. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
  @IBOutlet weak var loginLogoutButton: UIButton!
  @IBOutlet weak var userInfoLabel: UILabel!

  override func viewDidLoad() {
    super.viewDidLoad()
    userInfoLabel.text = ""
  }

  @IBAction func onLoginWithFacebookButtonTapped(sender: AnyObject) {
    userInfoLabel.text = ""
    
    TegFacebookUserLoader.load(askEmail: false) { user in
      self.onUserLoaded(user)
    }
  }
  
  private func onUserLoaded(user: TegFacebookUser) {
    var userName = ""
      
    if let currentName = user.name {
      userName = "User: \(currentName)\n"
    }
    
    userInfoLabel.text = "\(userName)User ID: \(user.id) \n\nAccess token: \(user.accessToken)"
  }
}

