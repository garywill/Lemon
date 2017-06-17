//
//  ProgressHUD.swift
//  Lemon
//
//  Created by X140Yu on 3/11/17.
//  Copyright © 2017 X140Yu. All rights reserved.
//  Special thanks to @gaoji

import UIKit
import Foundation
import MBProgressHUD

public class ProgressHUD: NSObject{
  
  public static func showLoading() {
    ProgressHUDManager.shared.showLoading(text: nil, touchThroughAreas: nil)
  }
  
  public static func showText(_ text:String?) {
    ProgressHUDManager.shared.showText(text)
  }
  public static func showText(text:String?, blockingViews:[UIView?]?) {
    let rects = viewsRect(blockingViews)
    let hud = ProgressHUDManager.shared.showText(text)
    hud.touchMode = .touchThrough(blockingAreas: rects)
  }
  
  public static func showSquared(image:UIImage?, text: String?)  {
    ProgressHUDManager.shared.showSquared(image: image, text: text)
  }
  
  public static func showSuccess() {
    ProgressHUDManager.shared.showSuccess(text: nil)
  }
  public static func showSuccess(_ text: String?) {
    ProgressHUDManager.shared.showSuccess(text: text)
  }
  public static func showSuccess(_ text: String?, blockingViews:[UIView?]?) {
    let rects = viewsRect(blockingViews)
    let hud = ProgressHUDManager.shared.showSuccess(text: text)
    hud.touchMode = .touchThrough(blockingAreas: rects)
  }
  
  public static func showFailure(_ text: String?) {
    ProgressHUDManager.shared.showFailure(text: text)
  }
  public static func showFailure(_ text: String?, blockingViews:[UIView?]?) {
    let rects = viewsRect(blockingViews)
    let hud = ProgressHUDManager.shared.showFailure(text: text)
    hud.touchMode = .touchThrough(blockingAreas: rects)
  }
  
  public static func dismissImmediately() {
    ProgressHUDManager.shared.dismissImmediately()
  }
  public static func dismissWithDeley() {
    ProgressHUDManager.shared.dismissWithDeley()
  }
  
  private static func viewsRect(_ views:[UIView?]?) -> [CGRect]? {
    return views.flatMap { $0.flatMap{ $0 }.flatMap { v in
      ProgressHUDManager.targetView?.convert(v.bounds, from: v)
      }
    }
  }
  
  
}

public class ProgressHUDManager :NSObject {
  
  public static let shared = ProgressHUDManager()
  public var loadingEnduance :TimeInterval = 0.5
  public var autoDissmissedTime :TimeInterval = 1.5
  public var succeedDissmissedTime :TimeInterval = 1
  
  @discardableResult
  public func showLoading(text:String? = nil, touchThroughAreas:[CGRect]? = nil, inView:UIView? = nil) -> HUDType {
    let hud = HUDFactory.getALoadingHud()
    hud.touchMode = .blocking(touchThroughAreas: touchThroughAreas)
    hud.label.text = text
    hud.isSquare = true
    self.show(hud, inView: inView)
    return hud
  }
  
  @discardableResult
  public func showText(_ text:String?, inView:UIView? = nil) -> HUDType {
    let hud = HUDFactory.getAHintHUD()
    hud.label.text = text
    self.show(hud, inView: inView)
    self.dismiss(after: self.succeedDissmissedTime)
    return hud
  }
  
  @discardableResult
  public func showSquared(image:UIImage?, text: String? = nil, inView:UIView? = nil) -> HUDType  {
    let hud = self.showSquaredInner(image: image, text: text, inView: inView)
    self.dismiss(after: self.succeedDissmissedTime)
    return hud
  }
  @discardableResult
  public func showSuccess(text:String? = nil, inView:UIView? = nil) -> HUDType {
    let image = R.image.progressHud_Success_normal()
    let hud = self.showSquaredInner(image: image, text: text, inView: inView)
    hud.customView?.tintColor = UIColor(colorLiteralRed: 99.0/255.0, green: 99.0/255.0, blue: 99.0/255.0, alpha: 1.0)
    self.dismiss(after: self.succeedDissmissedTime)
    return hud
  }
  @discardableResult
  public func showFailure(text:String? = nil, inView:UIView? = nil) -> HUDType {
    let image = R.image.progressHud_Fail_normal()
    let hud = self.showSquaredInner(image: image, text: text, inView: inView)
    hud.customView?.tintColor = UIColor(colorLiteralRed: 99.0/255.0, green: 99.0/255.0, blue: 99.0/255.0, alpha: 1.0)
    self.dismissWithDeley()
    return hud
  }
  @discardableResult
  private func showSquaredInner(image:UIImage?, text: String?, inView:UIView?) -> HUDType {
    let hud = HUDFactory.getAHintHUD()
    hud.minSize = CGSize(width: 100, height: 88)
    hud.mode = .customView
    hud.customView = UIImageView(image: image)
    hud.label.text = text
    self.show(hud, inView: inView)
    return hud
  }
  
  public func dismiss(after delay:TimeInterval?) {
    
    if let delay = delay, delay > 0 {
      DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
        self.currentHUD?.hide(animated: true)
        self.currentHUD = nil
      }
    } else {
      self.currentHUD?.hide(animated: true)
      self.currentHUD = nil
    }
  }
  
  public func dismissImmediately() {
    self.dismiss(after: nil)
  }
  public func dismissWithDeley() {
    self.dismiss(after: self.autoDissmissedTime)
  }
  
  public override init() {
    super.init()
  }
  required public init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private var currentHUD :HUDType?
  
  private func show(_ hud:HUDType, inView:UIView? = nil) {
    
    self.dismissImmediately()
    self.currentHUD = hud
    hud.label.textColor = UIColor(colorLiteralRed: 99.0/255.0, green: 99.0/255.0, blue: 99.0/255.0, alpha: 1.0)
    let view = inView ?? ProgressHUDManager.targetView
    view?.addSubview(hud)
    hud.show(animated: true)
  }
  
  fileprivate static var targetView :UIView? {
    return UIApplication.shared.keyWindow
  }
  
  
}

public typealias HUDType = TransparentHud

private class HUDFactory {
  
  private static func getABasicHUD() -> TransparentHud {
    let hud = TransparentHud(frame: CGRect(origin: .zero, size: UIApplication.shared.keyWindow!.frame.size))
    hud.label.font = UIFont.systemFont(ofSize: 16)
    hud.removeFromSuperViewOnHide = true
    hud.bezelView.layer.cornerRadius = 10
    hud.areDefaultMotionEffectsEnabled = true
    return hud
  }
  
  static func getAHintHUD() -> TransparentHud {
    let hud = self.getABasicHUD()
    hud.touchMode = .touchThrough(blockingAreas: nil) // don't block views below
    hud.mode = .text
    hud.margin = 15
    hud.label.numberOfLines = 5
    hud.minSize = CGSize(width: 100, height: 60)
    return hud
  }
  
  static func getALoadingHud() -> TransparentHud {
    let hud = self.getABasicHUD()
    hud.mode = .customView
    let loading = UIActivityIndicatorView(activityIndicatorStyle: .whiteLarge)
    UIActivityIndicatorView.appearance(
      whenContainedInInstancesOf: [MBProgressHUD.self]).color
      = UIColor(colorLiteralRed: 99.0/255.0, green: 99.0/255.0, blue: 99.0/255.0, alpha: 1.0)
    loading.startAnimating()
    hud.customView = loading
    hud.margin = 15
    
    hud.touchMode = .blocking(touchThroughAreas: nil) // block views below
    return hud
  }
}

public class TransparentHud : MBProgressHUD {
  
  public enum Mode {
    ///  receive touches, except touchThroughAreas
    ///  behaved like nomarl views
    case blocking( touchThroughAreas : [CGRect]?)
    ///  doesn't receive touches, except blockingAreas
    case touchThrough( blockingAreas : [CGRect]?)
  }
  
  public var touchMode :Mode = .blocking(touchThroughAreas: nil)
  
  
  public override func point(inside point: CGPoint, with event: UIEvent?) -> Bool {
    
    switch self.touchMode {
    case .blocking( let touchThroughAreas):
      if let areas = touchThroughAreas {
        for rect in areas {
          if rect.contains(point) {
            return false
          }
        }
      }
      return super.point(inside: point, with: event)
    case .touchThrough(let blockingAreas):
      if let areas = blockingAreas {
        for rect in areas {
          if rect.contains(point) {
            return super.point(inside: point, with: event)
          }
        }
      }
      return false
    }
  }
  
  
  public func setToBlocingExceptFor(rect:CGRect) {
    let rects = rect == .zero ? nil : [rect]
    self.touchMode = .blocking(touchThroughAreas: rects)
  }
  ///  doesn't receive touches, except rect
  public func setToTouchingThroughExceptFor(rect:CGRect) {
    let rects = rect == .zero ? nil : [rect]
    self.touchMode = .touchThrough(blockingAreas: rects)
  }
}
