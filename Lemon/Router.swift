//
//  Router.swift
//  Lemon
//
//  Created by X140Yu on 26/6/2017.
//  Copyright © 2017 X140Yu <zhaoxinyu1994@gmail.com>. All rights reserved.
//

import UIKit
import SafariServices

private let apiPrefix = "https://api.github.com"
private let webPrefix = "https://github.com/"

class Router {
  class func handleURL(_ url: String?, _ navigationController: UINavigationController?) {
    guard let u = url, let nav = navigationController else { return }

    if u.hasPrefix("\(apiPrefix)/repos/") {
      guard let name = u.components(separatedBy: "/repos/").last else { return }
      let components = name.components(separatedBy: "/")
      guard let owner = components.first, let _ = components.last else { return }
      let repoVC = R.storyboard.repoViewController.repoViewController()!
      repoVC.name = name
      repoVC.ownerLogin = owner
      nav.pushViewController(repoVC, animated: true)
      return
    }

    if u.hasPrefix("\(apiPrefix)/users/") {
      let profileVC = ProfileViewController.profileVC(login: u.components(separatedBy: "/").last!)
      nav.pushViewController(profileVC, animated: true)
      return
    }


    /// https://github.com/X140Yu/Switcher
    if u.hasPrefix(webPrefix) && u.replacingOccurrences(of: webPrefix, with: "").components(separatedBy: "/").count == 2 {
      let name = u.replacingOccurrences(of: webPrefix, with: "")
      let components = name.components(separatedBy: "/")
      guard let owner = components.first, let _ = components.last else { return }
      let repoVC = R.storyboard.repoViewController.repoViewController()!
      repoVC.name = name
      repoVC.ownerLogin = owner
      nav.pushViewController(repoVC, animated: true)
      return
    }

    /// https://github.com/X140Yu
    if u.hasPrefix(webPrefix) && !u.replacingOccurrences(of: webPrefix, with: "").contains("/") {
      guard let login = u.components(separatedBy: "/").last else { return }
      if !login.contains("trending") &&
         !login.contains("?") {
      let profileVC = ProfileViewController.profileVC(login: login)
      nav.pushViewController(profileVC, animated: true)
      return
      }
    }

    if u.hasPrefix("file://") {
      return
    }
    if u.hasPrefix("mailto:") {
      // TODO: handle email
      return
    }
    guard let url = URL(string: u) else { return }
    let safari = SFSafariViewController(url: url)
    navigationController?.present(safari, animated: true, completion: nil)
  }

  class func handleURL(_ URL: URL?, _ navigationController: UINavigationController?) {
    self.handleURL(URL?.absoluteString, navigationController)
  }

  class func canHandleURL(_ URL: String?) -> Bool {
    guard let URL = URL else { return false }
    if URL.hasPrefix("\(apiPrefix)/repos/") {
      return true
    }

    if URL.hasPrefix("\(apiPrefix)/users/") {
      return true
    }

    if URL.hasPrefix(webPrefix) && URL.replacingOccurrences(of: webPrefix, with: "").components(separatedBy: "/").count == 2 {
      return true
    }

    if URL.hasPrefix(webPrefix) && !URL.replacingOccurrences(of: webPrefix, with: "").contains("/") {
      return true
    }

    return false
  }

  class func canHandleURL(_ URL: URL?) -> Bool {
    return canHandleURL(URL?.absoluteString)
  }
}
