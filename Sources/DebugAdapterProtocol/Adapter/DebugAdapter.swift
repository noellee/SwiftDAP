import Foundation

public typealias ProtocolMessageSender = (ProtocolMessage) -> Void

public class DebugAdapter {
  private let logger: Logger?
  private let input: FileHandle
  private let output: FileHandle
  private var buffer: Data
  private var contentLength: Int
  private var messageHandler: ProtocolMessageHandler?

  public init(_ input: FileHandle = FileHandle.standardInput,
              _ output: FileHandle = FileHandle.standardOutput,
              _ logger: Logger? = nil) {
    self.logger = logger
    self.input = input
    self.output = output
    self.buffer = Data()
    self.contentLength = -1
  }

  public func withMessageHandler(_ messageHandlerFactory: (@escaping ProtocolMessageSender) -> ProtocolMessageHandler)
          -> DebugAdapter {
    self.messageHandler = messageHandlerFactory(self.send)
    return self
  }

  private func send(_ message: ProtocolMessage) {
    let encoder = JSONEncoder()
    let data = try! encoder.encode(message)
    let header = "Content-Length: \(data.count)\r\n\r\n".data(using: .utf8)!
    self.output.write(header + data)
    log("Sent: \(String(data: data, encoding: .utf8)!)")
  }

  private func handleData(_ data: Data) {
    log("Received: \(data)", level: .debug)
    self.buffer.append(data)
    while true {
      if self.contentLength >= 0 {
        log("Reading \(contentLength) bytes of data", level: .debug)
        if self.buffer.count >= self.contentLength {
          guard let message = String(data: buffer.subdata(in: 0..<self.contentLength), encoding: .utf8) else {
            continue
          }
          self.buffer = self.buffer.subdata(in: self.contentLength..<self.buffer.count)
          log("Received: \(message)")
          self.contentLength = -1
          if message.count > 0 {
            log("Decoding message", level: .debug)
            do {
              let decoder = JSONDecoder()
              let messageData = try decoder.decode(ProtocolMessage.self, from: message.data(using: .utf8)!)
              log("Decode successful", level: .debug)
              self.messageHandler?.handle(message: messageData)
            } catch let error {
              log("Decoding message failed: \(error)", level: .error)
              let err = ResponseMessage.error(RequestResult(requestSeq: 0, success: false, message: "\(error)"))
              self.send(.response(seq: 0, response: err))
            }
          }
          continue
        }
      } else {
        if let newline = self.buffer.range(of: "\r\n".data(using: .utf8)!) {
          let range: Range<Int> = 0..<newline.lowerBound
          let header = String(data: self.buffer.subdata(in: range), encoding: .utf8)!
          for line in header.components(separatedBy: .newlines) {
            let pair = line.split(separator: " ")
            if pair.count == 2 && pair[0] == "Content-Length:" {
              self.contentLength = Int(pair[1])!
            }
          }
          self.buffer = self.buffer.subdata(in: newline.upperBound + 2..<self.buffer.count)
          continue
        }
      }
      break
    }
  }

  public func start() {
    log("Start listening...")
    while true {
      let data = self.input.availableData
      if !data.isEmpty {
        self.handleData(data)
      }
    }
  }

  private func log(_ message: CustomStringConvertible, level: LoggingLevel) {
    logger?.log(message, level: level)
  }

  private func log(_ message: CustomStringConvertible) {
    logger?.log(message)
  }
}
