import AsyncDisplayKit
import UIKit

/// copied from Texture Swift demo
final class TailLoadingCellNode: ASCellNode {
  let spinner = SpinnerNode()
  let text = ASTextNode()

  override init() {
    super.init()

    addSubnode(text)
    text.attributedText = NSAttributedString(
      string: "Loading…",
      attributes: [
        NSAttributedStringKey.font: UIFont.systemFont(ofSize: 12),
        NSAttributedStringKey.foregroundColor: UIColor.lightGray,
        NSAttributedStringKey.kern: -0.3
      ])
    addSubnode(spinner)
  }

  override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {

    return ASStackLayoutSpec(
      direction: .horizontal,
      spacing: 16,
      justifyContent: .center,
      alignItems: .center,
      children: [ text, spinner ])
  }
}

final class SpinnerNode: ASDisplayNode {
  var activityIndicatorView: UIActivityIndicatorView {
    return view as! UIActivityIndicatorView
  }

  override init() {
    super.init()
    setViewBlock {
      UIActivityIndicatorView(activityIndicatorStyle: .gray)
    }

    // Set spinner node to default size of the activitiy indicator view
    self.style.preferredSize = CGSize(width: 20.0, height: 20.0)
  }

  override func didLoad() {
    super.didLoad()

    activityIndicatorView.startAnimating()
  }
}
