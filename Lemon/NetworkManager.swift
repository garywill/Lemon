//
//  NetworkManager.swift
//  Lemon
//
//  Created by X140Yu on 3/11/17.
//  Copyright © 2017 X140Yu. All rights reserved.
//

import Foundation
import Alamofire

typealias RequestSuccess = ([String: Any]) -> Void
typealias RequestSuccessArray = (Array<[String: Any]>) -> Void
typealias RequestFailure = (Error) -> Void

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
    static let shared = NetworkManager()
    var sessionManager: SessionManager

    private init() {
        sessionManager = SessionManager()
    }


    /// Base Request
    @discardableResult
    private func request(
        _ url: URLConvertible,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = JSONEncoding.default,
        headers: HTTPHeaders? = nil,
        successWithRawData: @escaping (Any) -> Void, failure: @escaping RequestFailure) -> DataRequest?
    {
        guard let token = CacheManager.cachedToken else { return nil }
        sessionManager.adapter = AccessTokenAdapter(token)

        LemonLog("\(method) ".uppercased() + "\(url)")
        if parameters != nil {
            LemonLog("parameters: \(parameters)")
        }

        var urlToRequest = url
        if urlToRequest is String {
            let urlString = urlToRequest as! String
            if urlString.hasPrefix(Constants.GitHubBaseURL) == false {
                if urlString.hasPrefix("/") == false {
                    urlToRequest = Constants.GitHubBaseURL + "/" + urlString
                } else {
                    urlToRequest = Constants.GitHubBaseURL + urlString
                }
            }
        }

        return sessionManager.request(urlToRequest, method: method, parameters: parameters, encoding: encoding, headers: headers).responseJSON { (response) in
            if let err = response.error {
                LemonLog("\(method)".uppercased() + "\(url) \(parameters)" + "\(err)")
                failure(err)
                return
            }

            if let result = response.result.value {
                successWithRawData(result)
                return
            }

            failure(NetworkError.parseFailed)
        }
    }


    @discardableResult
    open func request(
        _ url: URLConvertible,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = JSONEncoding.default,
        headers: HTTPHeaders? = nil,
        successWithArrayObject: @escaping RequestSuccessArray, failure: @escaping RequestFailure) -> DataRequest?
    {

        return request(url, method: method, parameters: parameters, encoding: encoding, headers: headers, successWithRawData: { (result) in
            if let r = result as? Array<[String: Any]> {
                successWithArrayObject(r)
            }
        }) { (err) in
            failure(err)
        }
    }

    @discardableResult
    open func request(
        _ url: URLConvertible,
        method: HTTPMethod = .get,
        parameters: Parameters? = nil,
        encoding: ParameterEncoding = JSONEncoding.default,
        headers: HTTPHeaders? = nil,
        successWithObject: @escaping RequestSuccess, failure: @escaping RequestFailure) -> DataRequest?
    {
        return request(url, method: method, parameters: parameters, encoding: encoding, headers: headers, successWithRawData: { (result) in
            if let r = result as? [String: Any] {
                successWithObject(r)
            }
        }) { (err) in
            failure(err)
        }
    }

}

class GitHubNetworkClient {

    class func fetchUserInfo(success: @escaping (User) -> Void, failure: @escaping RequestFailure) {
        NetworkManager.shared.request("/user", successWithObject: { (res) in
            success(User(res))
        }) { (err) in
            failure(err)
        }
    }

    class func fetchRepos(success: @escaping (Array<Repository>) -> Void, failure: @escaping RequestFailure) {
        NetworkManager.shared.request("/user/repos", successWithArrayObject: { (arrayObject) in
            let repos = arrayObject.map({ (r) -> Repository in
                return Repository(r)
            })
            success(repos)
        }) { (err) in
            failure(err)
        }
    }
}
