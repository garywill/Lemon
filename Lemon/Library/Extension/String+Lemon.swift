import UIKit

// MARK: - URL

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

// MARK: - Attributes

extension String {
  var lm_cellTitleAttribute: NSAttributedString {
    return NSAttributedString(string: self, attributes: [
      NSAttributedStringKey.foregroundColor: UIColor.lmGithubBlue,
      NSAttributedStringKey.font: UIFont.lemonMono(size: 17),
      ])
  }
}
