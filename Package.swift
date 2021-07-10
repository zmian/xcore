// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "Xcore",
    platforms: [.iOS(.v14)],
    products: [
        .library(name: "Xcore", targets: ["Xcore"])
    ],
    dependencies: [
        .package(url: "https://github.com/SDWebImage/SDWebImage", from: "5.9.1")
    ],
    targets: [
        .target(
            name: "Xcore",
            dependencies: ["SDWebImage"]
        ),
        .testTarget(name: "XcoreTests", dependencies: ["Xcore"])
    ]
)
