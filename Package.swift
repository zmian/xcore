// swift-tools-version:5.9

import PackageDescription

let package = Package(
    name: "Xcore",
    platforms: [.iOS(.v16), .watchOS(.v10)],
    products: [
        .library(name: "Xcore", targets: ["Xcore"])
    ],
    dependencies: [
        .package(url: "https://github.com/SDWebImage/SDWebImage.git", from: "5.12.6"),
        .package(url: "https://github.com/zmian/AnyCodable", branch: "master"),
        .package(url: "https://github.com/kishikawakatsumi/KeychainAccess", from: "4.2.2"),
        .package(url: "https://github.com/pointfreeco/swift-dependencies", from: "1.2.1"),
        .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.0.0")
    ],
    targets: [
        .target(
            name: "Xcore",
            dependencies: [
                "SDWebImage",
                "AnyCodable",
                "KeychainAccess",
                .product(name: "Dependencies", package: "swift-dependencies")
            ],
            resources: [.process("Resources")],
            swiftSettings: [.enableExperimentalFeature("StrictConcurrency=targeted")]
        ),
        .testTarget(name: "XcoreTests", dependencies: ["Xcore"])
    ]
)
