//
//  EventCellNode.swift
//  Lemon
//
//  Created by X140Yu on 18/6/2017.
//  Copyright © 2017 X140Yu <zhaoxinyu1994@gmail.com>. All rights reserved.
//

import UIKit
import AsyncDisplayKit
import PINRemoteImage
import RxSwift
import RxCocoa

class EventCellNode: ASCellNode {
  let eventLabel = ASTextNode()
  let timeLabel = ASTextNode()
  let avatar = ASNetworkImageNode()
  let iconNode = ASImageNode()
  let viewModel: EventCellViewModel
  public let bag = DisposeBag()
  
  override func didLoad() {
    layer.as_allowsHighlightDrawing = true
    super.didLoad()
  }
  
  init(viewModel: EventCellViewModel) {
    self.viewModel = viewModel
    super.init()

    eventLabel.linkAttributeNames = [viewModel.linkAttributeName]
    eventLabel.attributedText = viewModel.eventAttributedString
    timeLabel.attributedText = viewModel.dateAttributedString
    iconNode.image = viewModel.iconImage
    if let avatarURL = viewModel.avatarURL {
      avatar.url = avatarURL
    }
    avatar.addTarget(self, action: #selector(handleAvatarTouched), forControlEvents: .touchUpInside)

    eventLabel.delegate = self
    eventLabel.isUserInteractionEnabled = true
    eventLabel.passthroughNonlinkTouches = true
    timeLabel.maximumNumberOfLines = 1
    eventLabel.maximumNumberOfLines = 10

    addSubnode(eventLabel)
    addSubnode(timeLabel)
    addSubnode(avatar)
    addSubnode(iconNode)
  }

  override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    avatar.style.preferredSize = CGSize(width: 50, height: 50)
    eventLabel.style.maxWidth = ASDimensionMake(300)
    eventLabel.style.flexGrow = 1.0
    // corner radius
    avatar.imageModificationBlock = { $0.lm_cornerRadiused() }

    let icon = ASInsetLayoutSpec(insets: UIEdgeInsets.init(top: 5, left: .infinity, bottom: .infinity, right: 5) , child: iconNode)

    let time = ASStackLayoutSpec(direction: .horizontal, spacing: 0, justifyContent: .end, alignItems: .stretch, children: [timeLabel])

    let spec = ASStackLayoutSpec(direction: .vertical, spacing: 10, justifyContent: .start, alignItems: .stretch, children: [eventLabel, time])
    spec.style.flexGrow = 1.0

    let all = ASStackLayoutSpec(direction: .horizontal, spacing: 10, justifyContent: .start, alignItems: .stretch, children: [avatar, spec])

    let inset =  ASInsetLayoutSpec(insets: UIEdgeInsetsMake(10, 10, 10, 10), child: all)
    return ASOverlayLayoutSpec(child: inset, overlay: icon)
  }


  func handleAvatarTouched() {
    if let u = viewModel.event.actor?.url {
      viewModel.inputs.didTapLink.onNext(URL(string: u))
    }
  }

}

extension EventCellNode: ASTextNodeDelegate {
  func textNode(_ textNode: ASTextNode, shouldHighlightLinkAttribute attribute: String, value: Any, at point: CGPoint) -> Bool {
    return true
  }

  func textNode(_ textNode: ASTextNode, tappedLinkAttribute attribute: String, value: Any, at point: CGPoint, textRange: NSRange) {
    viewModel.inputs.didTapLink.onNext(value as? URL)
  }
}
