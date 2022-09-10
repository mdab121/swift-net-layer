// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftNetLayer",
    products: [
        .library(name: "SwiftNetLayer", targets: ["SwiftNetLayer"]),
    ],
    dependencies: [
        .package(url: "https://github.com/nerzh/swift-extensions-pack.git", from: "1.0.0"),
    ],
    targets: [
        .target(
            name: "SwiftNetLayer", dependencies: ["SwiftExtensionsPack"]),
        .testTarget(
            name: "SwiftNetLayerTests", dependencies: ["SwiftNetLayer"]),
    ]
)
