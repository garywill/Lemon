//
//  UIImage+Lemon.swift
//  Lemon
//
//  Created by X140Yu on 3/12/17.
//  Copyright © 2017 X140Yu <zhaoxinyu1994@gmail.com>. All rights reserved.
//

import UIKit

extension UIImage {
  static func color(_ tintColor: UIColor) -> UIImage {
    let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
    UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
    tintColor.setFill()
    UIRectFill(rect)
    let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
    UIGraphicsEndImageContext()
    return image
  }

  func lm_cornerRadiused() -> UIImage? {
    let rect = CGRect(origin: .zero, size: self.size)
    UIGraphicsBeginImageContextWithOptions(rect.size, false, UIScreen.main.scale)
    UIGraphicsGetCurrentContext()?.addPath(UIBezierPath(roundedRect: rect, byRoundingCorners: UIRectCorner.allCorners,
                                                        cornerRadii: CGSize(width: self.size.width, height: self.size.height)).cgPath)
    UIGraphicsGetCurrentContext()?.clip()
    draw(in: rect)
    UIGraphicsGetCurrentContext()!.drawPath(using: .fillStroke)
    let output = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext()
    return output
  }
}
