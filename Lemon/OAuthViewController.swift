//
//  OAuthViewController.swift
//  Lemon
//
//  Created by X140Yu on 3/10/17.
//  Copyright © 2017 X140Yu. All rights reserved.
//

import UIKit
import Alamofire
import SafariServices
import Result
import RxSwift
import RxCocoa

class OAuthViewController: UIViewController {
    
    @IBOutlet weak var OAuthButton: UIButton!
    var safari: SFSafariViewController?
    let viewModel = OAuthViewModel()
    
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        OAuthButton.setBackgroundImage(UIImage.color(UIColor.lmGithubBlue), for: .normal)
        OAuthButton.setBackgroundImage(UIImage.color(UIColor.lmGithubBlue.alpha(0.8)), for: .highlighted)
        OAuthButton.layer.cornerRadius = 13
        OAuthButton.layer.masksToBounds = true
        
        NotificationCenter.default.rx.notification(OAuthConstants.OAuthCallbackNotificationName)
            .map {
                return $0.object as? URL
            }
            .bind(to: self.viewModel.inputs.oauthURL)
            .addDisposableTo(disposeBag)
        
        self.viewModel.outputs.oauthCode.drive(onNext: { [weak self] code in
            guard let c = code else {
                self?.OAuthFailed()
                return
            }
            self?.OAuthSuccessed(c)
        }).addDisposableTo(disposeBag)
    }
    
//    fileprivate func processCallbackCode(_ code: String) {
//        Alamofire.request(OAuthConstants.AccessTokenRequestURL,
//                          method: .post,
//                          parameters: OAuthConstants.accessTokenParamDiction(code),
//                          encoding: JSONEncoding.default,
//                          headers: nil)
//            .responseString { [unowned self] (response) in
//                /// fuck GitHub, it's not a valid JSON, so we have to parse by hand
//                let result = try? response.result.unwrap()
//                if let r = result, let token = OAuthHelper.decode("access_token", "?" + r) {
//                    self.OAuthSuccessed(token)
//                    return
//                }
//                self.OAuthFailed()
//        }
//    }
    
    @IBAction func OAuthButtonAction(_ sender: UIButton) {
        let url = URL(string: OAuthConstants.URL)!
        safari = SFSafariViewController(url: url)
        guard let sa = safari else { return }
        present(sa, animated: true, completion: nil)
    }
    
    func OAuthFailed() {
        ProgressHUD.showFailure(text: "OAuth Failed, please try again")
        safari?.dismiss(animated: true)
    }
    
    func OAuthSuccessed(_ accessToken: String) {
        ProgressHUD.showSuccess(text: "OAuth Success")
        CacheManager.cachedToken = accessToken
        LemonLog(accessToken)
        safari?.dismiss(animated: true)
    }
    
}
