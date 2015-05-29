import Foundation
import BrightFutures
import Result
import Box

public struct TegFacebookUser {
  public let id: String
  public let accessToken: String
  public let email: String?
  public let firstName: String?
  public let lastName: String?
  public let name: String?
  
  public init(id: String, accessToken: String, email: String?, firstName: String?, lastName: String?, name: String?) {
    self.id = id
    self.accessToken = accessToken
    self.email = email
    self.firstName = firstName
    self.lastName = lastName
    self.name = name
  }
}

extension TegFacebookUser {
  public static func parse(dictionary: [String: AnyObject], accessToken: String?) -> Result<TegFacebookUser, TegFacebookUserLoaderError> {
    if let accessToken = accessToken, let user = parseFromMeData(dictionary, accessToken: accessToken) {
      return .Success(Box(user))
    }
    
    return .Failure(Box(.Parsing))
  }
  
  private static func parseFromMeData(dictionary: [String: AnyObject], accessToken: String) -> TegFacebookUser? {
    if let id = dictionary["id"] as? String {
      return TegFacebookUser(
        id: id,
        accessToken: accessToken,
        email: dictionary["email"] as? String,
        firstName: dictionary["first_name"] as? String,
        lastName: dictionary["last_name"] as? String,
        name: dictionary["name"] as? String)
    }
    
    return nil
  }
}