import Foundation

extension String {
  var lm_url: URL? {
    return URL(string: self)
  }
}

extension Optional where Wrapped == String {
  var lm_url: URL? {
    guard let urlStirng = self else { return nil }
    return URL(string: urlStirng)
  }
}
