//
//  GitHubAPI.swift
//  Lemon
//
//  Created by X140Yu on 19/5/2017.
//  Copyright © 2017 X140Yu. All rights reserved.
//

import Foundation
import Moya

public var GitHubProvider = RxMoyaProvider<GitHub>(
  endpointClosure: endpointClosure
)

let endpointClosure = { (target: GitHub) -> Endpoint<GitHub> in
  let url = target.baseURL.appendingPathComponent(target.path).absoluteString
  let defaultEndpoint = MoyaProvider.defaultEndpointMapping(for: target)
  
  switch target {
  default:
    guard let token = CacheManager.cachedToken else { return defaultEndpoint }
    return defaultEndpoint.adding(newHTTPHeaderFields: ["Authorization": "token \(token)"])
  }
}

public func url(route: TargetType) -> String {
  return route.baseURL.appendingPathComponent(route.path).absoluteString
}

private extension String {
  var urlEscaped: String {
    return self.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
  }
}

public enum GitHub {
  case User
  case Events(login: String, page: Int)
}


extension GitHub: TargetType {
  public var baseURL: URL { return URL(string: "https://api.github.com")! }
  
  public var path: String {
    switch self {
    case .User:
      return "/user"
    case .Events(let login, _):
      return "/users/\(login)/received_events"
    }
  }
  
  public var method: Moya.Method {
    switch self {
    case .User,
         .Events(_):
      return .get
    }
  }
  
  public var parameters: [String: Any]? {
    switch self {
    case .User:
      return nil
    case .Events(_, let page):
      var params: [String : AnyObject] = [:]
      params["page"] = page as AnyObject
      return params
    }
  }

  var multipartBody: [MultipartFormData]? {
    return nil
  }
  
  public var parameterEncoding: ParameterEncoding {
    
    switch self {
    default:
      return URLEncoding.default
    }
    
  }
  
  public var task: Task {
    return .request
  }
  
  public var sampleData: Data {
    
    switch self {
    default:
      return "".data(using: String.Encoding.utf8)!
    }
    
  }
  
}
