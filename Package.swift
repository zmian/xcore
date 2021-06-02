// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "Xcore",
    platforms: [.iOS(.v13)],
    products: [
        .library(name: "Xcore", targets: ["Xcore"])
    ],
    dependencies: [
        .package(url: "https://github.com/SDWebImage/SDWebImage", from: "5.9.1")
    ],
    targets: [
        .target(
            name: "Xcore",
            dependencies: ["SDWebImage"],
            path: "Sources",
            exclude: ["Supporting Files/Info.plist"],
            resources: [
                .process("Supporting Files/Assets.xcassets")
            ]
        )
    ]
)

        //,
        // .testTarget(name: "UnitTests", dependencies: ["Xcore"], path: "UnitTests")
