import UIKit

class LemonNavigationViewController: UINavigationController {

  override func viewDidLoad() {
    super.viewDidLoad()

    style()
  }

  private func style() {
    navigationBar.isTranslucent = false

    let color = UIColor.lmDarkGrey
    guard let font = UIFont(name: "Menlo-Regular", size: 20) else {
      navigationBar.titleTextAttributes = [
        NSAttributedStringKey.foregroundColor: color
      ]
      return
    }

    navigationBar.titleTextAttributes = [
      NSAttributedStringKey.foregroundColor: color,
      NSAttributedStringKey.font: font
    ]
  }

}
