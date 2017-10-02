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
  case FollowUser(name: String)
  case UnFollowUser(name: String)
  // https://developer.github.com/v3/activity/starring/
  case StarStatus(repoName: String)
  case StarRepo(repoName: String)
  case UnStarRepo(repoName: String)
  // https://developer.github.com/v3/repos/contents/
  case Readme(name: String)
}


extension GitHub: TargetType {

  public var headers: [String : String]? {
    return nil
  }

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
    case .FollowStatus(let name),
         .FollowUser(let name),
         .UnFollowUser(let name):
      return "/user/following/\(name)"
    case .StarStatus(let name),
         .StarRepo(let name),
         .UnStarRepo(let name):
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
    case .FollowUser(_),
         .StarRepo(_):
      return .put
    case .UnFollowUser(_),
         .UnStarRepo(_):
      return .delete
      }
  }
  
  public var parameters: [String: Any]? {
    switch self {
    case .User,
         .Users(_),
         .FollowStatus(_),
         .StarStatus(_),
         .Readme(_),
         .FollowUser(_),
         .UnFollowUser(_),
         .StarRepo(_),
         .UnStarRepo(_),
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
    return .requestPlain
  }
  
  public var sampleData: Data {
    
    switch self {
    default:
      return "".data(using: String.Encoding.utf8)!
    }
    
  }
  
}
