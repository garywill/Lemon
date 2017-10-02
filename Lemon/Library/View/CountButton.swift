import UIKit
import RxSwift
import RxCocoa

enum CountButtonState {
  case positive
  case normal
  case busy
  case disable
}

let numberFormatter: NumberFormatter = {
  let formatter = NumberFormatter()
  formatter.numberStyle = NumberFormatter.Style.decimal
  return formatter
}()

extension Int {
  public var decimaled: String {
    _ = numberFormatter
    return numberFormatter.string(from: self as NSNumber) ?? ""
  }
}

class CountButton: UIButton {

  let bag = DisposeBag()

  private let loadingIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)

  var currentState: CountButtonState = .busy {
    didSet {
      update(currentState)
    }
  }

  var count: Int = 0 {
    didSet {
      update(currentState)
    }
  }

  func update(_ state: CountButtonState) {
    loadingIndicator.stopAnimating()
    loadingIndicator.isHidden = true
    switch state {
    case .positive:
      setTitle(count.decimaled, for: .normal)
      setTitleColor(UIColor.white, for: .normal)
      setBackgroundImage(UIColor.lmGithubBlue.image(), for: .normal)
      setBackgroundImage(UIColor.lmGithubBlue.image(), for: .highlighted)
    case .normal:
      setTitle(count.decimaled, for: .normal)
      setTitleColor(UIColor.lmGithubBlue, for: .normal)
      setBackgroundImage(UIColor.white.image(), for: .normal)
      setBackgroundImage(UIColor.white.image(), for: .highlighted)
    case .busy:
      setTitle("", for: .normal)
      loadingIndicator.isHidden = false
      loadingIndicator.startAnimating()
      setImage(nil, for: .normal)
    case .disable:
      setTitle(count.decimaled, for: .normal)
      setTitleColor(UIColor.lmLightGrey, for: .normal)
      setBackgroundImage(UIColor.white.image(), for: .normal)
      setBackgroundImage(UIColor.white.image(), for: .highlighted)
      layer.borderColor = UIColor.lmLightGrey.cgColor
    }
  }

  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }

  func setup() {
    addSubview(loadingIndicator)
    loadingIndicator.center = CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0)

    imageEdgeInsets = UIEdgeInsets(top: 0, left: -10, bottom: 0, right: 0)
    layer.cornerRadius = 7
    layer.masksToBounds = true
    layer.borderWidth = 1
    layer.borderColor = UIColor.lmGithubBlue.cgColor
    titleLabel?.font = UIFont.systemFont(ofSize: 16)

    defer {
      currentState = .busy
    }
  }
  
}
