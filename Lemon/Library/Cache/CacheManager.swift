import Foundation

private struct CacheKeys {
  static let TokenKey = "com.x140yu.lemon.CacheKeys.TokenKey"
  static let UsernameKey = "com.x140yu.lemon.CacheKeys.UsernameKey"
}

class CacheManager {
  
  class var cachedToken: String? {
    get {
      return UserDefaults.standard.string(forKey: CacheKeys.TokenKey)
    }
    set {
      UserDefaults.standard.set(newValue, forKey: CacheKeys.TokenKey)
    }
  }
  
  class var cachedUsername: String? {
    get {
      return UserDefaults.standard.string(forKey: CacheKeys.UsernameKey)
    }
    set {
      UserDefaults.standard.set(newValue, forKey: CacheKeys.UsernameKey)
    }
  }
}
