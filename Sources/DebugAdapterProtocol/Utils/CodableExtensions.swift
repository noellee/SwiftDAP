// https://gist.github.com/sukov/d3834c0e7b72e4f7575f753b352f6ddd

struct GenericCodingKeys: CodingKey {
  var stringValue: String

  init(stringValue: String) {
    self.stringValue = stringValue
  }

  var intValue: Int?

  init?(intValue: Int) {
    self.init(stringValue: "\(intValue)")
    self.intValue = intValue
  }
}

extension KeyedDecodingContainer {
  func decode(_ type: [String: Any].Type, forKey key: K) throws -> [String: Any] {
    let container = try nestedContainer(keyedBy: GenericCodingKeys.self, forKey: key)
    return try container.decode(type)
  }

  func decode(_ type: [Any].Type, forKey key: K) throws -> [Any] {
    var container = try nestedUnkeyedContainer(forKey: key)
    return try container.decode(type)
  }

  func decode(_ type: [String: Any].Type) throws -> [String: Any] {
    var dictionary = [String: Any]()

    for key in allKeys {
      if let boolValue = try? decode(Bool.self, forKey: key) {
        dictionary[key.stringValue] = boolValue
      } else if let intValue = try? decode(Int.self, forKey: key) {
        dictionary[key.stringValue] = intValue
      } else if let stringValue = try? decode(String.self, forKey: key) {
        dictionary[key.stringValue] = stringValue
      } else if let doubleValue = try? decode(Double.self, forKey: key) {
        dictionary[key.stringValue] = doubleValue
      } else if let nestedDictionary = try? decode([String: Any].self, forKey: key) {
        dictionary[key.stringValue] = nestedDictionary
      } else if let nestedArray = try? decode([Any].self, forKey: key) {
        dictionary[key.stringValue] = nestedArray
      } else if let isValueNil = try? decodeNil(forKey: key), isValueNil == true {
        dictionary[key.stringValue] = nil
      } else {
        throw DecodingError.dataCorrupted(
            DecodingError.Context(codingPath: codingPath + [key], debugDescription: "Unable to decode value"))
      }
    }
    return dictionary
  }
}

extension UnkeyedDecodingContainer {
  mutating func decode(_ type: [Any].Type) throws -> [Any] {
    var array: [Any] = []

    while isAtEnd == false {
      if let value = try? decode(Bool.self) {
        array.append(value)
      } else if let value = try? decode(Int.self) {
        array.append(value)
      } else if let value = try? decode(String.self) {
        array.append(value)
      } else if let value = try? decode(Double.self) {
        array.append(value)
      } else if let nestedDictionary = try? decode([String: Any].self) {
        array.append(nestedDictionary)
      } else if let nestedArray = try? decodeNestedArray([Any].self) {
        array.append(nestedArray)
      } else if let isValueNil = try? decodeNil(), isValueNil == true {
        array.append(Any?.none as Any)
      } else {
        throw DecodingError.dataCorrupted(
            DecodingError.Context(codingPath: codingPath, debugDescription: "Unable to decode value"))
      }
    }
    return array
  }

  mutating func decode(_ type: [String: Any].Type) throws -> [String: Any] {
    let container = try nestedContainer(keyedBy: GenericCodingKeys.self)
    return try container.decode(type)
  }

  mutating func decodeNestedArray(_ type: [Any].Type) throws -> [Any] {
    var container = try nestedUnkeyedContainer()
    return try container.decode(type)
  }
}

extension KeyedEncodingContainerProtocol where Key == GenericCodingKeys {
  mutating func encode(_ value: [String: Any]) throws {
    for (key, value) in value {
      let key = GenericCodingKeys(stringValue: key)
      switch value {
      case let value as Bool:
        try encode(value, forKey: key)
      case let value as Int:
        try encode(value, forKey: key)
      case let value as String:
        try encode(value, forKey: key)
      case let value as Double:
        try encode(value, forKey: key)
      case let value as [String: Any]:
        try encode(value, forKey: key)
      case let value as [Any]:
        try encode(value, forKey: key)
      case Optional<Any>.none:
        try encodeNil(forKey: key)
      default:
        throw EncodingError.invalidValue(
            value,
            EncodingError.Context(codingPath: codingPath + [key], debugDescription: "Invalid JSON value"))
      }
    }
  }
}

extension KeyedEncodingContainerProtocol {
  mutating func encode(_ value: [String: Any]?, forKey key: Key) throws {
    guard let value = value else { return }

    var container = nestedContainer(keyedBy: GenericCodingKeys.self, forKey: key)
    try container.encode(value)
  }

  mutating func encode(_ value: [Any]?, forKey key: Key) throws {
    guard let value = value else { return }

    var container = nestedUnkeyedContainer(forKey: key)
    try container.encode(value)
  }
}

extension UnkeyedEncodingContainer {
  mutating func encode(_ value: [Any]) throws {
    for (index, value) in value.enumerated() {
      switch value {
      case let value as Bool:
        try encode(value)
      case let value as Int:
        try encode(value)
      case let value as String:
        try encode(value)
      case let value as Double:
        try encode(value)
      case let value as [String: Any]:
        try encode(value)
      case let value as [Any]:
        try encodeNestedArray(value)
      case Optional<Any>.none:
        try encodeNil()
      default:
        let keys = GenericCodingKeys(intValue: index).map({ [ $0 ] }) ?? []
        throw EncodingError.invalidValue(
            value,
            EncodingError.Context(codingPath: codingPath + keys, debugDescription: "Invalid JSON value"))
      }
    }
  }

  mutating func encode(_ value: [String: Any]) throws {
    var container = nestedContainer(keyedBy: GenericCodingKeys.self)
    try container.encode(value)
  }

  mutating func encodeNestedArray(_ value: [Any]) throws {
    var container = nestedUnkeyedContainer()
    try container.encode(value)
  }
}
