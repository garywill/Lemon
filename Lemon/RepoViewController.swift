//
//  RepoViewController.swift
//  Lemon
//
//  Created by X140Yu on 21/6/2017.
//  Copyright © 2017 X140Yu <zhaoxinyu1994@gmail.com>. All rights reserved.
//

import UIKit

class RepoViewController: UIViewController {

  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var contentView: UIView!

  @IBOutlet weak var avatarImageView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var briefLabel: UILabel!
  @IBOutlet weak var followButton: UIButton!
  @IBOutlet weak var briefTextView: UITextView!
  @IBOutlet weak var readmeView: UIView!

  var name: String?

  class func repoVC(name: String) -> RepoViewController {
    let vc = R.storyboard.repoViewController.repoViewController()!
    vc.name = name
    return vc
  }

  override func viewDidLoad() {
    super.viewDidLoad()
    assert(name != nil, "name can not be nil")
    title = name


  }


  func setupStyles() {

  }
}
