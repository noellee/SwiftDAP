// swift-tools-version:4.0
import PackageDescription

let package = Package(
    name: "DebugAdapterProtocol",
    products: [
        .library(
            name: "DebugAdapterProtocol",
            targets: ["DebugAdapterProtocol"]),
    ],
    dependencies: [
    ],
    targets: [
        .target(
            name: "DebugAdapterProtocol",
            dependencies: []),
        .testTarget(
            name: "DebugAdapterProtocolTests",
            dependencies: ["DebugAdapterProtocol"]),
    ]
)
