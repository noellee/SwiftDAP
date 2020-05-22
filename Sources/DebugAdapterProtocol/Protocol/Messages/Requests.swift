import Foundation

public enum RequestMessage: MirroredEnum, Codable {
  private enum CodingKeys: String, CodingKey {
    case command
    case arguments
  }

  case goto(GotoArguments?)
  case next(NextArguments?)
  case stepIn(StepInArguments)
  case stepOut(StepOutArguments)
  case `continue`(ContinueArguments)
  case initialize(InitializeArguments)
  case launch(_ args: LaunchArguments)
  case setBreakpoints(SetBreakpointsArguments)
  case setFunctionBreakpoints(SetFunctionBreakpointsArguments)
  case setExceptionBreakpoints(SetExceptionBreakpointsArguments)
  case setDataBreakpoints(SetDataBreakpointsArguments)
  case configurationDone
  case threads
  case scopes(ScopesArguments)
  case variables(VariablesArguments)
  case stackTrace(StackTraceArguments)
  case disconnect(DisconnectArguments?)

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let command = try container.decode(String.self, forKey: .command)
    switch command {
    case "goto": self = .goto(try container.decodeIfPresent(GotoArguments.self, forKey: .arguments))
    case "next": self = .next(try container.decodeIfPresent(NextArguments.self, forKey: .arguments))
    case "stepIn": self = .stepIn(try container.decode(StepInArguments.self, forKey: .arguments))
    case "stepOut": self = .stepOut(try container.decode(StepOutArguments.self, forKey: .arguments))
    case "continue": self = .continue(try container.decode(ContinueArguments.self, forKey: .arguments))
    case "initialize": self = .initialize(try container.decode(InitializeArguments.self, forKey: .arguments))
    case "launch": self = .launch(try container.decode(LaunchArguments.self, forKey: .arguments))
    case "setBreakpoints":
      self = .setBreakpoints(try container.decode(SetBreakpointsArguments.self, forKey: .arguments))
    case "setFunctionBreakpoints":
      self = .setFunctionBreakpoints(try container.decode(SetFunctionBreakpointsArguments.self, forKey: .arguments))
    case "setExceptionBreakpoints":
      self = .setExceptionBreakpoints(try container.decode(SetExceptionBreakpointsArguments.self, forKey: .arguments))
    case "setDataBreakpoints":
      self = .setDataBreakpoints(try container.decode(SetDataBreakpointsArguments.self, forKey: .arguments))
    case "stackTrace": self = .stackTrace(try container.decode(StackTraceArguments.self, forKey: .arguments))
    case "configurationDone": self = .configurationDone
    case "threads": self = .threads
    case "scopes": self = .scopes(try container.decode(ScopesArguments.self, forKey: .arguments))
    case "variables": self = .variables(try container.decode(VariablesArguments.self, forKey: .arguments))
    case "disconnect": self = .disconnect(try container.decodeIfPresent(DisconnectArguments.self, forKey: .arguments))
    default: throw DAPError.unsupportedRequest(command: command)
    }
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(self.label, forKey: .command)
    switch self {
    case .goto(let args):
      try container.encode(args, forKey: .arguments)
    case .next(let args):
      try container.encode(args, forKey: .arguments)
    case .stepIn(let args):
      try container.encode(args, forKey: .arguments)
    case .stepOut(let args):
      try container.encode(args, forKey: .arguments)
    case .continue(let args):
      try container.encode(args, forKey: .arguments)
    case .initialize(let args):
      try container.encode(args, forKey: .arguments)
    case .launch(let args):
      try container.encode(args, forKey: .arguments)
    case .setBreakpoints(let args):
      try container.encode(args, forKey: .arguments)
    case .setFunctionBreakpoints(let args):
      try container.encode(args, forKey: .arguments)
    case .setExceptionBreakpoints(let args):
      try container.encode(args, forKey: .arguments)
    case .setDataBreakpoints(let args):
      try container.encode(args, forKey: .arguments)
    case .stackTrace(let args):
      try container.encode(args, forKey: .arguments)
    case .scopes(let args):
      try container.encode(args, forKey: .arguments)
    case .variables(let args):
      try container.encode(args, forKey: .arguments)
    case .disconnect(let args):
      try container.encode(args, forKey: .arguments)
    case .configurationDone,
         .threads:
      break
    }
  }
}

public struct GotoArguments: Codable {
  public var threadId: Int
  public var targetId: Int
}

public struct NextArguments: Codable {
  public var threadId: Int
}

public struct LaunchArguments: Codable {
  enum CodingKeys: String, CodingKey {
    case noDebug, __restart
  }

  public var noDebug: Bool?
  public var __restart: String?
  public var extraArgs: [String: Any]

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    self.noDebug = try container.decodeIfPresent(Bool.self, forKey: .noDebug)
    self.__restart = try container.decodeIfPresent(String.self, forKey: .__restart)
    let extrasContainer = try decoder.container(keyedBy: GenericCodingKeys.self)
    self.extraArgs = try extrasContainer.decode([String: Any].self)
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(self.noDebug, forKey: .noDebug)
    try container.encode(self.__restart, forKey: .__restart)
    var extraContainer = encoder.container(keyedBy: GenericCodingKeys.self)
    try extraContainer.encode(self.extraArgs)
  }
}

public struct SetBreakpointsArguments: Codable {
  public var source: Source
  public var breakpoints: [SourceBreakpoint]?
  public var lines: [Int]?
  public var sourceModified: Bool?
}

public struct SetFunctionBreakpointsArguments: Codable {
  public var breakpoints: [FunctionBreakpoint]?
}

public struct SetExceptionBreakpointsArguments: Codable {
  public var filters: [String]
  public var exceptionOptions: [ExceptionOptions]?
}

public struct SetDataBreakpointsArguments: Codable {
  public var breakpoints: [DataBreakpoint]
}

public struct InitializeArguments: Codable {
  public var clientID: String?
  public var clientName: String?
  public var adapterID: String
  public var locale: String?
  public var linesStartAt1: Bool?
  public var columnsStartAt1: Bool?
  public var pathFormat: String?
  public var supportsVariableType: Bool?
  public var supportsVariablePaging: Bool?
  public var supportsRunInTerminalRequest: Bool?
  public var supportsMemoryReferences: Bool?
  public var supportsProgressReporting: Bool?
}

public struct StackTraceArguments: Codable {
  public var threadId: Int
  public var startFrame: Int?
  public var levels: Int?
  public var format: StackFrameFormat?
}

public struct ScopesArguments: Codable {
  public var frameId: Int
}

public enum VariableFilter: String, Codable {
  case indexed, named
}

public struct VariablesArguments: Codable {
  public var variablesReference: Int
  public var filter: VariableFilter?
  public var start: Int?
  public var count: Int?
  public var format: ValueFormat?
}

public struct DisconnectArguments: Codable {
  public var restart: Bool?
  public var terminateDebuggee: Bool?
}

public struct ContinueArguments: Codable {
  public var threadId: Int
}

public struct StepInArguments: Codable {
  public var threadId: Int
  public var targetId: Int?
}

public struct StepOutArguments: Codable {
  public var threadId: Int
}
