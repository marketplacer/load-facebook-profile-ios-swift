//
//  ViewController.swift
//  LoginWithFacebookSDKCustom
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
    
    FBSession.activeSession().closeAndClearTokenInformation()
    
    FBSession.openActiveSessionWithReadPermissions(["public_profile"],
      allowLoginUI: true) { session, state, error in

      self.sessionStateChanged(session, state: state, error: error)
    }
  }
  
  private func showUserInfo(session: FBSession) {
    if let currentAccessToken = session.accessTokenData {
      let acessToken = currentAccessToken.accessToken
      
      FBRequestConnection.startForMeWithCompletionHandler { connection, result, error in
        if error != nil { return }
        if let currentResult = result as? NSDictionary {
          if let userId = result["id"] as? String {
            self.userInfoLabel.text = "\(rand()) User ID: \(userId) \n\nAccess token: \(acessToken)"
          }
        }
      }
      
    }
    
    // Note: to verify user id send this request from your server
    // https://graph.facebook.com/me?fields=id&access_token=YOUR_ACCCESS_TOKEN
  }
  
  private func sessionStateChanged(session: FBSession, state: FBSessionState, error: NSError?) {
    if error != nil { return }
    
    showUserInfo(session)
  }
}

