import Foundation

public enum EventMessage: MirroredEnum, Codable {
  private enum CodingKeys: String, CodingKey {
    case event
    case body
  }

  case breakpoint(BreakpointEvent?)
  case initialized
  case continued(ContinuedEvent)
  case exited(ExitedEvent)
  case stopped(StoppedEvent)
  case terminated(TerminatedEvent?)

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let event = try container.decode(String.self, forKey: .event)
    switch event {
    case "breakpoint": self = .breakpoint(try container.decode(BreakpointEvent.self, forKey: .body))
    case "initialized": self = .initialized
    case "continued": self = .continued(try container.decode(ContinuedEvent.self, forKey: .body))
    case "exited": self = .exited(try container.decode(ExitedEvent.self, forKey: .body))
    case "stopped": self = .stopped(try container.decode(StoppedEvent.self, forKey: .body))
    case "terminated": self = .terminated(try container.decode(TerminatedEvent.self, forKey: .body))
    default: throw DAPError.unsupportedEvent(event: event)
    }
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(self.label, forKey: .event)
    switch self {
    case .breakpoint(let event):
      try container.encode(event, forKey: .body)
    case .continued(let event):
      try container.encode(event, forKey: .body)
    case .exited(let event):
      try container.encode(event, forKey: .body)
    case .stopped(let event):
      try container.encode(event, forKey: .body)
    case .terminated(let event):
      try container.encode(event, forKey: .body)
    case .initialized:
      break
    }
  }
}

public enum BreakpointReason: String, Codable {
  case changed, new, removed
}

public struct BreakpointEvent: Codable {
  public var reason: BreakpointReason

  public init(reason: BreakpointReason) {
    self.reason = reason
  }
}

public enum StopReason: String, Codable {
  case step
  case breakpoint
  case exception
  case pause
  case entry
  case goto
  case functionBreakpoint = "function breakpoint"
  case dataBreakpoint = "data breakpoint"
}

public struct StoppedEvent: Codable {
  public var reason: StopReason
  public var description: String?
  public var threadId: Int?
  public var preserveFocusHint: Bool?
  public var text: String?
  public var allThreadsStopped: Bool?

  public init(reason: StopReason,
              description: String? = nil,
              threadId: Int? = nil,
              preserveFocusHint: Bool? = nil,
              text: String? = nil,
              allThreadsStopped: Bool? = nil) {
    self.reason = reason
    self.description = description
    self.threadId = threadId
    self.preserveFocusHint = preserveFocusHint
    self.text = text
    self.allThreadsStopped = allThreadsStopped
  }
}

public struct ContinuedEvent: Codable {
  public var threadId: Int
  public var allThreadsContinued: Bool?

  public init(threadId: Int, allThreadsContinued: Bool? = nil) {
    self.threadId = threadId
    self.allThreadsContinued = allThreadsContinued
  }
}

public struct ExitedEvent: Codable {
  public var exitCode: Int

  public init(exitCode: Int) {
    self.exitCode = exitCode
  }
}

public struct TerminatedEvent: Codable {
//  public var restart: Any
  public init() {
  }
}
