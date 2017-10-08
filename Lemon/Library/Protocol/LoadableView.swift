import UIKit
import RxSwift
import RxCocoa

protocol Loadable {
  var ld_contentView: UIView { get }
  func startLoading()
  func stopLoading()
}

class LoadableViewProvider: Loadable {
  var ld_contentView: UIView
  let isLoading = Variable<Bool>(false)

  lazy var loadingView: UIView = {
    let v = UIView()
    v.backgroundColor = UIColor.white
    let spinner = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    v.addSubview(spinner)
    spinner.startAnimating()
    spinner.snp.makeConstraints({ (maker) in
      maker.center.equalTo(v)
    })
    return v
  }()

  init(contentView: UIView) {
    ld_contentView = contentView
    isLoading.value = false
  }

  func startLoading() {
    stopLoading()
    isLoading.value = true
    ld_contentView.addSubview(loadingView)
    loadingView.snp.makeConstraints { (maker) in
      maker.edges.equalTo(ld_contentView)
    }
  }

  func stopLoading() {
    isLoading.value = false
    loadingView.removeFromSuperview()
  }
}
