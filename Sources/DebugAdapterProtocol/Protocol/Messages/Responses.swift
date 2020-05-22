import Foundation

public enum ResponseMessage: MirroredEnum, Codable {
  private enum CodingKeys: String, CodingKey {
    case command
    case body
  }

  case goto(RequestResult)
  case next(RequestResult)
  case stepIn(RequestResult)
  case stepOut(RequestResult)
  case `continue`(RequestResult, ContinueResponse)
  case error(RequestResult)
  case initialize(RequestResult, Capabilities)
  case launch(RequestResult)
  case setBreakpoints(RequestResult, SetBreakpointsResponse)
  case setFunctionBreakpoints(RequestResult, SetFunctionBreakpointsResponse)
  case setExceptionBreakpoints(RequestResult)
  case setDataBreakpoints(RequestResult, SetDataBreakpointsResponse)
  case configurationDone(RequestResult)
  case threads(RequestResult, ThreadsResponse)
  case scopes(RequestResult, ScopesResponse)
  case variables(RequestResult, VariablesResponse)
  case stackTrace(RequestResult, StackTraceResponse)
  case disconnect(RequestResult)

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let command = try container.decode(String.self, forKey: .command)
    let result = try RequestResult.init(from: decoder)
    switch command {
    case "goto": self = .goto(result)
    case "next": self = .next(result)
    case "stepIn": self = .stepIn(result)
    case "stepOut": self = .stepOut(result)
    case "error": self = .error(result)
    case "continue": self = .continue(result, try container.decode(ContinueResponse.self, forKey: .body))
    case "initialize": self = .initialize(result, try container.decode(Capabilities.self, forKey: .body))
    case "launch": self = .launch(result)
    case "setBreakpoints":
      self = .setBreakpoints(result, try container.decode(SetBreakpointsResponse.self, forKey: .body))
    case "setFunctionBreakpoints":
      self = .setFunctionBreakpoints(result, try container.decode(SetFunctionBreakpointsResponse.self, forKey: .body))
    case "setDataBreakpoints":
      self = .setDataBreakpoints(result, try container.decode(SetDataBreakpointsResponse.self, forKey: .body))
    case "setExceptionBreakpoints":
      self = .setExceptionBreakpoints(result)
    case "configurationDone":
      self = .configurationDone(result)
    case "threads":
      self = .threads(result, try container.decode(ThreadsResponse.self, forKey: .body))
    case "stackTrace":
      self = .stackTrace(result, try container.decode(StackTraceResponse.self, forKey: .body))
    case "scopes":
      self = .scopes(result, try container.decode(ScopesResponse.self, forKey: .body))
    case "variables":
      self = .variables(result, try container.decode(VariablesResponse.self, forKey: .body))
    case "disconnect":
      self = .disconnect(result)
    default: throw DAPError.unsupportedResponse(command: command)
    }
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(self.label, forKey: .command)
    switch self {
    case .continue(let result, let body):
      try result.encode(to: encoder)
      try container.encode(body, forKey: .body)

    case .initialize(let result, let body):
      try result.encode(to: encoder)
      try container.encode(body, forKey: .body)

    case .setBreakpoints(let result, let body):
      try result.encode(to: encoder)
      try container.encode(body, forKey: .body)

    case .setFunctionBreakpoints(let result, let body):
      try result.encode(to: encoder)
      try container.encode(body, forKey: .body)

    case .setDataBreakpoints(let result, let body):
      try result.encode(to: encoder)
      try container.encode(body, forKey: .body)

    case .threads(let result, let body):
      try result.encode(to: encoder)
      try container.encode(body, forKey: .body)

    case .scopes(let result, let body):
      try result.encode(to: encoder)
      try container.encode(body, forKey: .body)

    case .stackTrace(let result, let body):
      try result.encode(to: encoder)
      try container.encode(body, forKey: .body)

    case .variables(let result, let body):
      try result.encode(to: encoder)
      try container.encode(body, forKey: .body)

    case .setExceptionBreakpoints(let result),
         .configurationDone(let result),
         .goto(let result),
         .next(let result),
         .stepIn(let result),
         .stepOut(let result),
         .error(let result),
         .launch(let result),
         .disconnect(let result):
      try result.encode(to: encoder)
    }
  }
}

public struct RequestResult: Codable {
  public var requestSeq: Int
  public var success: Bool
  public var message: String?

  private enum CodingKeys: String, CodingKey {
    case requestSeq = "request_seq"
    case success
    case message
  }

  public init(requestSeq: Int, success: Bool, message: String? = nil) {
    self.requestSeq = requestSeq
    self.success = success
    self.message = message
  }
}

public struct Capabilities: Codable {
  public var supportsConfigurationDoneRequest: Bool?
  public var supportsFunctionBreakpoints: Bool?
  public var supportsConditionalBreakpoints: Bool?
  public var supportsHitConditionalBreakpoints: Bool?
  public var supportsEvaluateForHovers: Bool?
  public var exceptionBreakpointFilters: [ExceptionBreakpointsFilter]?
  public var supportsStepBack: Bool?
  public var supportsSetVariable: Bool?
  public var supportsRestartFrame: Bool?
  public var supportsGotoTargetsRequest: Bool?
  public var supportsStepInTargetsRequest: Bool?
  public var supportsCompletionsRequest: Bool?
  public var completionTriggerCharacters: [String]?
  public var supportsModulesRequest: Bool?
  public var additionalModuleColumns: [ColumnDescriptor]?
  public var supportedChecksumAlgorithms: [ChecksumAlgorithm]?
  public var supportsRestartRequest: Bool?
  public var supportsExceptionOptions: Bool?
  public var supportsValueFormattingOptions: Bool?
  public var supportsExceptionInfoRequest: Bool?
  public var supportTerminateDebuggee: Bool?
  public var supportsDelayedStackTraceLoading: Bool?
  public var supportsLoadedSourcesRequest: Bool?
  public var supportsLogPoints: Bool?
  public var supportsTerminateThreadsRequest: Bool?
  public var supportsSetExpression: Bool?
  public var supportsTerminateRequest: Bool?
  public var supportsDataBreakpoints: Bool?
  public var supportsReadMemoryRequest: Bool?
  public var supportsDisassembleRequest: Bool?
  public var supportsCancelRequest: Bool?
  public var supportsBreakpointLocationsRequest: Bool?
  public var supportsClipboardContext: Bool?

  public init(supportsConfigurationDoneRequest: Bool? = nil,
              supportsFunctionBreakpoints: Bool? = nil,
              supportsConditionalBreakpoints: Bool? = nil,
              supportsHitConditionalBreakpoints: Bool? = nil,
              supportsEvaluateForHovers: Bool? = nil,
              exceptionBreakpointFilters: [ExceptionBreakpointsFilter]? = nil,
              supportsStepBack: Bool? = nil,
              supportsSetVariable: Bool? = nil,
              supportsRestartFrame: Bool? = nil,
              supportsGotoTargetsRequest: Bool? = nil,
              supportsStepInTargetsRequest: Bool? = nil,
              supportsCompletionsRequest: Bool? = nil,
              completionTriggerCharacters: [String]? = nil,
              supportsModulesRequest: Bool? = nil,
              additionalModuleColumns: [ColumnDescriptor]? = nil,
              supportedChecksumAlgorithms: [ChecksumAlgorithm]? = nil,
              supportsRestartRequest: Bool? = nil,
              supportsExceptionOptions: Bool? = nil,
              supportsValueFormattingOptions: Bool? = nil,
              supportsExceptionInfoRequest: Bool? = nil,
              supportTerminateDebuggee: Bool? = nil,
              supportsDelayedStackTraceLoading: Bool? = nil,
              supportsLoadedSourcesRequest: Bool? = nil,
              supportsLogPoints: Bool? = nil,
              supportsTerminateThreadsRequest: Bool? = nil,
              supportsSetExpression: Bool? = nil,
              supportsTerminateRequest: Bool? = nil,
              supportsDataBreakpoints: Bool? = nil,
              supportsReadMemoryRequest: Bool? = nil,
              supportsDisassembleRequest: Bool? = nil,
              supportsCancelRequest: Bool? = nil,
              supportsBreakpointLocationsRequest: Bool? = nil,
              supportsClipboardContext: Bool? = nil) {
    self.supportsConfigurationDoneRequest = supportsConfigurationDoneRequest
    self.supportsFunctionBreakpoints = supportsFunctionBreakpoints
    self.supportsConditionalBreakpoints = supportsConditionalBreakpoints
    self.supportsHitConditionalBreakpoints = supportsHitConditionalBreakpoints
    self.supportsEvaluateForHovers = supportsEvaluateForHovers
    self.exceptionBreakpointFilters = exceptionBreakpointFilters
    self.supportsStepBack = supportsStepBack
    self.supportsSetVariable = supportsSetVariable
    self.supportsRestartFrame = supportsRestartFrame
    self.supportsGotoTargetsRequest = supportsGotoTargetsRequest
    self.supportsStepInTargetsRequest = supportsStepInTargetsRequest
    self.supportsCompletionsRequest = supportsCompletionsRequest
    self.completionTriggerCharacters = completionTriggerCharacters
    self.supportsModulesRequest = supportsModulesRequest
    self.additionalModuleColumns = additionalModuleColumns
    self.supportedChecksumAlgorithms = supportedChecksumAlgorithms
    self.supportsRestartRequest = supportsRestartRequest
    self.supportsExceptionOptions = supportsExceptionOptions
    self.supportsValueFormattingOptions = supportsValueFormattingOptions
    self.supportsExceptionInfoRequest = supportsExceptionInfoRequest
    self.supportTerminateDebuggee = supportTerminateDebuggee
    self.supportsDelayedStackTraceLoading = supportsDelayedStackTraceLoading
    self.supportsLoadedSourcesRequest = supportsLoadedSourcesRequest
    self.supportsLogPoints = supportsLogPoints
    self.supportsTerminateThreadsRequest = supportsTerminateThreadsRequest
    self.supportsSetExpression = supportsSetExpression
    self.supportsTerminateRequest = supportsTerminateRequest
    self.supportsDataBreakpoints = supportsDataBreakpoints
    self.supportsReadMemoryRequest = supportsReadMemoryRequest
    self.supportsDisassembleRequest = supportsDisassembleRequest
    self.supportsCancelRequest = supportsCancelRequest
    self.supportsBreakpointLocationsRequest = supportsBreakpointLocationsRequest
    self.supportsClipboardContext = supportsClipboardContext
  }
}

public typealias SetFunctionBreakpointsResponse = SetBreakpointsResponse
public typealias SetDataBreakpointsResponse = SetBreakpointsResponse

public struct SetBreakpointsResponse: Codable {
  public var breakpoints: [Breakpoint]

  public init(breakpoints: [Breakpoint]) {
    self.breakpoints = breakpoints
  }
}

public struct ThreadsResponse: Codable {
  public var threads: [Thread]

  public init(threads: [Thread]) {
    self.threads = threads
  }
}

public struct StackTraceResponse: Codable {
  public var stackFrames: [StackFrame]
  public var totalFrames: Int?

  public init(stackFrames: [StackFrame], totalFrames: Int? = nil) {
    self.stackFrames = stackFrames
    self.totalFrames = totalFrames
  }
}

public struct ScopesResponse: Codable {
  public var scopes: [Scope]

  public init(scopes: [Scope]) {
    self.scopes = scopes
  }
}

public struct VariablesResponse: Codable {
  public var variables: [Variable]

  public init(variables: [Variable]) {
    self.variables = variables
  }
}

public struct ContinueResponse: Codable {
  public var allThreadsContinued: Bool?

  public init(allThreadsContinued: Bool?) {
    self.allThreadsContinued = allThreadsContinued
  }
}
