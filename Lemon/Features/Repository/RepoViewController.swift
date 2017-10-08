import UIKit
import RxSwift
import RxCocoa
import PINRemoteImage
import MarkdownView
import SafariServices

class RepoViewController: UIViewController {

  @IBOutlet weak var scrollView: UIScrollView!
  @IBOutlet weak var contentView: UIView!

  @IBOutlet weak var avatarImageView: UIImageView!
  @IBOutlet weak var nameLabel: UILabel!
  @IBOutlet weak var briefLabel: UILabel!
  @IBOutlet weak var descTextView: UITextView!
  @IBOutlet weak var followButton: FollowButton!
  @IBOutlet weak var starButton: StarButton!
  @IBOutlet weak var forkButton: CountButton!
  @IBOutlet weak var markdownView: MarkdownView!
  @IBOutlet weak var markdownViewHeight: NSLayoutConstraint!

  let bag = DisposeBag()
  var name: String?
  var ownerLogin: String?
  var repo: Repository?
  let topTapGesture = UITapGestureRecognizer()
  let shareButton = UIButton()
  lazy var loadingView: LoadableViewProvider = {
    let v = LoadableViewProvider(contentView: view)
    return v
  }()

  @IBAction func handleTopGesture(_ sender: UITapGestureRecognizer) {
    guard let login = self.ownerLogin else { return }
    Navigator.navigate(.Profile(login: login), responder: self)
  }

  override func viewDidLoad() {
    super.viewDidLoad()

    fetchData()
    setupStyles()

    loadingView.startLoading()

    loadingView.isLoading
      .asDriver()
      .map { !$0 }
      .drive(shareButton.rx.isEnabled)
      .addDisposableTo(bag)
  }

  override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
    super.viewWillTransition(to: size, with: coordinator)

    DispatchQueue.main.asyncAfter(deadline: .now() + 1) { 
      self.markdownView.recalculateHeight()
    }
  }

  func fetchData() {
    guard let name = name, let login = ownerLogin else {
      return
    }

    // TODO: If the login is the same as current
    title = name.components(separatedBy: "/").last

    GitHubProvider
      .request(.Repo(name: name))
      .mapObject(Repository.self)
      .subscribe(onSuccess: { (r) in
        self.refreshUI(r)
      }).addDisposableTo(bag)

    GitHubProvider
      .request(.Users(name: login))
      .mapObject(User.self)
      .subscribe(onSuccess: { (u) in
        self.briefLabel.text = u.bio
      }).addDisposableTo(bag)

    // TODO: 如果 default branch 不是 master，这里可能会出错，但是这里我们先忽略
    markdownView.baseURL = "https://raw.githubusercontent.com/\(name)/master"
    GitHubProvider
      .request(.Readme(name: name))
      .subscribe(onSuccess: { (res) in
        guard let rawMD = String(data: res.data, encoding: .utf8) else { return }
        self.markdownView.load(markdown: rawMD)
      }).addDisposableTo(bag)

    followButton.username = login
    starButton.repoName = name
  }

  func refreshUI(_ r: Repository) {
    repo = r
    if let a = r.owner?.avatarUrl, let url = URL(string: a) {
      self.avatarImageView.pin_setImage(from: url)
    }
    loadingView.stopLoading()
    descTextView.text = r.descriptionField + " " + (r.homepage ?? "")
    nameLabel.text = r.owner?.login
    starButton.count = r.stargazersCount
    forkButton.count = r.forksCount
    forkButton.currentState = .disable
    forkButton.setImage(#imageLiteral(resourceName: "Button_fork_disable"), for: .normal)
  }

  func setupStyles() {
    shareButton.setImage(#imageLiteral(resourceName: "share"), for: .normal)
    shareButton.rx.controlEvent(.touchUpInside)
      .map { _ in return URL(string: self.repo?.url ?? "") }
      .filterNil()
      .subscribe(onNext: { [weak self] url in
        guard let `self` = self else { return }
        // set up activity view controller
        let textToShare = [ url ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view
        self.present(activityViewController, animated: true, completion: nil)
      }).addDisposableTo(bag)
    let shareBarButton = UIBarButtonItem(customView: shareButton)
    navigationItem.rightBarButtonItem = shareBarButton

    nameLabel.text = ""
    nameLabel.textColor = UIColor.lmGithubBlue
    nameLabel.font = UIFont.lemonMono(size: 17)
    briefLabel.text = ""
    briefLabel.font = UIFont.systemFont(ofSize: 12)
    briefLabel.textColor = UIColor.lmDarkGrey

    descTextView.delegate = self

    avatarImageView.layer.cornerRadius = avatarImageView.frame.height / 2.0
    avatarImageView.layer.masksToBounds = true

    markdownView.isScrollEnabled = false
    markdownView.onRendered = { height in
      self.markdownViewHeight.constant = height + 30
    }

    markdownView.onTouchLink = { [weak self] urlRequest in
      if !Router.handleURL(urlRequest.url, self?.navigationController) {
        if let url = urlRequest.url {
          let safari = SFSafariViewController(url: url)
          self?.present(safari, animated: true, completion: nil)
        }
      }
      return false
    }
  }
}

extension RepoViewController: UITextViewDelegate {
  func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
    if !Router.handleURL(URL, navigationController) {
      let safari = SFSafariViewController(url: URL)
      present(safari, animated: true, completion: nil)
    }
    return false
  }
}
