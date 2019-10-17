// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "xccov2lcov",
    products: [
        .executable(name: "xccov2lcov", targets: ["xccov2lcov"])
    ],
    dependencies: [
        .package(url: "https://github.com/kylef/Commander", from: "0.9.1")
    ],
    targets: [
        .target(
            name: "XCCovLib",
            dependencies: []),
        .target(
            name: "xccov2lcov",
            dependencies: ["XCCovLib", "Commander"]),
        .testTarget(
            name: "xccov2lcovTests",
            dependencies: ["xccov2lcov"]),
    ]
)
