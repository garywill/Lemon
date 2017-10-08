import UIKit
import RxSwift
import RxCocoa

protocol Shareble {
  var shareButton: UIButton { get }
  var shareItems: [Any] { get set }
}


class SharebleViewControllerProvider: Shareble {
  var shareItems = [Any]()

  private weak var viewController: UIViewController?
  private let bag = DisposeBag()

  var shareButton = UIButton()

  init(viewController: UIViewController) {
    self.viewController = viewController
    shareButton.setImage(#imageLiteral(resourceName: "share"), for: .normal)
    shareButton.rx.controlEvent(.touchUpInside)
      .filter{ _ in return self.shareItems.count > 0}
      .map { _ in return self.shareItems }
      .subscribe(onNext: { [weak self] items in
        guard let `self` = self else { return }
        guard let vc = self.viewController else { return }
        let activityViewController = UIActivityViewController(activityItems: items, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = vc.view
        vc.present(activityViewController, animated: true, completion: nil)
      }).addDisposableTo(bag)
    let shareBarButton = UIBarButtonItem(customView: shareButton)
    viewController.navigationItem.rightBarButtonItem = shareBarButton
  }

}
