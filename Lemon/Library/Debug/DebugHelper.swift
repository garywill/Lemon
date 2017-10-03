import Foundation

func performWhenDebug(_ something: () -> ()) {
  #if DEBUG
    something()
  #endif
}

/// conform `CustomDebugStringConvertible` to print object
struct LemonLog {
  static func Log<T>(_ object: @autoclosure () -> T, _ file: String = #file, _ function: String = #function, _ line: Int = #line) {
    performWhenDebug {
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

