import RxSwift
import RxCocoa
import AsyncDisplayKit

enum UsersViewControllerProviderFetchResult {
  case success(users: [User])
  case error(error: Error)
}

protocol UsersViewControllerProvider {
  var title: String { get }
  func fetchData(page: Int, completion: @escaping (UsersViewControllerProviderFetchResult) -> Void)
}

class UsersViewController: UIViewController {
  let tableNode = ASTableNode()

  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }

  init(provider: UsersViewControllerProvider) {
    self.provider = provider
    super.init(nibName: nil, bundle: nil)

    hidesBottomBarWhenPushed = true
    view.backgroundColor = .white
    tableNode.delegate = self
    tableNode.dataSource = self
  }

  private let provider: UsersViewControllerProvider

  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    let tabBarheight = self.tabBarController?.tabBar.bounds.size.height ?? 0
    tableNode.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
  }

  private var users = [User]()
  private var currentPage = 2
  private var noMore = false

  override func viewDidLoad() {
    super.viewDidLoad()

    view.addSubnode(tableNode)
    title = provider.title

    provider.fetchData(page: 1) { [weak self] (result) in
      switch result {
      case .success(let users):
        self?.users = users
        self?.tableNode.reloadData()
      case .error(let error):
        ProgressHUD.showFailure(error.localizedDescription)
      }
    }
  }
}

extension UsersViewController: ASTableDataSource, ASTableDelegate {
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

    provider.fetchData(page: currentPage) { [weak self] (result) in
      guard let `self` = self else { return }
      switch result {
      case .success(let users):
        if users.count == 0 {
          self.noMore = true
        }

        var initial = self.users.count - 1
        let indexPaths = users.map { _ -> IndexPath in
          initial += 1
          return IndexPath(row: initial, section: 0)
        }

        self.users += users
        self.tableNode.insertRows(at: indexPaths, with: UITableViewRowAnimation.fade)
        self.currentPage += 1
        context.completeBatchFetching(true)
      case .error(let error):
        ProgressHUD.showFailure(error.localizedDescription)
        context.completeBatchFetching(true)
      }
    }

  }
}
