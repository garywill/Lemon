//
//  EventsViewController.swift
//  Lemon
//
//  Created by X140Yu on 3/14/17.
//  Copyright © 2017 X140Yu. All rights reserved.
//

import UIKit
import Result
import RxSwift
import Moya
import Moya_ObjectMapper
import AsyncDisplayKit

class EventsViewController: UIViewController {
  let tableNode = ASTableNode()
  
  var events = Variable<[Event]>([])
  
  let disposeBag = DisposeBag()
  
  override func viewDidLoad() {
    super.viewDidLoad()

    view.addSubnode(tableNode)
    tableNode.dataSource = self
    tableNode.delegate = self

    events.asObservable()
      .subscribeOn(MainScheduler.instance)
      .subscribe(onNext: { [weak self] events in
        self?.tableNode.reloadData()
      })
      .addDisposableTo(disposeBag)
    
    requestEvents()
  }
  
  override func viewWillLayoutSubviews() {
    super.viewWillLayoutSubviews()
    let statusBarHeight = UIApplication.shared.statusBarFrame.height
    let navHeight = self.navigationController?.navigationBar.bounds.size.height ?? 0
    let tabBarheight = self.tabBarController?.tabBar.bounds.size.height ?? 0
    tableNode.frame = CGRect(x: 0, y: navHeight + statusBarHeight, width: view.bounds.width, height: view.bounds.height - navHeight - tabBarheight - statusBarHeight)
  }

  func requestEvents() {
    GitHubProvider
      .request(.User)
      .mapObject(User.self)
      .observeOn(MainScheduler.instance)
      .do(onError: { error in
        ProgressHUD.showFailure("OAuth first")
      })
      .flatMap { user -> Observable<[Event]> in
        if let login = user.login {
          return GitHubProvider
            .request(.Events(login: login))
            .mapArray(Event.self)
            .observeOn(MainScheduler.instance)
        }
        return Observable.from([])
      }
      .debug()
      .do(onError: { error in
        ProgressHUD.showFailure("Failed to get events")
      })
      .subscribe(onNext: { elements in
        self.events.value = elements
      })
      .addDisposableTo(disposeBag)
  }
}

extension EventsViewController: ASTableDataSource, ASTableDelegate {
  func tableNode(_ tableNode: ASTableNode, constrainedSizeForRowAt indexPath: IndexPath) -> ASSizeRange {
    let width = UIScreen.main.bounds.size.width;
    let min = CGSize(width: width, height: 100)
    let max = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
    return ASSizeRange(min: min, max: max)
  }

  func numberOfSections(in tableNode: ASTableNode) -> Int {
    return 1
  }

  func tableNode(_ tableNode: ASTableNode, numberOfRowsInSection section: Int) -> Int {
    return events.value.count
  }

  func tableNode(_ tableNode: ASTableNode, nodeForRowAt indexPath: IndexPath) -> ASCellNode {
    let event = events.value[indexPath.row]
    return EventCellNode(event: event)
  }
}
