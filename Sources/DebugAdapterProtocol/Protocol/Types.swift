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

public struct ExceptionBreakpointsFilter: Codable {
  public var filter: String
  public var label: String
  public var `default`: Bool?

  public init(filter: String, label: String, `default`: Bool? = nil) {
    self.filter = filter
    self.label = label
    self.default = `default`
  }
}

public enum ColumnDescriptorType: String, Codable {
  case string, number, boolean, unixTimestampUTC
}

public struct ColumnDescriptor: Codable {
  public var attributeName: String
  public var label: String
  public var format: String?
  public var type: ColumnDescriptorType?
  public var width: Int?

  public init(attributeName: String,
              label: String,
              format: String? = nil,
              type: ColumnDescriptorType? = nil,
              width: Int? = nil) {
    self.attributeName = attributeName
    self.label = label
    self.format = format
    self.type = type
    self.width = width
  }
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

  public init(name: String? = nil,
              path: String? = nil,
              sourceReference: Int? = nil,
              presentationHint: PresentationHint? = nil,
              origin: Int? = nil,
              sources: Int? = nil,
              adapterData: String? = nil,
              checksums: [Checksum]? = nil) {
    self.name = name
    self.path = path
    self.sourceReference = sourceReference
    self.presentationHint = presentationHint
    self.origin = origin
    self.sources = sources
    self.adapterData = adapterData
    self.checksums = checksums
  }
}

public struct Checksum: Codable {
  public var algorithm: ChecksumAlgorithm
  public var checksum: String

  public init(algorithm: ChecksumAlgorithm, checksum: String) {
    self.algorithm = algorithm
    self.checksum = checksum
  }
}

public struct SourceBreakpoint: Codable {
  public var line: Int
  public var column: Int?
  public var condition: String?
  public var hitCondition: String?
  public var logMessage: String?

  public init(line: Int,
              column: Int? = nil,
              condition: String? = nil,
              hitCondition: String? = nil,
              logMessage: String? = nil) {
    self.line = line
    self.column = column
    self.condition = condition
    self.hitCondition = hitCondition
    self.logMessage = logMessage
  }
}

public struct FunctionBreakpoint: Codable {
  public var name: String
  public var condition: String?
  public var hitCondition: String?

  public init(name: String, condition: String? = nil, hitCondition: String? = nil) {
    self.name = name
    self.condition = condition
    self.hitCondition = hitCondition
  }
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

  public init(id: Int? = nil,
              verified: Bool,
              message: String? = nil,
              source: Source? = nil,
              line: Int? = nil,
              column: Int? = nil,
              endLine: Int? = nil,
              endColumn: Int? = nil) {
    self.id = id
    self.verified = verified
    self.message = message
    self.source = source
    self.line = line
    self.column = column
    self.endLine = endLine
    self.endColumn = endColumn
  }
}

public struct DataBreakpoint: Codable {
  public var dataId: String
  public var accessType: DataBreakpointAccessType?
  public var condition: String?
  public var hitCondition: String?

  public init(dataId: String,
              accessType: DataBreakpointAccessType? = nil,
              condition: String? = nil,
              hitCondition: String? = nil) {
    self.dataId = dataId
    self.accessType = accessType
    self.condition = condition
    self.hitCondition = hitCondition
  }
}

public enum DataBreakpointAccessType: String, Codable {
  case read, write, readWrite
}

public struct ExceptionOptions: Codable {
  public var path: [ExceptionPathSegment]?
  public var breakMode: ExceptionBreakMode

  public init(path: [ExceptionPathSegment]? = nil, breakMode: ExceptionBreakMode) {
    self.path = path
    self.breakMode = breakMode
  }
}

public enum ExceptionBreakMode: String, Codable {
  case never, always, unhandled, userUnhandled
}

public struct ExceptionPathSegment: Codable {
  public var negate: Bool?
  public var names: [String]

  public init(negate: Bool? = nil, names: [String]) {
    self.negate = negate
    self.names = names
  }
}

public struct Thread: Codable {
  public var id: Int
  public var name: String

  public init(id: Int, name: String) {
    self.id = id
    self.name = name
  }
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

  public init(id: Int,
              name: String,
              source: Source? = nil,
              line: Int,
              column: Int,
              endLine: Int? = nil,
              endColumn: Int? = nil,
              instructionPointerReference: String? = nil,
              presentationHint: PresentationHint? = nil) {
    self.id = id
    self.name = name
    self.source = source
    self.line = line
    self.column = column
    self.endLine = endLine
    self.endColumn = endColumn
    self.instructionPointerReference = instructionPointerReference
    self.presentationHint = presentationHint
  }
}

public struct ValueFormat: Codable {
  public var hex: Bool?

  public init(hex: Bool? = nil) {
    self.hex = hex
  }
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

  public init(hex: Bool? = nil,
              parameters: Bool? = nil,
              parameterTypes: Bool? = nil,
              parameterNames: Bool? = nil,
              parameterValues: Bool? = nil,
              line: Bool? = nil,
              module: Bool? = nil,
              includeAll: Bool? = nil) {
    self.hex = hex
    self.parameters = parameters
    self.parameterTypes = parameterTypes
    self.parameterNames = parameterNames
    self.parameterValues = parameterValues
    self.line = line
    self.module = module
    self.includeAll = includeAll
  }
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

  public init(name: String,
              presentationHint: PresentationHint? = nil,
              variablesReference: Int,
              namedVariables: Int? = nil,
              indexedVariables: Int? = nil,
              expensive: Bool,
              source: Source? = nil,
              line: Int? = nil,
              column: Int? = nil,
              endLine: Int? = nil,
              endColumn: Int? = nil) {
    self.name = name
    self.presentationHint = presentationHint
    self.variablesReference = variablesReference
    self.namedVariables = namedVariables
    self.indexedVariables = indexedVariables
    self.expensive = expensive
    self.source = source
    self.line = line
    self.column = column
    self.endLine = endLine
    self.endColumn = endColumn
  }
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

  public init(name: String,
              value: String,
              type: String? = nil,
              presentationHint: VariablePresentationHint? = nil,
              evaluateName: String? = nil,
              variablesReference: Int,
              namedVariables: Int? = nil,
              indexedVariables: Int? = nil,
              memoryReference: Int? = nil) {
    self.name = name
    self.value = value
    self.type = type
    self.presentationHint = presentationHint
    self.evaluateName = evaluateName
    self.variablesReference = variablesReference
    self.namedVariables = namedVariables
    self.indexedVariables = indexedVariables
    self.memoryReference = memoryReference
  }
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

  public init(kind: VariablePresentationHintKind,
              attributes: [VariablePresentationHintAttribute]? = nil,
              visibility: String? = nil) {
    self.kind = kind
    self.attributes = attributes
    self.visibility = visibility
  }
}

public enum SteppingGranularity: String, Codable {
  case statement, line, instruction
}