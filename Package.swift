// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "Xcore",
    platforms: [.iOS(.v14)],
    products: [
        .library(name: "Xcore", targets: ["Xcore"])
    ],
    dependencies: [
        .package(name: "SDWebImage", url: "https://github.com/SDWebImage/SDWebImage.git", from: "5.8.2"),
        .package(url: "https://github.com/Flight-School/AnyCodable", from: "0.6.1"),
        .package(url: "https://github.com/kishikawakatsumi/KeychainAccess", from: "4.2.2")
    ],
    targets: [
        .target(
            name: "Xcore",
            dependencies: ["SDWebImage", "AnyCodable", "KeychainAccess"],
            resources: [.process("Resources")]
        ),
        .testTarget(name: "XcoreTests", dependencies: ["Xcore"])
    ]
)
