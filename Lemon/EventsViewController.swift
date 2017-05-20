//
//  EventsViewController.swift
//  Lemon
//
//  Created by X140Yu on 3/14/17.
//  Copyright © 2017 X140Yu. All rights reserved.
//

import UIKit
import Result
import ReactiveSwift

class EventsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        if let username = CacheManager.cachedUsername {
            GitHubProvider
                .request(.Events(login: username))
                .observe(on: UIScheduler())
                .map(to: [Event.self])
                .startWithResult{ result in
                    LemonLog(result.value)
                }
        } else {
            GitHubProvider
                .request(.User)
                .observe(on: UIScheduler())
                .map(to: User.self)
                .startWithResult{ result in
                    LemonLog(result.value)
                    CacheManager.cachedUsername = result.value?.login
                }
        }

        //let oauthVC = OAuthViewController(nibName: R.nib.oAuthViewController.name, bundle: R.nib.oAuthViewController.bundle)
        //present(oauthVC, animated: true, completion: nil)
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
