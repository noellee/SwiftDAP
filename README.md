# SwiftDAP

Swift SDK for Microsoft's [Debug Adapter Protocol](https://microsoft.github.io/debug-adapter-protocol)

**Note:** Still in alpha development - features are incomplete!

## User Guide

This is the most basic way to use the provided `DebugAdapter`.
`.start()` tells the adapter to start listening to incoming DAP messages from the `input` passed into the `DebugAdapter`'s constructor.

```swift
import DebugAdapterProtocol

let input = FileHandle.standardInput
let output = FileHandle.standardOutput

DebugAdapter(input, output).start()
```

At this point, the only thing it'll do is listen to DAP messages and parse them, but it does not do anything about them.
So, you'll have to implement a `ProtocolMessageHandler` to handle these messages.

```swift
class ExampleHandler: ProtocolMessageHandler {
  func handle(message: ProtocolMessage) {
    // do something about the incoming message
  }
}
```

You can pass a factory method to create your message handler into the `DebugAdapter` as such:

```swift
DebugAdapter(input, output)
  .withMessageHandler { sender in ExampleHandler(...) }
  .start()
```

The `sender` argument in the factory method is a `ProtocolMessageSender`, which is basically a function that takes in a
`ProtocolMessage` and sends it via the `DebugAdapter`. You'll probably need this in your `ProtocolMessageHandler` if you
want to respond to requests.

### Full Example

```swift
import DebugAdapterProtocol

class MessageHandler: ProtocolMessageHandler {
  let send: ProtocolMessageSender

  init(_ send: ProtocolMessageSender) {
    self.send = send
  }

  func handle(message: ProtocolMessage) {
    switch message {
    case .request(seq: let seq, request: let request):
      send(.response(seq: seq, response: /* ... */))
    default:
      break
    }
  }
}

main() {
  DebugAdapter(input, output)
    .withMessageHandler { sender in MessageHandler(sender) }
    .start()
}
```
