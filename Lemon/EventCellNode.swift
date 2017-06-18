//
//  EventCellNode.swift
//  Lemon
//
//  Created by X140Yu on 18/6/2017.
//  Copyright © 2017 X140Yu. All rights reserved.
//

import UIKit
import AsyncDisplayKit
import PINRemoteImage

let linkAttributeName = "com.lemon.ios.linkAttributeName"

class EventCellNode: ASCellNode {
  var eventLabel = ASTextNode()
  var timeLabel = ASTextNode()
  var avatar = ASNetworkImageNode()
  
  override func didLoad() {
    layer.as_allowsHighlightDrawing = true
    super.didLoad()
  }
  
  init(event: Event) {
    super.init()
    
    let attrString = NSMutableAttributedString()
    
    if let eventType = event.eventType {
      switch eventType {
      case .WatchEvent(let action):
        if let userName = event.actor?.login, let userURL = event.actor?.url {
          let userNameAttrString = NSAttributedString(string: userName,
                                                      attributes:
            [
              NSForegroundColorAttributeName: UIColor.lmGithubBlue,
              NSFontAttributeName: UIFont(name: "Menlo-Regular", size: 17)!,
              linkAttributeName: URL(string: userURL)!
            ])
          attrString.append(userNameAttrString)
        }
        let actionAttrString = NSAttributedString(string: " " + action + "\n", attributes:
          [
            NSForegroundColorAttributeName: UIColor.lmDarkGrey,
            NSFontAttributeName: UIFont(name: "Menlo-Regular", size: 17)!
          ]
        )
        attrString.append(actionAttrString)
        if let repo = event.repo?.name, let repoURL = event.repo?.url {
          let repoAttrString = NSAttributedString(string: repo, attributes:
            [
              NSForegroundColorAttributeName: UIColor.lmGithubBlue,
              NSFontAttributeName: UIFont(name: "Menlo-Regular", size: 17)!,
              linkAttributeName: URL(string: repoURL)!
            ])
          attrString.append(repoAttrString)
        }
        break
      default: break
      }
    }
    eventLabel.delegate = self
    eventLabel.isUserInteractionEnabled = true
    eventLabel.linkAttributeNames = [linkAttributeName]
    let paraStyle = NSMutableParagraphStyle()
    paraStyle.lineSpacing = 3
    attrString.addAttributes(
      [
        NSParagraphStyleAttributeName: paraStyle
      ], range: NSRange(location: 0, length: attrString.length))
    eventLabel.attributedText = attrString
    eventLabel.passthroughNonlinkTouches = true
    
    timeLabel.maximumNumberOfLines = 1
    eventLabel.maximumNumberOfLines = 10

    if let date = event.createdAt {
      let dateAttrString = NSAttributedString(string: date.lm_ago(), attributes:
        [
          NSForegroundColorAttributeName: UIColor.lmLightGrey,
          NSFontAttributeName: UIFont(name: "Menlo-Regular", size: 14)!
        ])
      timeLabel.attributedText = dateAttrString
    }

    if let u = event.actor?.avatarUrl {
      avatar.url = URL(string: u)
    }
    
    addSubnode(eventLabel)
    addSubnode(timeLabel)
    addSubnode(avatar)
  }

  override func layoutSpecThatFits(_ constrainedSize: ASSizeRange) -> ASLayoutSpec {
    avatar.style.preferredSize = CGSize(width: 50, height: 50)
    eventLabel.style.maxWidth = ASDimensionMake(300)
    eventLabel.style.flexGrow = 1.0
    // corner radius
    avatar.imageModificationBlock = { image in
      let rect = CGRect(origin: .zero, size: image.size)
      UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.main.scale)
      UIGraphicsGetCurrentContext()?.addPath(UIBezierPath(roundedRect: rect, byRoundingCorners: UIRectCorner.allCorners,
                                    cornerRadii: CGSize(width: 50, height: 50)).cgPath)
      UIGraphicsGetCurrentContext()?.clip()
      image.draw(in: rect)
      UIGraphicsGetCurrentContext()!.drawPath(using: .fillStroke)
      let output = UIGraphicsGetImageFromCurrentImageContext();
      UIGraphicsEndImageContext();
      
      return output
    }

    let time = ASStackLayoutSpec(direction: .horizontal, spacing: 0, justifyContent: .end, alignItems: .stretch, children: [timeLabel])

    let spec = ASStackLayoutSpec(direction: .vertical, spacing: 10, justifyContent: .start, alignItems: .stretch, children: [eventLabel, time])
    spec.style.flexGrow = 1.0

    let all = ASStackLayoutSpec(direction: .horizontal, spacing: 10, justifyContent: .start, alignItems: .stretch, children: [avatar, spec])

    return ASInsetLayoutSpec(insets: UIEdgeInsetsMake(10, 10, 10, 10), child: all)
  }

}

extension EventCellNode: ASTextNodeDelegate {
  func textNode(_ textNode: ASTextNode, shouldHighlightLinkAttribute attribute: String, value: Any, at point: CGPoint) -> Bool {
    return true
  }
  
  func textNode(_ textNode: ASTextNode, tappedLinkAttribute attribute: String, value: Any, at point: CGPoint, textRange: NSRange) {
    UIApplication.shared.open(value as! URL)
  }
}
