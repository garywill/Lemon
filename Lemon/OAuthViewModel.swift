//
//  OAuthViewModel.swift
//  Lemon
//
//  Created by X140Yu on 19/5/2017.
//  Copyright © 2017 X140Yu. All rights reserved.
//

import Foundation
import Result
import ReactiveSwift
import Alamofire

public protocol OAuthViewModelInputs {
    func oauthURL(_ url: URL)
}

public protocol OAuthViewModelOutputs {
    var oauthCode: Signal<String?, NoError> { get }
}

public protocol OAuthViewModelType {
    var inputs: OAuthViewModelInputs { get }
    var outputs: OAuthViewModelOutputs { get }
}

public final class OAuthViewModel: OAuthViewModelType, OAuthViewModelInputs, OAuthViewModelOutputs {
    
    init() {
        oauthCode = oauthURL.signal.skipNil().map { decodeOAuth($0) }
    }
    
    public var oauthCode: Signal<String?, NoError>

    fileprivate let oauthURL = MutableProperty<URL?>(nil)
    public func oauthURL(_ url: URL) {
        self.oauthURL.value = url
    }

    public var outputs: OAuthViewModelOutputs { return self }
    public var inputs: OAuthViewModelInputs { return self }
}

fileprivate func decodeOAuth(_ url: URL) -> String? {
    return OAuthHelper.decode("code", url.absoluteString)
}
