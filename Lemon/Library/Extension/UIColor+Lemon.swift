//
//  UIColor+Lemon.swift
//  Lemon
//
//  Created by X140Yu on 3/11/17.
//  Copyright © 2017 X140Yu <zhaoxinyu1994@gmail.com>. All rights reserved.
//

import UIKit

extension UIColor {
  class var lmGithubBlue: UIColor {
    return UIColor(red: 52.0 / 255.0, green: 102.0 / 255.0, blue: 214.0 / 255.0, alpha: 1.0)
  }
  
  class var lmLemonTitle: UIColor {
    return UIColor(red: 88.0 / 255.0, green: 96.0 / 255.0, blue: 112.0 / 255.0, alpha: 1.0)
  }
  
  class var lmWhite: UIColor {
    return UIColor(white: 255.0 / 255.0, alpha: 1.0)
  }
  
  class var lmLightGrey: UIColor {
    return UIColor(red: 149.0 / 255.0, green: 157.0 / 255.0, blue: 165.0 / 255.0, alpha: 1.0)
  }
  
  class var lmDarkGrey: UIColor {
    return UIColor(red: 70.0 / 255.0, green: 77.0 / 255.0, blue: 93.0 / 255.0, alpha: 1.0)
  }
  
  class var lmNavDarkGrey: UIColor {
    return UIColor(red: 36.0 / 255.0, green: 41.0 / 255.0, blue: 46.0 / 255.0, alpha: 1.0)
  }
  
  class var lmSeperator: UIColor {
    return UIColor(red: 200.0 / 255.0, green: 199.0 / 255.0, blue: 204.0 / 255.0, alpha: 1.0)
  }
}

extension UIColor {
    func image() -> UIImage {
        let rect = CGRect(x: 0, y: 0, width: 1, height: 1)
        UIGraphicsBeginImageContextWithOptions(rect.size, false, 0)
        self.setFill()
        UIRectFill(rect)
        let image: UIImage = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()
        return image
    }
}

// init
public extension UIColor {
  
  /// SwifterSwift: Create UIColor from hexadecimal value with optional transparency.
  ///
  /// - Parameters:
  ///   - hex: hex Int (example: 0xDECEB5).
  ///   - transparency: optional transparency value (default is 1).
  public convenience init(_ hex: Int, _ transparency: CGFloat = 1) {
    var trans: CGFloat {
      if transparency > 1 {
        return 1
      } else if transparency < 0 {
        return 0
      } else {
        return transparency
      }
    }
    self.init((hex >> 16) & 0xff, (hex >> 8) & 0xff, hex & 0xff, trans)
  }
  
  /// SwifterSwift: Create UIColor from hexadecimal string with optional transparency (if applicable).
  ///
  /// - Parameters:
  ///   - hexString: hexadecimal string (examples: EDE7F6, 0xEDE7F6, #EDE7F6, #0ff, 0xF0F, ..).
  ///   - transparency: optional transparency value (default is 1).
  public convenience init?(hexString: String, _ transparency: CGFloat = 1) {
    var string = ""
    if hexString.lowercased().hasPrefix("0x") {
      string =  hexString.replacingOccurrences(of: "0x", with: "")
    } else if hexString.hasPrefix("#") {
      string = hexString.replacingOccurrences(of: "#", with: "")
    } else {
      string = hexString
    }
    
    if string.characters.count == 3 { // convert hex to 6 digit format if in short format
      var str = ""
      string.characters.forEach({ str.append("\($0)" + "\($0)") })
      string = str
    }
    
    guard let hexValue = Int(string, radix: 16) else {
      return nil
    }
    
    self.init(Int(hexValue), transparency)
  }
  
  /// SwifterSwift: Create UIColor from RGB values with optional transparency.
  ///
  /// - Parameters:
  ///   - red: red component.
  ///   - green: green component.
  ///   - blue: blue component.
  ///   - transparency: optional transparency value (default is 1).
  public convenience init(_ red: Int, _ green: Int, _ blue: Int, _ transparency: CGFloat = 1) {
    assert(red >= 0 && red <= 255, "Invalid red component")
    assert(green >= 0 && green <= 255, "Invalid green component")
    assert(blue >= 0 && blue <= 255, "Invalid blue component")
    var trans: CGFloat {
      if transparency > 1 {
        return 1
      } else if transparency < 0 {
        return 0
      } else {
        return transparency
      }
    }
    self.init(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: trans)
  }
}

extension UIColor {
  func alpha(_ alpha: CGFloat) -> UIColor {
    return withAlphaComponent(alpha)
  }
}
