import UIKit
import Result
import RxSwift
import Moya
import Moya_ObjectMapper
import AsyncDisplayKit

class EventsViewController: UIViewController {
  let tableNode = ASTableNode()
  let refreshControl = UIRefreshControl()

  var events = Variable<[GitHubEvent]>([])

  let disposeBag = DisposeBag()

  struct State {
    var itemCount: Int
    var page: Int
    var fetchingMore: Bool
    static let empty = State(itemCount: 0, page: 1, fetchingMore: false)
  }

  enum Action {
    case beginBatchFetch
    case endBatchFetch(resultCount: Int)
  }

  fileprivate(set) var state: State = .empty

  override func viewDidLoad() {
    super.viewDidLoad()

    let firstPage = GitHubProvider
      .request(.User)
      .mapObject(User.self)
      .flatMap({ (user) -> Single<[GitHubEvent]> in
        guard let login = user.login else {
          return Single<[GitHubEvent]>.just([])
        }
        CacheManager.cachedUsername = user.login
        return GitHubProvider
          .request(GitHub.Events(login: login, page: 1))
          .mapArray(GitHubEvent.self)
          .observeOn(MainScheduler.instance)
      }).debug()

    refreshControl.backgroundColor = UIColor.clear
    refreshControl.tintColor = UIColor.lmLightGrey
    refreshControl.rx.controlEvent(.valueChanged)
      .flatMap { _ in
        return firstPage
      }
      .subscribe(onNext: { events in
        self.events.value = events
        self.refreshControl.endRefreshing()
        self.state.page = 1
        self.state.itemCount = events.count
        self.state = EventsViewController.handleAction(.endBatchFetch(resultCount: 20), fromState: self.state)
      }, onError: { error in
        self.refreshControl.endRefreshing()
      })
      .disposed(by: disposeBag)

    tableNode.view.addSubview(refreshControl)

    view.addSubnode(tableNode)
    tableNode.dataSource = self
    tableNode.delegate = self

    events.asObservable()
      .subscribeOn(MainScheduler.instance)
      .subscribe(onNext: { [weak self] events in
        self?.tableNode.reloadData()
        self?.state.itemCount = events.count
      })
      .disposed(by: disposeBag)

  }

  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    let tabBarheight = self.tabBarController?.tabBar.bounds.size.height ?? 0
    tableNode.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height - tabBarheight)
  }

  func deal(url: URL?) {
    Router.handleURL(url, navigationController)
  }
}

extension EventsViewController: ASTableDataSource, ASTableDelegate {
  func tableNode(_ tableNode: ASTableNode, constrainedSizeForRowAt indexPath: IndexPath) -> ASSizeRange {
    let width = UIScreen.main.bounds.size.width;
    let min = CGSize(width: width, height: 100)
    let max = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
    return ASSizeRange(min: min, max: max)
  }

  func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
    tableNode.deselectRow(at: indexPath, animated: true)
    let event = events.value[indexPath.row]
    if let URLString = event.repo?.url {
      self.deal(url: URL(string: URLString))
    }
  }

  func numberOfSections(in tableNode: ASTableNode) -> Int {
    return 1
  }

  func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
    var count = events.value.count
    if state.fetchingMore {
      count += 1
    }
    return count
  }

  func tableNode(_ tableNode: ASTableNode, nodeForRowAt indexPath: IndexPath) -> ASCellNode {
    let rowCount = self.tableNode(tableNode, numberOfRowsInSection: 0)

    if state.fetchingMore && indexPath.row == rowCount - 1 {
      let node = TailLoadingCellNode()
      node.style.height = ASDimensionMake(44.0)
      return node
    }

    let event = events.value[indexPath.row]
    let viewModel = EventCellViewModel(event: event)
    let node = EventCellNode(viewModel: viewModel)
    viewModel.outputs.linkURL.asObservable()
      .subscribe(onNext: { [weak self] URL in
        self?.deal(url: URL)
      }).addDisposableTo(node.bag)

    return node
  }

  func tableNode(_ tableNode: ASTableNode, willBeginBatchFetchWith context: ASBatchContext) {

    if events.value.count == 0 {
      context.completeBatchFetching(true)
      return
    }

    state.fetchingMore = true
    GitHubProvider
      .request(.User)
      .mapObject(User.self)
      .flatMap { user -> Single<[GitHubEvent]> in
        if let login = user.login {
          return GitHubProvider
            .request(.Events(login: login, page: self.state.page + 1))
            .mapArray(GitHubEvent.self)
            .observeOn(MainScheduler.instance)
            .debug()
        }
        return Single<[GitHubEvent]>.just([])
      }
      .subscribe(onSuccess: { (e) in
        let action = Action.endBatchFetch(resultCount: e.count)
        let oldState = self.state
        self.state = EventsViewController.handleAction(action, fromState: oldState)
        self.state.page += 1
        self.events.value.append(contentsOf: e)
        self.state.fetchingMore = false
        context.completeBatchFetching(true)
      }, onError: { e in
        let e = e as! MoyaError
        if e.response?.statusCode == 422 {
          ProgressHUD.showText("GitHub API only support 300 events :(")
        }
        context.completeBatchFetching(true)
      })
      .addDisposableTo(disposeBag)
  }

  fileprivate static func handleAction(_ action: Action, fromState state: State) -> State {
    var state = state
    switch action {
    case .beginBatchFetch:
      state.fetchingMore = true
    case let .endBatchFetch(resultCount):
      state.itemCount += resultCount
      state.fetchingMore = false
    }
    return state
  }
}
