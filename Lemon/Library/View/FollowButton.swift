import UIKit
import RxSwift
import RxCocoa

enum FollowButtonState {
  case unfollow
  case following
  case busy
}

class FollowButton: UIButton {

  private let loadingIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)

  public let bag = DisposeBag()

  public var username: String? {
    didSet {
      guard let u = username else { return }
      GitHubProvider
        .request(.FollowStatus(name: u))
        .subscribe(onSuccess: { (res) in
          if res.statusCode == 204 {
            self.currentState.value = .following
          } else {
            self.currentState.value = .unfollow
          }
        }).addDisposableTo(bag)
    }
  }

  var currentState = Variable<FollowButtonState>(.busy)

  override init(frame: CGRect) {
    super.init(frame: frame)
    setup()
  }

  func update(_ state: FollowButtonState) {
    loadingIndicator.stopAnimating()
    loadingIndicator.isHidden = true
    switch state {
    case .following:
      setTitle("Following", for: .normal)
      setTitleColor(UIColor.white, for: .normal)
      setBackgroundImage(UIColor.lmGithubBlue.image(), for: .normal)
      setBackgroundImage(UIColor.lmGithubBlue.image(), for: .highlighted)
    case .unfollow:
      setTitle("Follow", for: .normal)
      setTitleColor(UIColor.lmGithubBlue, for: .normal)
      setBackgroundImage(UIColor.white.image(), for: .normal)
      setBackgroundImage(UIColor.white.image(), for: .highlighted)
    case .busy:
      setTitle("", for: .normal)
      loadingIndicator.isHidden = false
      loadingIndicator.startAnimating()
    }
  }

  required init?(coder aDecoder: NSCoder) {
    super.init(coder: aDecoder)
    setup()
  }

  @objc
  func handleTouch() {
    guard let u = username else { return }
    switch self.currentState.value {
    case .busy:
      return
    case .following:
      self.currentState.value = .busy
      GitHubProvider
        .request(.UnFollowUser(name: u))
        .subscribe(onSuccess: { (res) in
          if res.statusCode == 204 {
            self.currentState.value = .unfollow
          } else {
            self.currentState.value = .following
          }
        }, onError: { error in
          self.currentState.value = .following
        }).addDisposableTo(bag)
    case .unfollow:
      self.currentState.value = .busy
      GitHubProvider
        .request(.FollowUser(name: u))
        .subscribe(onSuccess: { (res) in
          if res.statusCode == 204 {
            self.currentState.value = .following
          } else {
            self.currentState.value = .unfollow
          }
        }, onError: { error in
          self.currentState.value = .unfollow
        }).addDisposableTo(bag)
    }
  }

  func setup() {
    layer.cornerRadius = 7
    layer.masksToBounds = true
    layer.borderWidth = 1
    layer.borderColor = UIColor.lmGithubBlue.cgColor
    titleLabel?.font = UIFont.systemFont(ofSize: 16)

    addSubview(loadingIndicator)
    loadingIndicator.center = CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0)

    addTarget(self, action: #selector(handleTouch), for: .touchUpInside)

    currentState.asDriver().drive(onNext: { [weak self] state in
      self?.update(state)
    }).addDisposableTo(bag)

    currentState.value = .busy
  }

}
