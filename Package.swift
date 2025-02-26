// swift-tools-version:6.0

import PackageDescription

let package = Package(
    name: "Xcore",
    platforms: [.iOS(.v17)],
    products: [
        .library(name: "Xcore", targets: ["Xcore"])
    ],
    dependencies: [
        .package(url: "https://github.com/SDWebImage/SDWebImage.git", from: "5.17.0"),
        .package(url: "https://github.com/zmian/AnyCodable", branch: "master"),
        .package(url: "https://github.com/kishikawakatsumi/KeychainAccess", from: "4.2.2"),
        .package(url: "https://github.com/pointfreeco/swift-dependencies", from: "1.6.3"),
        .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.4.0")
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
    ],
    swiftLanguageModes: [.v6]
)
