// swift-tools-version:5.5
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftNetLayer",
    platforms: [
       .macOS(.v12),
       .iOS(.v13)
    ],
    products: [
        .library(name: "SwiftNetLayer", targets: ["SwiftNetLayer"]),
    ],
    dependencies: [
        .package(name: "SwiftExtensionsPack", url: "https://github.com/nerzh/swift-extensions-pack.git", .upToNextMajor(from: "1.2.0")),
    ],
    targets: [
        .target(
            name: "SwiftNetLayer",
            dependencies: [
                .product(name: "SwiftExtensionsPack", package: "SwiftExtensionsPack")
            ])
    ]
)
