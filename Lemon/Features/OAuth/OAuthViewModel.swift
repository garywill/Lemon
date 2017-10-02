import Foundation
import Result
import Alamofire
import Moya
import RxSwift
import RxCocoa
import RxOptional
import RxAlamofire

public protocol OAuthViewModelInputs {
  var oauthURL: PublishSubject<URL?> { get }
  var cancelProcess: PublishSubject<()> { get }
}

public protocol OAuthViewModelOutputs {
  var oauthCode: Driver<String?> { get }
}

public protocol OAuthViewModelType {
  var inputs: OAuthViewModelInputs { get }
  var outputs: OAuthViewModelOutputs { get }
}

public final class OAuthViewModel: OAuthViewModelType, OAuthViewModelInputs, OAuthViewModelOutputs {
  
  private let disposeBag = DisposeBag()
  
  init() {
    oauthURL = PublishSubject<URL?>()
    cancelProcess = PublishSubject<()>()
    
    let realCode = oauthURL.asDriver(onErrorJustReturn: nil)
      .flatMap { url -> Driver<String?> in
        guard let u = decodeOAuth(url) else {
          return Driver.just(nil)
        }
        return Alamofire.request(OAuthConstants.AccessTokenRequestURL,
                                 method: .post,
                                 parameters: OAuthConstants.accessTokenParamDiction(u),
                                 encoding: JSONEncoding.default,
                                 headers: nil)
          .rx.responseString()
          .map { response, str in
            return OAuthHelper.decode("access_token", "?" + str)
          }
          .asDriver(onErrorJustReturn: nil)
    }
    
    let cancel: Driver<String?> = cancelProcess.asDriver(onErrorJustReturn: ()).map { return nil }
    
    oauthCode = Driver<String?>
      .merge(realCode, cancel)
      .asObservable()
      .asDriver(onErrorJustReturn: nil)
  }
  
  public var oauthCode: Driver<String?>
  public var oauthURL: PublishSubject<URL?>
  public var cancelProcess: PublishSubject<()>
  
  public var outputs: OAuthViewModelOutputs { return self }
  public var inputs: OAuthViewModelInputs { return self }
}

fileprivate func decodeOAuth(_ url: URL?) -> String? {
  guard let u = url else {
    return nil
  }
  return OAuthHelper.decode("code", u.absoluteString)
}
