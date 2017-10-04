import UIKit
import RxSwift
import RxCocoa
import SnapKit
import PINRemoteImage

class ProfileViewController: UIViewController {
  @IBOutlet weak var avatarImageView: UIImageView!
  @IBOutlet weak var nameTextView: UITextView!
  @IBOutlet weak var loginTextView: UITextView!
  @IBOutlet weak var companyTextView: UITextView!
  @IBOutlet weak var locationTextView: UITextView!
  @IBOutlet weak var mailTextView: UITextView!
  @IBOutlet weak var blogTextView: UITextView!
  @IBOutlet weak var repoCountLabel: UILabel!
  @IBOutlet weak var followersCountLabel: UILabel!
  @IBOutlet weak var followingCountLabel: UILabel!

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

  var name: String?
  var isMine: Bool = false
  let bag = DisposeBag()

  class func profileVC(login: String) -> ProfileViewController {
    let vc = R.storyboard.profileViewController.profileViewController()!
    vc.name = login
    return vc
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    view.addSubview(loadingView)
    loadingView.snp.makeConstraints { (maker) in
      maker.edges.equalTo(view)
    }

    if isMine {
      GitHubProvider
        .request(.User)
        .mapObject(User.self)
        .flatMap { user -> Single<User> in
          guard let u = user.login else {
            return Single<User>.just(User())
          }
          return ProfileViewController.getUser(u)
        }
        .subscribeOn(MainScheduler.instance)
        .subscribe(onSuccess: { [weak self] (user) in
          self?.avatarImageView.pin_setImage(from: URL(string: user.avatarUrl ?? ""))
          self?.nameTextView.text = user.name
          self?.loginTextView.text = user.login
          self?.companyTextView.text = user.company
          self?.locationTextView.text = user.location
          self?.mailTextView.text = user.email
          self?.blogTextView.text = user.blog
          self?.followersCountLabel.text = "\(user.followers)"
          self?.followingCountLabel.text = "\(user.following)"
          self?.repoCountLabel.text = "\(user.publicRepos)"

          self?.loadingView.removeFromSuperview()
        }, onError: { (error) in

        }).addDisposableTo(bag)
      return
    }

    guard let u = name else { return }

    ProfileViewController.getUser(u)
      .subscribe(onSuccess: { [weak self] (user) in
        self?.avatarImageView.pin_setImage(from: URL(string: user.avatarUrl ?? ""))
        self?.nameTextView.text = user.name
        self?.loginTextView.text = user.login
        self?.companyTextView.text = user.company
        self?.locationTextView.text = user.location
        self?.mailTextView.text = user.email
        self?.blogTextView.text = user.blog
        self?.followersCountLabel.text = "\(user.followers)"
        self?.followingCountLabel.text = "\(user.following)"
        self?.repoCountLabel.text = "\(user.publicRepos)"

        self?.loadingView.removeFromSuperview()
      }).addDisposableTo(bag)
  }

  private class func getUser(_ login: String) -> Single<User> {
    return GitHubProvider
      .request(.Users(name: login))
      .mapObject(User.self)
  }

}
