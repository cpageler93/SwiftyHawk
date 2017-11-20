// swift-tools-version:4.0
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftyHawk",
    products: [
        .library(name: "SwiftyHawk", targets: ["SwiftyHawk"]),
    ],
    dependencies: [
        .package(url: "https://github.com/krzyzanowskim/CryptoSwift", from: "0.8.0"),
    ],
    targets: [
        .target(name: "SwiftyHawk", dependencies: ["CryptoSwift"]),
        .testTarget(name: "SwiftyHawkTests", dependencies: ["SwiftyHawk"]),
    ]
)
