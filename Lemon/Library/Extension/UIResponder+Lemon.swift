import UIKit

extension UIResponder {
  var findbleNavigationController: UINavigationController? {
    var navigationController: UINavigationController?

    if let nav = self as? UINavigationController {
      navigationController = nav
    } else if let vc = self as? UIViewController {
      navigationController = vc.navigationController
    } else {
      var nRes = next
      while nRes != nil && !(nRes?.isKind(of: UIViewController.self) ?? false) {
        nRes = nRes?.next
      }

      if nRes != nil, let nVC = nRes as? UIViewController {
        navigationController = nVC.navigationController
      }
    }

    return navigationController
  }
}
