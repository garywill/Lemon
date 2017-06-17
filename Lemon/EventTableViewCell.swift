//
//  EventTableViewCell.swift
//  Lemon
//
//  Created by X140Yu on 17/6/2017.
//  Copyright © 2017 X140Yu. All rights reserved.
//

import UIKit
import TTTAttributedLabel

class EventTableViewCell: UITableViewCell {
  @IBOutlet weak var avatarImageView: UIImageView!
  @IBOutlet weak var eventLabel: TTTAttributedLabel!
  @IBOutlet weak var timeLabel: UILabel!
  
  func configure(_ event: Event) {
    eventLabel.text = event.repo?.url
    timeLabel.text = event.createdAt
  }
  
}
