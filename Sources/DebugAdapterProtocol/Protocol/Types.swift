import Foundation

public enum PresentationHint: String, Codable {
  case normal, emphasize, deemphasize
}

public enum ChecksumAlgorithm: String, Codable {
  case md5 = "MD5"
  case sha1 = "SHA1"
  case sha256 = "SHA256"
  case timestamp = "timestamp"
}

public struct Source: Codable {
  public var name: String?
  public var path: String?
  public var sourceReference: Int?
  public var presentationHint: PresentationHint?
  public var origin: Int?
  public var sources: Int?
  public var adapterData: String?
  public var checksums: [Checksum]?
}

public struct Checksum: Codable {
  public var algorithm: ChecksumAlgorithm
  public var checksum: String
}

public struct SourceBreakpoint: Codable {
  public var line: Int
  public var column: Int?
  public var condition: String?
  public var hitCondition: String?
  public var logMessage: String?
}

public struct FunctionBreakpoint: Codable {
  public var name: String
  public var condition: String?
  public var hitCondition: String?
}

public struct Breakpoint: Codable {
  public var id: Int?
  public var verified: Bool
  public var message: String?
  public var source: Source?
  public var line: Int?
  public var column: Int?
  public var endLine: Int?
  public var endColumn: Int?
}

public struct DataBreakpoint: Codable {
  public var dataId: String
  public var accessType: DataBreakpointAccessType?
  public var condition: String?
  public var hitCondition: String?
}

public enum DataBreakpointAccessType: String, Codable {
  case read, write, readWrite
}

public struct ExceptionOptions: Codable {
  public var path: [ExceptionPathSegment]?
  public var breakMode: ExceptionBreakMode
}

public enum ExceptionBreakMode: String, Codable {
  case never, always, unhandled, userUnhandled
}

public struct ExceptionPathSegment: Codable {
  public var negate: Bool?
  public var names: [String]
}

public struct Thread: Codable {
  public var id: Int
  public var name: String
}

public struct StackFrame: Codable {
  public var id: Int
  public var name: String
  public var source: Source?
  public var line: Int
  public var column: Int
  public var endLine: Int?
  public var endColumn: Int?
  public var instructionPointerReference: String?
//  public var moduleId: String | Int
  public var presentationHint: PresentationHint?
}

public struct ValueFormat: Codable {
  public var hex: Bool?
}

public struct StackFrameFormat: Codable {
  public var hex: Bool?
  public var parameters: Bool?
  public var parameterTypes: Bool?
  public var parameterNames: Bool?
  public var parameterValues: Bool?
  public var line: Bool?
  public var module: Bool?
  public var includeAll: Bool?
}

public struct Scope: Codable {
  public var name: String
  public var presentationHint: PresentationHint?
  public var variablesReference: Int
  public var namedVariables: Int?
  public var indexedVariables: Int?
  public var expensive: Bool
  public var source: Source?
  public var line: Int?
  public var column: Int?
  public var endLine: Int?
  public var endColumn: Int?
}

public struct Variable: Codable {
  public var name: String
  public var value: String
  public var type: String?
  public var presentationHint: VariablePresentationHint?
  public var evaluateName: String?
  public var variablesReference: Int
  public var namedVariables: Int?
  public var indexedVariables: Int?
  public var memoryReference: Int?
}

public enum VariablePresentationHintKind: String, Codable {
  case property, method, `class`, data, event, baseClass, innerClass, interface, mostDerivedClass, virtual,
       dataBreakpoints
}

public enum VariablePresentationHintAttribute: String, Codable {
  case `static`, constant, readOnly, rawString, hasObjectId, canHaveObjectId, hasSideEffects
}

public struct VariablePresentationHint: Codable {
  public var kind: VariablePresentationHintKind
  public var attributes: [VariablePresentationHintAttribute]?
  public var visibility: String?
}
