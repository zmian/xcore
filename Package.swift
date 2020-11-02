// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "Xcore",
    products: [
        .library(name: "Xcore", targets: ["Xcore"])
    ],
    dependencies: [
        .package(url: "https://github.com/SDWebImage/SDWebImage.git", from: "5.9.1")
    ],
    targets: [
        .target(name: "Xcore", path: "Sources"),
        .testTarget(name: "Tests", dependencies: ["Xcore"])
    ],
    swiftLanguageVersions: [.v5],
    platforms: [.iOS(.v13)]
)
