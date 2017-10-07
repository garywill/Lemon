import UIKit

enum NavigateType {
  case Profile(login: String)
}

struct Navigator {

  static func navigate(_ type: NavigateType, responder: UIResponder) {
    var viewController: UIViewController?
    switch type {
    case .Profile(let login):
      viewController = ProfileViewController.profileVC(login: login)
    }
    guard let vc = viewController else { return }
    guard let nav = responder.findbleNavigationController else { return }
    nav.pushViewController(vc, animated: true)
  }

}

