import UIKit
import AsyncDisplayKit
import PINRemoteImage
import RxSwift
import RxCocoa

class UserCellNode: ASCellNode {
  let avatar = ASNetworkImageNode()
  let loginLabel = ASTextNode()

  override func didLoad() {
    layer.as_allowsHighlightDrawing = true
    super.didLoad()
  }

  init(user: User) {
    super.init()

    guard let login = user.login else { return }
    loginLabel.attributedText = NSAttributedString(string: login, attributes: [NSAttributedStringKey.foregroundColor : UIColor.darkGray, NSAttributedStringKey.font : UIFont.systemFont(ofSize: 15)])
    avatar.url = user.avatarUrl?.lm_url

    loginLabel.passthroughNonlinkTouches = true
    addSubnode(avatar)
    addSubnode(loginLabel)
  }

  override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    avatar.style.preferredSize = CGSize(width: 40, height: 40)
    avatar.imageModificationBlock = { $0.lm_cornerRadiused(8) }

    let all = ASStackLayoutSpec(direction: .horizontal, spacing: 10, justifyContent: .start, alignItems: .stretch, children: [avatar, loginLabel])

    return ASInsetLayoutSpec(insets: UIEdgeInsetsMake(10, 10, 10, 10), child: all)
  }

}
