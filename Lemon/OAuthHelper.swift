//
//  OAuthHelper.swift
//  Lemon
//
//  Created by X140Yu on 3/10/17.
//  Copyright © 2017 X140Yu. All rights reserved.
//

import Foundation

class OAuthHelper {
  /// decode targetKey from a URLStirng with query
  ///
  /// - Parameters:
  ///   - targetKey: "code"
  ///   - queryURLStirng: "lemon://oauth/github?code=123123"
  /// - Returns: "123123"
  class func decode(_ targetKey: String, _ queryURLStirng: String) -> String? {
    if let tokenURL = URL(string: queryURLStirng) {
      if let components = tokenURL.query?.components(separatedBy: "&") {
        for comp in components {
          if (comp.range(of:  "\(targetKey)" + "=") != nil) {
            return comp.components(separatedBy: "=").last
          }
        }
      }
    }
    
    return nil
  }
}
