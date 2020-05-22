import Foundation

public enum ProtocolMessage: MirroredEnum, Codable {
  private enum CodingKeys: String, CodingKey {
    case seq
    case type
  }

  case request(seq: Int, request: RequestMessage)
  case response(seq: Int, response: ResponseMessage)
  case event(seq: Int, event: EventMessage)

  public init(from decoder: Decoder) throws {
    let container = try decoder.container(keyedBy: CodingKeys.self)
    let seq = try container.decode(Int.self, forKey: .seq)
    let type = try container.decode(String.self, forKey: .type)
    switch type {
    case "request": self = .request(seq: seq, request: try RequestMessage.init(from: decoder))
    case "response": self = .response(seq: seq, response: try ResponseMessage.init(from: decoder))
    case "event": self = .event(seq: seq, event: try EventMessage.init(from: decoder))
    default: fatalError("Message type \"\(type)\" not supported")
    }
  }

  public func encode(to encoder: Encoder) throws {
    var container = encoder.container(keyedBy: CodingKeys.self)
    try container.encode(self.label, forKey: .type)
    switch self {
    case .request(let seq, let message as Encodable),
         .response(let seq, let message as Encodable),
         .event(let seq, let message as Encodable):
      try container.encode(seq, forKey: .seq)
      try message.encode(to: encoder)
    }
  }
}
