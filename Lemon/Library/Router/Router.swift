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
  class func handleURL(_ url: String?, _ navigationController: UINavigationController?) -> Bool {
    guard var u = url, let nav = navigationController else { return false }

    if u.characters.last == "/" {
      // remove the last charactor if it is '/'
      u = u.substring(to: u.index(before: u.endIndex))
    }

    if u.hasPrefix("\(apiPrefix)/repos/") {
      guard let name = u.components(separatedBy: "/repos/").last else { return false }
      let components = name.components(separatedBy: "/")
      guard let owner = components.first, let _ = components.last else { return false }
      let repoVC = R.storyboard.repoViewController.repoViewController()!
      repoVC.name = name
      repoVC.ownerLogin = owner
      nav.pushViewController(repoVC, animated: true)
      return true
    }

    if u.hasPrefix("\(apiPrefix)/users/") {
      let profileVC = ProfileViewController.profileVC(login: u.components(separatedBy: "/").last!)
      nav.pushViewController(profileVC, animated: true)
      return true
    }
    return handleWebURL(u, nav)
  }

  private class func handleWebURL(_ u: String, _ nav: UINavigationController) -> Bool {

    /// https://github.com/X140Yu/Switcher
    if u.hasPrefix(webPrefix) && u.replacingOccurrences(of: webPrefix, with: "").components(separatedBy: "/").count == 2 {
      let name = u.replacingOccurrences(of: webPrefix, with: "")
      let components = name.components(separatedBy: "/")
      guard let owner = components.first, let _ = components.last else { return false }
      let repoVC = R.storyboard.repoViewController.repoViewController()!
      repoVC.name = name
      repoVC.ownerLogin = owner
      nav.pushViewController(repoVC, animated: true)
      return true
    }

    /// https://github.com/X140Yu
    if u.hasPrefix(webPrefix) && !u.replacingOccurrences(of: webPrefix, with: "").contains("/") {
      guard let login = u.components(separatedBy: "/").last else { return false }
      if !login.contains("trending") &&
        !login.contains("?") {
        let profileVC = ProfileViewController.profileVC(login: login)
        nav.pushViewController(profileVC, animated: true)
        return true
      }
    }

    if u.hasPrefix("file://") {
      return false
    }
    if u.hasPrefix("mailto:") {
      // TODO: handle email
      return false
    }

    // all above can not handle
    //guard let url = URL(string: u) else { return }
    //let safari = SFSafariViewController(url: url)
    //nav.present(safari, animated: true, completion: nil)

    return false
  }

  class func handleURL(_ URL: URL?, _ navigationController: UINavigationController?) -> Bool {
    return handleURL(URL?.absoluteString, navigationController)
  }
}
