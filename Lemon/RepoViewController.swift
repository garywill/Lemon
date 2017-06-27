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
import MarkdownView
import SafariServices

class RepoViewController: UIViewController {

  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var contentView: UIView!

  @IBOutlet weak var avatarImageView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var briefLabel: UILabel!
  @IBOutlet weak var descTextView: UITextView!
  @IBOutlet weak var followButton: FollowButton!
  @IBOutlet weak var starButton: StarButton!
  @IBOutlet weak var forkButton: CountButton!
  @IBOutlet weak var markdownView: MarkdownView!
  @IBOutlet weak var markdownViewHeight: NSLayoutConstraint!

  let bag = DisposeBag()
  var name: String?
  var ownerLogin: String?

  override func viewDidLoad() {
    super.viewDidLoad()

    fetchData()
    setupStyles()
  }

  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)

    DispatchQueue.main.asyncAfter(deadline: .now() + 1) { 
      self.markdownView.recalculateHeight()
    }
  }

  func fetchData() {
    guard let name = name, let login = ownerLogin else {
      return
    }

    // TODO: If the login is the same as current
    title = name.components(separatedBy: "/").last

    GitHubProvider
      .request(.Repo(name: name))
      .mapObject(Repository.self)
      .subscribe(onNext: { r in
        self.refreshUI(r)
      }).addDisposableTo(bag)

    GitHubProvider
      .request(.Users(name: login))
      .mapObject(User.self)
      .subscribe(onNext:  { u in
        self.briefLabel.text = u.bio
      }).addDisposableTo(bag)

    // 如果 default branch 不是 master，这里可能会出错，但是这里我们先忽略
    markdownView.baseURL = "https://raw.githubusercontent.com/\(name)/master"
    GitHubProvider
      .request(.Readme(name: name))
      .subscribe(onNext: { res in
        guard let rawMD = String(data: res.data, encoding: .utf8) else { return }
        self.markdownView.load(markdown: rawMD)
      }).addDisposableTo(bag)

    followButton.username = login
    starButton.repoName = name
  }

  func refreshUI(_ r: Repository) {
    if let a = r.owner?.avatarUrl, let url = URL(string: a) {
      self.avatarImageView.pin_setImage(from: url)
    }
    descTextView.text = r.descriptionField + " " + (r.homepage ?? "")
    nameLabel.text = r.owner?.login
    starButton.count = r.stargazersCount
    forkButton.count = r.forksCount
    forkButton.currentState = .disable
    forkButton.setImage(#imageLiteral(resourceName: "Button_fork_disable"), for: .normal)
  }

  func setupStyles() {
    nameLabel.text = ""
    nameLabel.textColor = UIColor.lmGithubBlue
    nameLabel.font = UIFont.lemonMono(size: 17)
    briefLabel.text = ""
    briefLabel.font = UIFont.systemFont(ofSize: 12)
    briefLabel.textColor = UIColor.lmDarkGrey

    descTextView.delegate = self

    avatarImageView.layer.cornerRadius = avatarImageView.frame.height / 2.0
    avatarImageView.layer.masksToBounds = true

    markdownView.isScrollEnabled = false
    markdownView.onRendered = { height in
      self.markdownViewHeight.constant = height + 30
    }

    markdownView.onTouchLink = { [weak self] urlRequest in
      if !Router.handleURL(urlRequest.url, self?.navigationController) {
        if let url = urlRequest.url {
          let safari = SFSafariViewController(url: url)
          self?.present(safari, animated: true, completion: nil)
        }
      }
      return false
    }
  }
}

extension RepoViewController: UITextViewDelegate {
  func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
    if !Router.handleURL(URL, navigationController) {
      let safari = SFSafariViewController(url: URL)
      present(safari, animated: true, completion: nil)
    }
    return false
  }
}
