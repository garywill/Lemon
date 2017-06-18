//
//  EventCellViewModel.swift
//  Lemon
//
//  Created by X140Yu on 18/6/2017.
//  Copyright © 2017 X140Yu. All rights reserved.
//

import Foundation
import UIKit

public final class EventCellViewModel {
  var eventAttributedString = NSAttributedString()
  var dateAttributedString = NSAttributedString()
  let linkAttributeName = "com.lemon.ios.linkAttributeName"
  var avatarURL: URL?
  var iconImage: UIImage?

  init(event: GitHubEvent) {
    let attrString = NSMutableAttributedString()

    if let eventType = event.eventType {
      switch eventType {
      case .WatchEvent(let action):
        if let userName = event.actor?.login, let userURL = event.actor?.url {
          let userNameAttrString = NSAttributedString(string: userName,
                                                      attributes:
            [
              NSForegroundColorAttributeName: UIColor.lmGithubBlue,
              NSFontAttributeName: UIFont.lemonMono(size: 17),
              linkAttributeName: URL(string: userURL)!
            ])
          attrString.append(userNameAttrString)
        }
        let actionAttrString = NSAttributedString(string: " " + action + "\n", attributes:
          [
            NSForegroundColorAttributeName: UIColor.lmDarkGrey,
            NSFontAttributeName: UIFont.lemonMono(size: 17)
          ]
        )
        attrString.append(actionAttrString)
        if let repo = event.repo?.name, let repoURL = event.repo?.url {
          let repoAttrString = NSAttributedString(string: repo, attributes:
            [
              NSForegroundColorAttributeName: UIColor.lmGithubBlue,
              NSFontAttributeName: UIFont.lemonMono(size: 17),
              linkAttributeName: URL(string: repoURL)!
            ])
          attrString.append(repoAttrString)
        }
        iconImage = #imageLiteral(resourceName: "event_star")
        break
      default:
        break
      }
    }

    let paraStyle = NSMutableParagraphStyle()
    paraStyle.lineSpacing = 3
    attrString.addAttributes([NSParagraphStyleAttributeName: paraStyle], range: NSRange(location: 0, length: attrString.length))
    eventAttributedString = attrString

    if let date = event.createdAt {
      dateAttributedString = NSAttributedString(string: date.lm_ago(), attributes:
        [
          NSForegroundColorAttributeName: UIColor.lmLightGrey,
          NSFontAttributeName: UIFont.lemonMono(size: 14)
        ])
    }

    if let u = event.actor?.avatarUrl {
      avatarURL = URL(string: u)
    }
  }
}
