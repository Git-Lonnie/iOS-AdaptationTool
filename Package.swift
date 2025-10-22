// swift-tools-version:5.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "WayneRpx",
    platforms: [
        .iOS(.v13)
    ],
    products: [
        .library(
            name: "WayneRpx",
            targets: ["WayneRpx"]),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "WayneRpx",
            dependencies: [],
            path: "Sources/WayneRpx"),
    ],
    swiftLanguageVersions: [.v5]
)

