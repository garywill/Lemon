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
    
    self.viewModel.outputs.oauthCode
      .drive(onNext: { [weak self] code in
        guard let c = code else {
          self?.OAuthFailed()
          return
        }
        self?.OAuthSuccessed(c)
      }).addDisposableTo(disposeBag)
  }
  
  @IBAction func OAuthButtonAction(_ sender: UIButton) {
    let url = URL(string: OAuthConstants.URL)!
    safari = SFSafariViewController(url: url)
    guard let sa = safari else { return }
    sa.delegate = self
    present(sa, animated: true, completion: nil)
  }
  
  func OAuthFailed() {
    ProgressHUD.showFailure("OAuth Failed, please try again")
    safari?.dismiss(animated: true)
  }
  
  func OAuthSuccessed(_ accessToken: String) {
    safari?.dismiss(animated: true)
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    appDelegate.window!.rootViewController = R.storyboard.main().instantiateInitialViewController()
    ProgressHUD.showSuccess("OAuth Success")
    CacheManager.cachedToken = accessToken
    LemonLog.Log(accessToken)
  }
  
  static func show() {
    let oauthVC = OAuthViewController(nibName: R.nib.oAuthViewController.name, bundle: R.nib.oAuthViewController.bundle)
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    appDelegate.window?.rootViewController?.present(oauthVC, animated: true, completion: nil)
  }
}

extension OAuthViewController: SFSafariViewControllerDelegate {
  func safariViewControllerDidFinish(_ controller: SFSafariViewController) {
    self.viewModel.inputs.cancelProcess.onNext(())
  }
}
