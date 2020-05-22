import Foundation

protocol MirroredEnum {
}

extension MirroredEnum {
  var label: String {
    let reflection = Mirror(reflecting: self)
    guard reflection.displayStyle == .enum, let associated = reflection.children.first else {
      return "\(self)"
    }
    return associated.label!
  }
}
