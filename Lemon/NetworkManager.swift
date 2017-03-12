//
//  NetworkManager.swift
//  Lemon
//
//  Created by X140Yu on 3/11/17.
//  Copyright © 2017 X140Yu. All rights reserved.
//

import Foundation
import Alamofire

typealias RequestSuccessHandler = (Any) -> Void
typealias RequestFailureHandler = (Error) -> Void

enum NetworkError: Error {
    case parseFailed
}

class AccessTokenAdapter: RequestAdapter {
    private let accessToken: String

    init(_ accessToken: String) {
        self.accessToken = accessToken
    }

    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var urlRequest = urlRequest

        if let urlString = urlRequest.url?.absoluteString, urlString.hasPrefix(Constants.GitHubBaseURL) {
            urlRequest.setValue("token " + accessToken, forHTTPHeaderField: "Authorization")
        }

        return urlRequest
    }
}

class NetworkManager {
    static let sharedManager = NetworkManager()
    var sessionManager: SessionManager

    private init() {
        sessionManager = SessionManager()
    }


    @discardableResult
    open func request(
        _ url: URLConvertible,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = JSONEncoding.default,
        headers: HTTPHeaders? = nil,
        success: @escaping RequestSuccessHandler, failure: @escaping RequestFailureHandler)
    {
        guard let token = CacheManager.cachedToken else { return }
        sessionManager.adapter = AccessTokenAdapter(token)
        sessionManager.request(url, method: method, parameters: parameters, encoding: encoding, headers: headers).responseJSON { (response) in
            if let err = response.error {
                failure(err)
                return
            }

            if let result = response.result.value {
                success(result)
                return
            }

            failure(NetworkError.parseFailed)
        }
    }

}

class GitHubNetworkClient {
    class func fetchRepos(success: @escaping (Array<Repository>) -> Void, failure: @escaping RequestFailureHandler) {
        let url = "https://api.github.com/user/repos"
        NetworkManager.sharedManager.request(url, method: .get, success: { (res) in
            guard let r = res as? Array<Any> else {
                failure(NetworkError.parseFailed)
                return
            }
            let repos = r.map({ (r) -> Repository in
                return Repository(r as! [String : Any])
            })
            success(repos)

        }) { (error) in
            failure(NetworkError.parseFailed)
        }
    }
}
