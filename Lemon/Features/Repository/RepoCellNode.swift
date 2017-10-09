import UIKit
import RxSwift
import RxCocoa
import AsyncDisplayKit

class RepoCellNode: ASCellNode {
  let nameLabel = ASTextNode()
  let desctionLabel = ASTextNode()
  let ownerAvatar = ASNetworkImageNode()
  let ownerNameLabel = ASTextNode()
  let langLabel = ASTextNode()
  let starsCountLabel = ASTextNode()


  override func didLoad() {
    layer.as_allowsHighlightDrawing = true
    super.didLoad()
  }

  init(repo: Repository) {
    super.init()
    nameLabel.attributedText = NSAttributedString(string: repo.name ?? "", attributes: [NSAttributedStringKey.foregroundColor : UIColor.darkGray, NSAttributedStringKey.font : UIFont.systemFont(ofSize: 15)])

    desctionLabel.attributedText = NSAttributedString(string: repo.descriptionField, attributes: [NSAttributedStringKey.foregroundColor : UIColor.darkGray, NSAttributedStringKey.font : UIFont.systemFont(ofSize: 15)])

    addSubnode(ownerAvatar)
    addSubnode(desctionLabel)
    addSubnode(nameLabel)
  }

  override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    ownerAvatar.style.preferredSize = CGSize(width: 8, height: 8)
    ownerAvatar.imageModificationBlock = { $0.lm_cornerRadiused(2) }

    let vertical = ASStackLayoutSpec(direction: .vertical, spacing: 10, justifyContent: .start, alignItems: .stretch, children: [nameLabel, desctionLabel])

//    let all = ASStackLayoutSpec(direction: .horizontal, spacing: 10, justifyContent: .start, alignItems: .stretch, children: [ownerAvatar, nameLabel])

    return ASInsetLayoutSpec(insets: UIEdgeInsetsMake(10, 10, 10, 10), child: vertical)
  }

}
