import UIKit

class TabBarViewController: UITabBarController {

  override func awakeFromNib() {
    super.awakeFromNib()

    if let navController = self.viewControllers?.last as? LemonNavigationViewController, let profileViewController = navController.viewControllers.first as? ProfileViewController {
      profileViewController.isMine = true
      profileViewController.name = CacheManager.cachedToken
    }
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    performWhenDebug {
      selectedIndex = 1
    }
  }
}
