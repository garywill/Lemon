import UIKit

class LemonNavigationViewController: UINavigationController {

    override func viewDidLoad() {
      super.viewDidLoad()

      navigationBar.barTintColor = UIColor.lmNavDarkGrey
      navigationBar.isTranslucent = false
      navigationBar.titleTextAttributes = [
        NSAttributedStringKey.foregroundColor: UIColor.white,
        NSAttributedStringKey.font: UIFont(name: "Menlo-Regular", size: 20)!
      ]
    }


}
