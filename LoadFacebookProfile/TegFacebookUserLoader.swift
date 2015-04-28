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
      if state == FBSessionState.Closed { return }
      
      self.loadFacebookMeInfo(onSuccess)
    }
  }
  
  private class func logOut() {
    FBSession.activeSession()?.closeAndClearTokenInformation()
  }
  
  private class func loadFacebookMeInfo(onSuccess: (TegFacebookUser) -> ()) {
      
    FBRequestConnection.startForMeWithCompletionHandler { connection, result, error in
      if error != nil { return }
      
      if let userData = result as? NSDictionary,
        let user = self.parseMeData(userData) {
        
        onSuccess(user)
      }
    }
  }
  
  private class func parseMeData(data: NSDictionary) -> TegFacebookUser? {
    if let id = data["id"] as? String,
      let accessToken = accessToken {

      return TegFacebookUser(
        id: id,
        accessToken: accessToken,
        email: data["email"] as? String,
        firstName: data["first_name"] as? String,
        lastName: data["last_name"] as? String,
        name: data["name"] as? String)
    }
    
    return nil
  }
  
  private class var accessToken: String? {
    return FBSession.activeSession()?.accessTokenData?.accessToken
  }
}
