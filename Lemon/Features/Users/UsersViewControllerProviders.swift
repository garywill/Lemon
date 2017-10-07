import RxSwift
import RxCocoa

class FollowingsProvider: UsersViewControllerProvider {

  init(_ login: String) {
    self.login = login
  }

  private let login: String
  private let bag = DisposeBag()

  var title = "Following"

  func fetchData(page: Int, completion: @escaping (UsersViewControllerProviderFetchResult) -> Void) {
    GitHubProvider
      .request(.Followings(login: login, page: page))
      .mapArray(User.self)
      .subscribe(onSuccess: { (users) in
        completion(UsersViewControllerProviderFetchResult.success(users: users))
      }) { (error) in
        completion(UsersViewControllerProviderFetchResult.error(error: error))
    }.addDisposableTo(bag)
  }

  class func viewController(login: String) -> UsersViewController {
    return UsersViewController(provider: FollowingsProvider(login))
  }

}

class FollowersProvider: UsersViewControllerProvider {

  init(_ login: String) {
    self.login = login
  }

  private let login: String
  private let bag = DisposeBag()

  var title = "Followers"

  func fetchData(page: Int, completion: @escaping (UsersViewControllerProviderFetchResult) -> Void) {
    GitHubProvider
      .request(.Followers(login: login, page: page))
      .mapArray(User.self)
      .subscribe(onSuccess: { (users) in
        completion(UsersViewControllerProviderFetchResult.success(users: users))
      }) { (error) in
        completion(UsersViewControllerProviderFetchResult.error(error: error))
      }.addDisposableTo(bag)
  }

  class func viewController(login: String) -> UsersViewController {
    return UsersViewController(provider: FollowersProvider(login))
  }

}
