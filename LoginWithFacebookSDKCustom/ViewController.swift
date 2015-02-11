//
//  ViewController.swift
//  LoginWithFacebookSDKCustom
//
//  Created by Evgenii Neumerzhitckii on 11/02/2015.
//  Copyright (c) 2015 The Exchange Group Pty Ltd. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  override func viewDidLoad() {
    super.viewDidLoad()
  }

  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }


  @IBAction func onLoginWithFacebookButtonTapped(sender: AnyObject) {

    if (FBSession.activeSession().state == FBSessionState.Open
      || FBSession.activeSession().state == FBSessionState.OpenTokenExtended) {

      // Logout
      FBSession.activeSession().closeAndClearTokenInformation()
      println("closeAndClearTokenInformation")
    } else {
      FBSession.openActiveSessionWithReadPermissions(["public_profile"],
        allowLoginUI: true) { session, state, error in

        println("openActiveSessionWithReadPermissions callback")
      }
    }
  }
}

