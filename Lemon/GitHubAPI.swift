//
//  GitHubAPI.swift
//  Lemon
//
//  Created by X140Yu on 19/5/2017.
//  Copyright © 2017 X140Yu <zhaoxinyu1994@gmail.com>. All rights reserved.
//

import Foundation
import Moya

public var GitHubProvider = RxMoyaProvider<GitHub>(
  endpointClosure: endpointClosure
)

let endpointClosure = { (target: GitHub) -> Endpoint<GitHub> in
  let url = target.baseURL.appendingPathComponent(target.path).absoluteString
  var defaultEndpoint = MoyaProvider.defaultEndpointMapping(for: target)
  
  switch target {
  case .Readme(_):
    defaultEndpoint = defaultEndpoint.adding(newHTTPHeaderFields: ["Accept": "application/vnd.github.VERSION.raw"])
  default:
    break
  }
  guard let token = CacheManager.cachedToken else { return defaultEndpoint }
  return defaultEndpoint.adding(newHTTPHeaderFields: ["Authorization": "token \(token)"])
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
  case Repo(name: String)
  case Users(name: String)
  case FollowStatus(name: String)
  // https://developer.github.com/v3/activity/starring/
  case StarStatus(repoName: String)
  // https://developer.github.com/v3/repos/contents/
  case Readme(name: String)
}


extension GitHub: TargetType {
  public var baseURL: URL { return URL(string: "https://api.github.com")! }
  
  public var path: String {
    switch self {
    case .User:
      return "/user"
    case .Events(let login, _):
      return "/users/\(login)/received_events"
    case .Repo(let name):
      return "/repos/\(name)"
    case .Users(let name):
      return "/users/\(name)"
    case .FollowStatus(let name):
      return "/user/following/\(name)"
    case .StarStatus(let name):
      return "/user/starred/\(name)"
    case .Readme(let name):
      return "/repos/\(name)/readme"
    }
  }
  
  public var method: Moya.Method {
    switch self {
    case .User,
         .Events(_),
         .Repo(_),
         .FollowStatus(_),
         .StarStatus(_),
         .Readme(_),
         .Users(_):
      return .get
    }
  }
  
  public var parameters: [String: Any]? {
    switch self {
    case .User,
         .Users(_),
         .FollowStatus(_),
         .StarStatus(_),
         .Readme(_),
         .Repo(_):
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
