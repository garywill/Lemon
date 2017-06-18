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

class EventCellNode: ASCellNode {
  var eventLabel = ASTextNode()
  var timeLabel = ASTextNode()
  var avatar = ASNetworkImageNode()
  
  init(event: Event) {
    super.init()
    
    timeLabel.maximumNumberOfLines = 1
    eventLabel.maximumNumberOfLines = 10

    if let e = event.repo?.url {
      eventLabel.attributedText = NSAttributedString(string: e, attributes: nil)
    }
    if let t = event.createdAt {
      timeLabel.attributedText = NSAttributedString(string: t, attributes: nil)
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
