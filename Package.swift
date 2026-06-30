// swift-tools-version:6.3

import PackageDescription

let package = Package(
    name: "Xcore",
    platforms: [.iOS(.v26)],
    products: [
        .library(name: "Xcore", targets: ["Xcore"])
    ],
    dependencies: [
        .package(url: "https://github.com/SDWebImage/SDWebImage.git", from: "5.21.7"),
        .package(url: "https://github.com/kishikawakatsumi/KeychainAccess", from: "4.2.2"),
        .package(url: "https://github.com/pointfreeco/swift-dependencies", from: "1.12.0"),
        .package(url: "https://github.com/apple/swift-docc-plugin", from: "1.4.0")
    ],
    targets: [
        .target(
            name: "Xcore",
            dependencies: [
                "SDWebImage",
                "KeychainAccess",
                .product(name: "Dependencies", package: "swift-dependencies")
            ],
            resources: [.process("Resources")]
        ),
        .testTarget(name: "XcoreTests", dependencies: ["Xcore"])
    ],
    swiftLanguageModes: [.v6]
)
