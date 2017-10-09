import UIKit
import AsyncDisplayKit
import RxSwift
import RxCocoa


class RepoListViewController: UIViewController {
  private let tableNode = ASTableNode()

  private let repos = (1...10).map { _ in return Repository.mock() }

  override func viewDidLoad() {
    super.viewDidLoad()

    view.addSubnode(tableNode)
    title = "Repos"
    tableNode.delegate = self
    tableNode.dataSource = self
  }

  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    tableNode.frame = CGRect(x: 0, y: 0, width: view.bounds.width, height: view.bounds.height)
  }

}


extension RepoListViewController: ASTableDataSource, ASTableDelegate {
  func tableNode(_ tableNode: ASTableNode, constrainedSizeForRowAt indexPath: IndexPath) -> ASSizeRange {
    let width = UIScreen.main.bounds.size.width
    let min = CGSize(width: width, height: 100)
    let max = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
    return ASSizeRange(min: min, max: max)
  }

  func tableNode(_ tableNode: ASTableNode, didSelectRowAt indexPath: IndexPath) {
    tableNode.deselectRow(at: indexPath, animated: true)
    if indexPath.row >= repos.count {
      return
    }
    let repo = repos[indexPath.row]
//    guard let login = user.login else { return }
//    Navigator.navigate(.Profile(login: login), responder: self)
  }

  func numberOfSections(in tableNode: ASTableNode) -> Int {
    return 1
  }

  func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
    return repos.count
  }

  func tableNode(_ tableNode: ASTableNode, nodeForRowAt indexPath: IndexPath) -> ASCellNode {
    if indexPath.row >= repos.count {
      return ASCellNode()
    }

    let repo = repos[indexPath.row]
    let node = RepoCellNode(repo: repo)
    return node
  }

  func tableNode(_ tableNode: ASTableNode, willBeginBatchFetchWith context: ASBatchContext) {
  }
}

