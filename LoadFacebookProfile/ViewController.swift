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
    
    TegFacebookUserLoader.load(askEmail: true) { user in
      self.onUserLoaded(user)
    }
  }
  
  private func onUserLoaded(user: TegFacebookUser) {
    var fields = ["User id: \(user.id)"]

    if let currentName = user.name {
      fields.append("Name: \(currentName)")
    }
    
    if let currentEmail = user.email {
      fields.append("Email: \(currentEmail)")
    }
    
    fields.append("Access token: \(user.accessToken)")
    
    userInfoLabel.text = join("\n\n", fields)
  }
}

