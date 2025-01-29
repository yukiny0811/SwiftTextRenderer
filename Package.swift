// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftTextRenderer",
    platforms: [
        .iOS(.v14),
        .macOS(.v13),
        .visionOS(.v1),
    ],
    products: [
        .library(
            name: "SwiftTextRenderer",
            targets: ["SwiftTextRenderer"]
        ),
    ],
    targets: [
        .target(
            name: "SwiftTextRenderer",
            resources: [
                .process("ShaderResources")
            ]
        ),
        .testTarget(
            name: "SwiftTextRendererTests",
            dependencies: ["SwiftTextRenderer"]
        ),
    ]
)
