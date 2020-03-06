// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "Utils",
    platforms: [
        .iOS(.v11)
    ],
    products: [
        .library(
            name: "UtilsCore",
            targets: ["UtilsCore"]
        ),
        .library(
            name: "Analytics",
            targets: ["Analytics"]
        ),
        .library(
            name: "AnalyticsFacebookDrain",
            targets: ["AnalyticsFacebookDrain"]
        )
    ],
    dependencies: [
         .package(url: "https://github.com/facebook/facebook-ios-sdk", from: "6.0.0")
    ],
    targets: [
        .target(
            name: "UtilsCore",
            dependencies: [],
            path: "Sources/Core"
        ),
        .target(
            name: "Analytics",
            dependencies: ["UtilsCore"],
            path: "Sources/Analytics/Core"
        ),
        .target(
            name: "AnalyticsFacebookDrain",
            dependencies: ["Analytics", "FacebookCore"],
            path: "Sources/Analytics/Facebook"
        ),
        .testTarget(
            name: "UtilsTests",
            dependencies: ["UtilsCore", "Analytics"]
        ),
    ],
    swiftLanguageVersions: [
        .v5
    ]
)
