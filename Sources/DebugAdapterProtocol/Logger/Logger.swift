import Foundation

public enum LoggingLevel: String, CustomStringConvertible, Comparable {
  case error, warning, info, debug

  public var description: String { return self.rawValue }

  private func asInteger() -> Int {
    switch self {
    case .error:
      return 3
    case .warning:
      return 2
    case .info:
      return 1
    case .debug:
      return 0
    }
  }

  public static func < (lhs: LoggingLevel, rhs: LoggingLevel) -> Bool {
    return lhs.asInteger() < rhs.asInteger()
  }
}

public protocol Logger {
  func log(_ message: CustomStringConvertible)
  func log(_ message: CustomStringConvertible, level: LoggingLevel)
}
