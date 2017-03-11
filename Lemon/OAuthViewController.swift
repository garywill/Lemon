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

class OAuthViewController: UIViewController {

    var safariVC: SFSafariViewController?

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(OAuthViewController.didReceiveOAuthURL(_:)), name: OAuthConstants.OAuthCallbackNotificationName, object: nil)
    }

    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
    @IBAction func OAuthButtonAction(_ sender: UIButton) {
        if let url = URL(string: OAuthConstants.URL) {
            safariVC = SFSafariViewController(url: url)
            if let safari = safariVC {
                present(safari, animated: true, completion: nil)
            }
        }
    }

    func didReceiveOAuthURL(_ notification: NSNotification) {
        guard let url = notification.object as? URL else { OAuthFailed(); return }
        guard let code = OAuthHelper.decode("code", url.absoluteString) else { OAuthFailed(); return }
        processCallbackCode(code)
    }

    func processCallbackCode(_ code: String) {
        Alamofire.request(OAuthConstants.AccessTokenRequestURL, method: .post, parameters: OAuthConstants.accessTokenParamDiction(code), encoding: JSONEncoding.default, headers: nil).responseString { [unowned self] (response) in
            do {
                /// fuck GitHub, it's not a valid JSON, so we have to parse by hand
                let result = try response.result.unwrap()
                if let token = OAuthHelper.decode("access_token", "?" + result) {
                    self.OAuthSuccessed(token)
                } else {
                    self.OAuthFailed()
                }
            } catch {
                self.OAuthFailed()
            }
        }
    }
    
    func OAuthFailed() {
        if let safari = safariVC {
            safari.dismiss(animated: true, completion: {
                ProgressHUD.showFailure(text: "OAuth Failed, please try again")
            })
        }
    }
    
    func OAuthSuccessed(_ accessToken: String) {
        if let safari = safariVC {
            safari.dismiss(animated: true, completion: {
                ProgressHUD.showSuccess(text: "OAuth Success")
                CacheManager.cachedToken = accessToken
                debugPrint(accessToken)
                NetworkManager.sharedManager.fetchRepos(accessToken)
            })
        }
    }
    
}
