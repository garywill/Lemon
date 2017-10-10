import UIKit
import RxSwift
import RxCocoa
import AsyncDisplayKit

class RepoCellNode: ASCellNode {
  let nameLabel = ASTextNode()
  let desctionLabel = ASTextNode()
  let ownerAvatar = ASNetworkImageNode()
  let ownerNameLabel = ASTextNode()
  let langImage = ASImageNode()
  let langLabel = ASTextNode()
  let starsCountLabel = ASTextNode()
  let iconNode = ASImageNode()

  override func didLoad() {
    layer.as_allowsHighlightDrawing = true
    super.didLoad()
  }

  init(repo: Repository) {
    super.init()
    nameLabel.attributedText = (repo.name ?? "").lm_cellTitleAttribute

    desctionLabel.attributedText = NSAttributedString(string: repo.descriptionField, attributes: [NSAttributedStringKey.foregroundColor : UIColor.darkGray, NSAttributedStringKey.font : UIFont.systemFont(ofSize: 15)])

    starsCountLabel.attributedText = NSAttributedString(string: "⭐️ 1.4k · 🍴 200", attributes: [NSAttributedStringKey.foregroundColor : UIColor.darkGray, NSAttributedStringKey.font : UIFont.systemFont(ofSize: 15)])

    ownerNameLabel.attributedText = NSAttributedString(string: repo.owner?.name ?? "", attributes: [NSAttributedStringKey.foregroundColor : UIColor.darkGray, NSAttributedStringKey.font : UIFont.systemFont(ofSize: 15)])

    langLabel.attributedText = NSAttributedString(string: repo.language, attributes: [NSAttributedStringKey.foregroundColor : UIColor.darkGray, NSAttributedStringKey.font : UIFont.systemFont(ofSize: 15)])

    addSubnode(ownerAvatar)
    addSubnode(ownerNameLabel)
    addSubnode(desctionLabel)
    addSubnode(nameLabel)
    addSubnode(starsCountLabel)
    addSubnode(langImage)
    addSubnode(langLabel)
    addSubnode(iconNode)
  }

  override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    ownerAvatar.style.preferredSize = CGSize(width: 16, height: 16)
    ownerAvatar.imageModificationBlock = { $0.lm_cornerRadiused(4) }
    ownerAvatar.image = UIColor.lightGray.image(size: CGSize(width: 16, height: 16))

    langImage.style.preferredSize = CGSize(width: 16, height: 16)
    langImage.image = UIColor.orange.image(size: CGSize(width: 16, height: 16))
    langImage.imageModificationBlock = { $0.lm_cornerRadiused() }

    iconNode.image = #imageLiteral(resourceName: "event_star")

    let icon = ASInsetLayoutSpec(insets: UIEdgeInsets.init(top: 0, left: .infinity, bottom: .infinity, right: 0) , child: iconNode)

    let bottomLeftStack = ASStackLayoutSpec(direction: .horizontal, spacing: 10, justifyContent: .end, alignItems: .stretch, children: [ownerAvatar, ownerNameLabel, langImage, langLabel])

    let bottomStack = ASStackLayoutSpec(direction: .horizontal, spacing: 10, justifyContent: .spaceBetween, alignItems: .stretch, children: [starsCountLabel, bottomLeftStack])

    let vertical = ASStackLayoutSpec(direction: .vertical, spacing: 10, justifyContent: .start, alignItems: .stretch, children: [nameLabel, desctionLabel, bottomStack])

    let overlay = ASOverlayLayoutSpec(child: vertical, overlay: icon)

    return ASInsetLayoutSpec(insets: UIEdgeInsetsMake(10, 10, 10, 10), child: overlay)
  }

}
