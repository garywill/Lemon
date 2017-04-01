//
//  EventsViewController.swift
//  Lemon
//
//  Created by X140Yu on 3/14/17.
//  Copyright © 2017 X140Yu. All rights reserved.
//

import UIKit
import AsyncDisplayKit

class EventsViewController: UIViewController {

    var tableNode: ASTableNode

    override func viewDidLoad() {
        super.viewDidLoad()

        tableView = ASTableNode(style: .plain)
        tableNode.delegate = self
        tableNode.dataSource = self

        if let username = CacheManager.cachedUsername {
            GitHubNetworkClient.fetchReceivedEvents(username: username, success: { (events) in
                LemonLog(events)
            }, failure: { (err) in
            })
        }

    }


    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
