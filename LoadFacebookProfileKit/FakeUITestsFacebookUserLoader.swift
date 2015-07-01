/**

This user loader is used instead of the real one in UI tests.

*/
class FakeUITestsFacebookUserLoader: FacebookUserLoader {
  func load(askEmail askEmail: Bool, onError: ()->(), onSuccess: (TegFacebookUser)->()) {
    
    let fakeUser = TegFacebookUser(id: "fake-user-id",
      accessToken: "fake-access-token",
      email: nil,
      firstName: nil,
      lastName: nil,
      name: nil)
    
    onSuccess(fakeUser)
  }
}