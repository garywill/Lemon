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
    
    
    let disposeBag = DisposeBag()

    override func viewDidLoad() {
        super.viewDidLoad()

//        if let username = CacheManager.cachedUsername {
//            GitHubProvider
//                .request(.Events(login: username))
//                .mapArray(Event.self)
//                .observeOn(MainScheduler.instance)
//                .subscribe{ events in
//                    LemonLog(events)
//                }
//                .addDisposableTo(disposeBag)
//        } else {
//            GitHubProvider
//                .request(.User)
//                .mapObject(User.self)
//                .observeOn(MainScheduler.instance)
//                .subscribe { event in
//                    CacheManager.cachedUsername = event.element?.login
//                }
//                .addDisposableTo(disposeBag)
//        }

        let oauthVC = OAuthViewController(nibName: R.nib.oAuthViewController.name, bundle: R.nib.oAuthViewController.bundle)
        present(oauthVC, animated: true, completion: nil)
    }
}
