//
//  ViewController.swift
//  Lemon
//
//  Created by X140Yu on 3/9/17.
//  Copyright © 2017 X140Yu. All rights reserved.
//

import UIKit
import SafariServices

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        if let _ = CacheManager.cachedToken {
            GitHubNetworkClient.fetchRepos(success: { (repos) in
                debugPrint(repos)
            }, failure: { (err) in
                debugPrint(err)
            })
        }
    }

    @IBAction func loginAction(_ sender: UIButton) {
        let OAuthVC = OAuthViewController()
        present(OAuthVC, animated: true, completion: nil)
    }

}

