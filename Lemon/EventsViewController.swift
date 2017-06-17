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

class EventsViewController: UIViewController {
  @IBOutlet weak var tableView: UITableView!
  
  var events = Variable<[Event]>([])
  
  let disposeBag = DisposeBag()
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    tableView.delegate = self
    tableView.dataSource = self
//    tableView.register(EventTableViewCell.self, forCellReuseIdentifier: "cell")
    
    events.asObservable()
      .subscribeOn(MainScheduler.instance)
      .subscribe(onNext: { [weak self] events in
        self?.tableView.reloadData()
      })
      .addDisposableTo(disposeBag)
    
    requestEvents()
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
      .do(onError: { error in
        ProgressHUD.showFailure("Failed to get events")
      })
      .subscribe(onNext: { elements in
        self.events.value = elements
      })
      .addDisposableTo(disposeBag)
  }
}

extension EventsViewController: UITableViewDelegate, UITableViewDataSource {
  func numberOfSections(in tableView: UITableView) -> Int {
    return 1
  }
  
  func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    return events.value.count
  }
  
  func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! EventTableViewCell
    let event = events.value[indexPath.row]
    cell.configure(event)
    return cell
  }
}
