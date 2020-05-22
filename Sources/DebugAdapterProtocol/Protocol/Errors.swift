public enum DAPError: Error, Equatable, CustomStringConvertible {
  case unsupportedRequest(command: String)
  case unsupportedResponse(command: String)
  case unsupportedEvent(event: String)

  public var description: String {
    switch self {
    case .unsupportedRequest(let command):
      return "Request \"\(command)\" is not supported"
    case .unsupportedResponse(let command):
      return "Response \"\(command)\" is not supported"
    case .unsupportedEvent(let event):
      return "Event \"\(event)\" is not supported"
    }
  }
}
