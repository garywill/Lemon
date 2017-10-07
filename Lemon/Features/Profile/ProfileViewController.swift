import UIKit
import RxSwift
import RxCocoa
import SnapKit
import PINRemoteImage

class ProfileViewController: UIViewController {
  // @IB releated
  @IBOutlet weak var avatarImageView: UIImageView!
  @IBOutlet weak var nameTextView: UITextView!
  @IBOutlet weak var companyTextView: UITextView!
  @IBOutlet weak var locationTextView: UITextView!
  @IBOutlet weak var topprofileStackView: UIStackView!
  @IBOutlet weak var mailTextView: UITextView!
  @IBOutlet weak var blogTextView: UITextView!
  @IBOutlet weak var repoCountLabel: UILabel!
  @IBOutlet weak var followersCountLabel: UILabel!
  @IBOutlet weak var followingCountLabel: UILabel!

  @IBAction func handleReposControl(_ sender: UIControl) {
  }

  @IBAction func handleFollowersControl(_ sender: UIControl) {
  }


  @IBAction func handleFollowingsControl(_ sender: UIControl) {
    guard let followingVC = UsersViewController(user: user) else {
      return
    }
    navigationController?.pushViewController(followingVC, animated: true)
  }

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

  public var name: String?
  var isMine: Bool = false
  var user: User?
  let bag = DisposeBag()

  class func profileVC(login: String) -> ProfileViewController {
    let vc = R.storyboard.profileViewController.profileViewController()!
    vc.name = login
    return vc
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    avatarImageView.layer.cornerRadius = 10
    avatarImageView.layer.masksToBounds = true

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
          self?.updateTopProfileStackView(user: user)

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
        self?.updateTopProfileStackView(user: user)

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

  private func updateTopProfileStackView(user: User) {
    self.user = user
    avatarImageView.pin_setImage(from: URL(string: user.avatarUrl ?? ""))
    nameTextView.text = user.name
    title = user.login

    setStatckViewSubViewsDetail(detail: user.company, subView: companyTextView)
    setStatckViewSubViewsDetail(detail: user.location, subView: locationTextView)
    setStatckViewSubViewsDetail(detail: user.email, subView: mailTextView)
    setStatckViewSubViewsDetail(detail: user.blog, subView: blogTextView)
  }

  private func setStatckViewSubViewsDetail(detail: String?, subView: UITextView) {
    if detail?.count ?? 0 <= 0 {
      topprofileStackView.removeArrangedSubview(subView)
      return
    }

    subView.text = detail
  }

}
