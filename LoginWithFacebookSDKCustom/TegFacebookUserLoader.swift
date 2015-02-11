//
//  TegFacebookProfileLoader.swift
//  LoginWithFacebookSDKCustom
//
//  Created by Evgenii Neumerzhitckii on 11/02/2015.
//  Copyright (c) 2015 The Exchange Group Pty Ltd. All rights reserved.
//

import Foundation

class TegFacebookUserLoader {
  
  class func load(
    #askEmail: Bool,
    onSuccess: (TegFacebookUser)->()) {
      
    logOut()
    logInAndLoadUserProfile(askEmail, onSuccess: onSuccess)
  }
  
  private class func logInAndLoadUserProfile(
    askEmail: Bool,
    onSuccess: (TegFacebookUser)->()) {
      
    var permissions = ["public_profile"]
      
    if askEmail {
      permissions.append("email")
    }
      
    FBSession.openActiveSessionWithReadPermissions(permissions,
      allowLoginUI: true) { session, state, error in
      
      if error != nil { return }
      
      self.loadFacebookMeInfo(onSuccess)
    }
  }
  
  private class func logOut() {
    if let currentSession = FBSession.activeSession() {
      currentSession.closeAndClearTokenInformation()
    }
  }
  
  private class func loadFacebookMeInfo(onSuccess: (TegFacebookUser) -> ()) {
      
    FBRequestConnection.startForMeWithCompletionHandler { connection, result, error in
      if error != nil { return }
      
      if let currentUserData = result as? NSDictionary {
        if let currentUser = self.parseMeData(currentUserData) {
          onSuccess(currentUser)
        }
      }
    }
  }
  
  private class func parseMeData(data: NSDictionary) -> TegFacebookUser? {
    if let currentId = data["id"] as? String {
      if let currenToken = accessToken {
        return TegFacebookUser(
          id: currentId,
          accessToken: currenToken,
          email: data["email"] as? String,
          firstName: data["first_name"] as? String,
          lastName: data["last_name"] as? String,
          name: data["name"] as? String)
      }
    }
    
    return nil
  }
  
  private class var accessToken: String? {
    if let currentSession = FBSession.activeSession() {
      if let currentAccessToken = currentSession.accessTokenData {
        return currentAccessToken.accessToken
      }
    }
    
    return nil
  }
}
