//
//  NetworkManager.swift
//  Lemon
//
//  Created by X140Yu on 3/11/17.
//  Copyright © 2017 X140Yu. All rights reserved.
//

import Foundation
import Alamofire

class NetworkManager {
    static let sharedManager = NetworkManager()

    func fetchRepos(_ accessToken: String) {
        let url = "https://api.github.com/user/repos"
        let header = ["Authorization": "token " + accessToken]
        Alamofire.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: header).responseJSON { (response) in
            guard let result = response.result.value else { return }
            guard let res = result as? Array<Any> else { return }
            let repos = res.map({ (r) -> Repository in
                return Repository(r as! [String : Any])
            })

            debugPrint(repos)
        }
    }
}
