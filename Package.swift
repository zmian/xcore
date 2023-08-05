// swift-tools-version:5.7

import PackageDescription

let package = Package(
    name: "Xcore",
    platforms: [.iOS(.v15)],
    products: [
        .library(name: "Xcore", targets: ["Xcore"])
    ],
    dependencies: [
        // Manually doing 5.12.6, as "5.13.0" has memory leaks that consumes 50% more memory.
        // Once, future versions are fixed we can then upgrade.
        .package(url: "https://github.com/SDWebImage/SDWebImage.git", from: "5.12.6"),
        .package(url: "https://github.com/zmian/AnyCodable", branch: "master"),
        .package(url: "https://github.com/kishikawakatsumi/KeychainAccess", from: "4.2.2"),
        .package(url: "https://github.com/pointfreeco/swift-dependencies", from: "1.0.0")
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
