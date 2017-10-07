import RxSwift
import RxCocoa
import AsyncDisplayKit

class FollowingsViewController: UIViewController {
  let tableNode = ASTableNode()

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  init?(user: User?) {
    guard let login = user?.login else {
      return nil
    }

    self.login = login
    super.init(nibName: nil, bundle: nil)

    view.backgroundColor = .white
    tableNode.delegate = self
    tableNode.dataSource = self
  }

  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    let tabBarheight = self.tabBarController?.tabBar.bounds.size.height ?? 0
    tableNode.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height - tabBarheight)
  }

  let login: String
  private let bag = DisposeBag()
  private var users = [User]()
  private var currentPage = 2
  private var noMore = false

  override func viewDidLoad() {
    super.viewDidLoad()

    view.addSubnode(tableNode)
    title = "Following"

    GitHubProvider
      .request(.Followings(login: login, page: 1))
      .mapArray(User.self)
      .subscribe(onSuccess: { [weak self] (users) in
        self?.users = users
        self?.tableNode.reloadData()
      }) { (error) in
    }.addDisposableTo(bag)
  }
}

extension FollowingsViewController: ASTableDataSource, ASTableDelegate {
  func tableNode(_ tableNode: ASTableNode, constrainedSizeForRowAt indexPath: IndexPath) -> ASSizeRange {
    let width = UIScreen.main.bounds.size.width;
    return ASSizeRangeMake(CGSize(width: width, height: 60))
  }

  func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
    tableNode.deselectRow(at: indexPath, animated: true)
    if indexPath.row >= users.count {
      return
    }
    let user = users[indexPath.row]
    LemonLog.Log(user)
  }

  func numberOfSections(in tableNode: ASTableNode) -> Int {
    return 1
  }

  func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
    return users.count
  }

  func tableNode(_ tableNode: ASTableNode, nodeForRowAt indexPath: IndexPath) -> ASCellNode {
    if indexPath.row >= users.count {
      return ASCellNode()
    }

    let user = users[indexPath.row]
    let node = UserCellNode(user: user)
    return node
  }

  func tableNode(_ tableNode: ASTableNode, willBeginBatchFetchWith context: ASBatchContext) {
    if noMore {
      return
    }
    GitHubProvider
      .request(.Followings(login: login, page: currentPage))
      .mapArray(User.self)
      .subscribe(onSuccess: { [weak self] (users) in
        if users.count == 0 {
          self?.noMore = true
        }
        self?.users += users
        self?.tableNode.reloadData()
        self?.currentPage += 1
        context.completeBatchFetching(true)
      }) { (error) in
        context.completeBatchFetching(true)
      }.addDisposableTo(bag)
  }
}
