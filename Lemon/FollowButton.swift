//
//  FollowButton.swift
//  Lemon
//
//  Created by X140Yu on 22/6/2017.
//  Copyright © 2017 X140Yu <zhaoxinyu1994@gmail.com>. All rights reserved.
//

import UIKit

enum FollowButtonState {
  case unfollow
  case following
  case busy
}

class FollowButton: UIButton {

  let loadingIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)

  var currentState: FollowButtonState = .busy {
    didSet {
      update(currentState)
    }
  }

  func update(_ state: FollowButtonState) {
    loadingIndicator.stopAnimating()
    loadingIndicator.isHidden = true
    switch state {
    case .following:
      setTitle("Following", for: .normal)
      setTitleColor(UIColor.white, for: .normal)
      setBackgroundImage(UIColor.lmGithubBlue.image(), for: .normal)
      setBackgroundImage(UIColor.lmGithubBlue.image(), for: .highlighted)
    case .unfollow:
      setTitle("Follow", for: .normal)
      setTitleColor(UIColor.lmGithubBlue, for: .normal)
      setBackgroundImage(UIColor.white.image(), for: .normal)
      setBackgroundImage(UIColor.white.image(), for: .highlighted)
    case .busy:
      setTitle("", for: .normal)
      loadingIndicator.isHidden = false
      loadingIndicator.startAnimating()
    }
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }

  func setup() {
    addSubview(loadingIndicator)
    loadingIndicator.center = CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0)

    currentState = .busy

    layer.cornerRadius = 7
    layer.masksToBounds = true
    layer.borderWidth = 1
    layer.borderColor = UIColor.lmGithubBlue.cgColor
    titleLabel?.font = UIFont.systemFont(ofSize: 16)
  }

}
