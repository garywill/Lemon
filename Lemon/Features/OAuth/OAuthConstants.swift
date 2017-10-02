import Foundation

struct OAuthConstants {
  static let URL = "https://github.com/login/oauth/authorize?scope=user%20repo&client_id=\(OAuthConstants.ClientID)"
  static let AccessTokenRequestURL = "https://github.com/login/oauth/access_token"
  static let ClientID = "fafead0655da8da976db"
  static let ClientSecret = "a72a6925fbbd69369b4c836a7e19429b89894803"
  static let CallbackURLPrefix = "lemon://oauth/github?code="
  
  /// post when get callback url from GitHub. object: callbackURL(URL)
  static let OAuthCallbackNotificationName = Notification.Name(rawValue: "com.x140yu.lemon.OAuthSuccessNotificationName")
  
  static func accessTokenParamDiction(_ code: String) -> [String: String] {
    return [
      "code": code,
      "client_id": ClientID,
      "client_secret": ClientSecret
    ]
  }
}
