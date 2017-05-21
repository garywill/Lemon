//
//  OAuthViewModel.swift
//  Lemon
//
//  Created by X140Yu on 19/5/2017.
//  Copyright © 2017 X140Yu. All rights reserved.
//

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
            .map { url -> String? in
                return decodeOAuth(url)
            }.flatMap { url -> Driver<String?> in
                guard let u = url else {
                    return Driver.just(nil)
                }
                return Alamofire.request(OAuthConstants.AccessTokenRequestURL,
                                  method: .post,
                                  parameters: OAuthConstants.accessTokenParamDiction(u),
                                  encoding: JSONEncoding.default,
                                  headers: nil).rx.responseString().map { response, str in
                                    return OAuthHelper.decode("access_token", "?" + str)
                    }.asDriver(onErrorJustReturn: nil)
        }

        let cancel: Driver<String?> = cancelProcess.asDriver(onErrorJustReturn: ()).map { return nil }
        
        /// Once user dismiss the VC, cancel that ULR process
        cancelProcess.subscribe(onNext: {
            let disposable = realCode.asObservable().subscribe()
            disposable.dispose()
        }).addDisposableTo(disposeBag)

        oauthCode = Driver<String?>.merge(realCode, cancel)
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
