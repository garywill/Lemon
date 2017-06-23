//
//  ExploreViewController.swift
//  Lemon
//
//  Created by X140Yu on 3/14/17.
//  Copyright © 2017 X140Yu <zhaoxinyu1994@gmail.com>. All rights reserved.
//

import UIKit

class ExploreViewController: UIViewController {

  @IBAction func test(_ sender: FollowButton) {
    switch sender.currentState {
    case .following:
      sender.currentState = .busy
    case .unfollow:
      sender.currentState = .busy
    case .busy:
      sender.currentState = .following
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    // Do any additional setup after loading the view.
  }

}
