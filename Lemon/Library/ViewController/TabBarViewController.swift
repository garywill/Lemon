import UIKit

class TabBarViewController: UITabBarController {

  override func viewDidLoad() {
    super.viewDidLoad()

    doInDebug {
      selectedIndex = 1
    }
  }

}
