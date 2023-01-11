// swift-tools-version:5.7

import PackageDescription

let package = Package(
    name: "Xcore",
    platforms: [.iOS(.v15)],
    products: [
        .library(name: "Xcore", targets: ["Xcore"])
    ],
    dependencies: [
        .package(url: "https://github.com/SDWebImage/SDWebImage.git", from: "5.8.2"),
        .package(url: "https://github.com/zmian/AnyCodable", branch: "master"),
        .package(url: "https://github.com/kishikawakatsumi/KeychainAccess", from: "4.2.2"),
        .package(url: "https://github.com/pointfreeco/swift-dependencies", from: "0.1.3")
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
            resources: [.process("Resources")]
        ),
        .testTarget(name: "XcoreTests", dependencies: ["Xcore"])
    ]
)
