//
//  DebugHelper.swift
//  Lemon
//
//  Created by X140Yu on 3/13/17.
//  Copyright © 2017 X140Yu <zhaoxinyu1994@gmail.com>. All rights reserved.
//

import Foundation

func doInDebug(_ something: () -> ()) {
  #if DEBUG
    something()
  #endif
}

/// conform `CustomDebugStringConvertible` to print object
struct LemonLog {
  static func Log<T>(_ object: @autoclosure () -> T, _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
    doInDebug {
      let value = object()
      let fileURL = NSURL(string: file)?.lastPathComponent ?? "Unknown file"
      let queue = Thread.isMainThread ? "UI" : "BG"
      
      print("[\(queue)] [\(fileURL):\(line)]: " + String(reflecting: value))
    }
  }
  
  static func Error<T>(_ object: @autoclosure () -> T) {
    Log("Error: " + String(reflecting: object()))
  }
}
