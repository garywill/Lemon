//
//  ProfileViewController.swift
//  Lemon
//
//  Created by X140Yu on 3/14/17.
//  Copyright © 2017 X140Yu <zhaoxinyu1994@gmail.com>. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import PINRemoteImage

class ProfileViewController: UIViewController {
  @IBOutlet weak var avatarImageView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var loginLabel: UILabel!
  @IBOutlet weak var companyLabel: UILabel!
  @IBOutlet weak var locationLabel: UILabel!
  @IBOutlet weak var mailLabel: UILabel!
  @IBOutlet weak var blogLabel: UILabel!

  var name: String?
  let bag = DisposeBag()

  class func profileVC(login: String) -> ProfileViewController {
    let vc = R.storyboard.profileViewController.profileViewController()!
    vc.name = login
    return vc
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    guard let u = name else { return }

    GitHubProvider
      .request(.Users(name: u))
      .mapObject(User.self)
      .subscribe(onSuccess: { (user) in
        self.avatarImageView.pin_setImage(from: URL(string: user.avatarUrl ?? ""))
        self.nameLabel.text = user.name
        self.loginLabel.text = user.login
        self.companyLabel.text = user.company
        self.locationLabel.text = user.location
        self.mailLabel.text = user.email
        self.blogLabel.text = user.blog
      }).addDisposableTo(bag)
  }

}
