//
//  UIImage+Lemon.swift
//  Lemon
//
//  Created by X140Yu on 3/12/17.
//  Copyright © 2017 X140Yu. All rights reserved.
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
}
