import Foundation

/**

User profile information returned by the Facebook. Note that it can only guarantee to return id and accessToken fields. All other fields may be empty.

*/
public struct TegFacebookUser {
  public let id: String
  public let accessToken: String
  public let email: String?
  public let firstName: String?
  public let lastName: String?
  public let name: String?
  
  public init(id: String, accessToken: String, email: String?, firstName: String?,
    lastName: String?, name: String?) {
    
    self.id = id
    self.accessToken = accessToken
    self.email = email
    self.firstName = firstName
    self.lastName = lastName
    self.name = name
  }
}