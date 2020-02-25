// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "Utils",
    platforms: [
        .iOS(.v11)
    ],
    products: [
        .library(
            name: "Utils",
            targets: ["Utils"]
        ),
    ],
    dependencies: [],
    targets: [
        .target(
            name: "Utils",
            dependencies: [],
            path: "Sources/Utils"
        ),
        .testTarget(
            name: "UtilsTests",
            dependencies: ["Utils"]
        ),
    ],
    swiftLanguageVersions: [
        .v5
    ]
)
