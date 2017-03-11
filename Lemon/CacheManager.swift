//
//  CacheManager.swift
//  Lemon
//
//  Created by X140Yu on 3/11/17.
//  Copyright © 2017 X140Yu. All rights reserved.
//

import Foundation

private struct CacheKeys {
    static let TokenKey = "com.x140yu.lemon.CacheKeys.TokenKey"
}

class CacheManager {

    class var cachedToken: String? {
        get {
            return UserDefaults.standard.string(forKey: CacheKeys.TokenKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: CacheKeys.TokenKey)
        }
    }
}
