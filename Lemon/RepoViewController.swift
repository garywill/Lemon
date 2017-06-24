//
//  RepoViewController.swift
//  Lemon
//
//  Created by X140Yu on 21/6/2017.
//  Copyright © 2017 X140Yu <zhaoxinyu1994@gmail.com>. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import PINRemoteImage

class RepoViewController: UIViewController {

  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var contentView: UIView!

  @IBOutlet weak var avatarImageView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var briefLabel: UILabel!
  @IBOutlet weak var descTextView: UITextView!
  @IBOutlet weak var followButton: FollowButton!
  @IBOutlet weak var starButton: CountButton!
  @IBOutlet weak var forButton: CountButton!
//  @IBOutlet weak var watchButton: CountButton!

  let bag = DisposeBag()
  var name: String?
  var ownerLogin: String?

  class func repoVC(repo: Repository) -> RepoViewController {
    let vc = R.storyboard.repoViewController.repoViewController()!
    vc.name = repo.name
    vc.ownerLogin = repo.owner?.login
    return vc
  }

  class func repoVC(url: URL) -> RepoViewController {
    // https://api.github.com/repos/{user-login}/{repo-name}
    let vc = R.storyboard.repoViewController.repoViewController()!
    guard let name = url.absoluteString.components(separatedBy: "/repos/").last else {
      fatalError("url is not valid")
    }
    vc.name = name
    vc.ownerLogin = name.components(separatedBy: "/").first
    return vc
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    fetchData()
    setupStyles()
  }

  func fetchData() {
    guard let name = name, let login = ownerLogin else {
      return
    }
    // TODO: If the login is the same as current
    title = name
    GitHubProvider
      .request(.Repo(name: name))
      .mapObject(Repository.self)
      .subscribe(onNext: { r in
        self.refreshUI(r)
      }).addDisposableTo(bag)

    followButton.currentState = .busy
    starButton.currentState = .busy
    forButton.currentState = .busy

    GitHubProvider
      .request(.Users(name: login))
      .mapObject(User.self)
      .subscribe(onNext:  { u in
        self.briefLabel.text = u.bio
      }).addDisposableTo(bag)

    GitHubProvider
      .request(.FollowStatus(name: login))
      .subscribe(onNext: { res in
        if res.statusCode == 204 {
          self.followButton.currentState = .following
        } else {
          // 404 is unfollowed
          // https://developer.github.com/v3/users/followers/
          self.followButton.currentState = .unfollow
        }
      }, onError: { err in
      }).addDisposableTo(bag)

    GitHubProvider
      .request(.StarStatus(repoName: name))
      .subscribe(onNext: { res in
        if res.statusCode == 204 {
          self.starButton.currentState = .positive
        } else {
          self.starButton.currentState = .normal
        }
      })
      .addDisposableTo(bag)
  }

  func refreshUI(_ r: Repository) {
    if let a = r.owner?.avatarUrl, let url = URL(string: a) {
      self.avatarImageView.pin_setImage(from: url)
    }
    descTextView.text = r.descriptionField + " " + (r.homepage ?? "")
    nameLabel.text = r.owner?.login
    starButton.count = r.stargazersCount
    forButton.count = r.forksCount
    forButton.currentState = .disable
  }

  func setupStyles() {
    nameLabel.textColor = UIColor.lmGithubBlue
    nameLabel.font = UIFont.lemonMono(size: 17)
    briefLabel.font = UIFont.systemFont(ofSize: 12)
    briefLabel.textColor = UIColor.lmDarkGrey
    starButton.type = .star
    forButton.type = .fork
  }
}
