// swift-tools-version:5.5

import PackageDescription

let package = Package(
    name: "Xcore",
    platforms: [.iOS(.v14)],
    products: [
        .library(name: "Xcore", targets: ["Xcore"])
    ],
    dependencies: [
        .package(url: "https://github.com/SDWebImage/SDWebImage", from: "5.8.2"),
        .package(url: "https://github.com/Flight-School/AnyCodable", from: "0.6.1")
    ],
    targets: [
        .target(
            name: "Xcore",
            dependencies: ["SDWebImage", "AnyCodable"]
        ),
        .testTarget(name: "XcoreTests", dependencies: ["Xcore"])
    ]
)
