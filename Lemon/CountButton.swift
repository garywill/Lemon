//
//  CountButton.swift
//  Lemon
//
//  Created by X140Yu on 24/6/2017.
//  Copyright © 2017 X140Yu <zhaoxinyu1994@gmail.com>. All rights reserved.
//

import UIKit

enum CountButtonState {
  case positive
  case normal
  case busy
  case disable
}

enum CountButtonType {
  case star
  case fork
  case watch
}

let numberFormatter: NumberFormatter = {
  let formatter = NumberFormatter()
  formatter.numberStyle = NumberFormatter.Style.decimal
  return formatter
}()

extension Int {
  public var decimaled: String {
    _ = numberFormatter
    return numberFormatter.string(from: self as NSNumber) ?? ""
  }
}

class CountButton: UIButton {

  private let loadingIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)

  var type: CountButtonType = .star {
    didSet {
      switch type {
      case .star:
        if currentState == .positive {
          setImage(#imageLiteral(resourceName: "button_star_unstar"), for: .normal)
        } else {
          setImage(#imageLiteral(resourceName: "Button_star_normal"), for: .normal)
        }
      case .fork:
        setImage(#imageLiteral(resourceName: "Button_fork_disable"), for: .normal)
      case .watch:
        setImage(#imageLiteral(resourceName: "Button_watch_disable"), for: .normal)
      }
      update(currentState)
    }
  }

  private func currentImageForState(_ state: CountButtonState) -> UIImage {
    switch (state, type) {
    case (.positive, .star):
      return #imageLiteral(resourceName: "button_star_unstar")
    case (_, .star):
      return #imageLiteral(resourceName: "Button_star_normal")
    case (_, .fork):
      return #imageLiteral(resourceName: "Button_fork_disable")
    default:
      fatalError("can not reach here")
    }
  }

  var currentState: CountButtonState = .busy {
    didSet {
      update(currentState)
    }
  }

  var count: Int = 0 {
    didSet {
      update(currentState)
    }
  }

  func update(_ state: CountButtonState) {
    loadingIndicator.stopAnimating()
    loadingIndicator.isHidden = true
    setImage(currentImageForState(state), for: .normal)
    switch state {
    case .positive:
      setTitle(count.decimaled, for: .normal)
      setTitleColor(UIColor.white, for: .normal)
      setBackgroundImage(UIColor.lmGithubBlue.image(), for: .normal)
      setBackgroundImage(UIColor.lmGithubBlue.image(), for: .highlighted)
    case .normal:
      setTitle(count.decimaled, for: .normal)
      setTitleColor(UIColor.lmGithubBlue, for: .normal)
      setBackgroundImage(UIColor.white.image(), for: .normal)
      setBackgroundImage(UIColor.white.image(), for: .highlighted)
    case .busy:
      setTitle("", for: .normal)
      loadingIndicator.isHidden = false
      loadingIndicator.startAnimating()
    case .disable:
      setTitle(count.decimaled, for: .normal)
      setTitleColor(UIColor.lmLightGrey, for: .normal)
      setBackgroundImage(UIColor.white.image(), for: .normal)
      setBackgroundImage(UIColor.white.image(), for: .highlighted)
      layer.borderColor = UIColor.lmLightGrey.cgColor
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

    currentState = .normal

    imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
    layer.cornerRadius = 7
    layer.masksToBounds = true
    layer.borderWidth = 1
    layer.borderColor = UIColor.lmGithubBlue.cgColor
    titleLabel?.font = UIFont.systemFont(ofSize: 16)
  }
  
}
