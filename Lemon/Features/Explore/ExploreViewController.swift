import UIKit
import ObjectMapper

class ExploreViewController: UIViewController {

  @IBAction func test(_ sender: FollowButton) {
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    performWhenDebug {
      DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + 0.1) {
        let vc = RepoListViewController()
        self.navigationController?.pushViewController(vc, animated: true)
      }
    }
  }

}
