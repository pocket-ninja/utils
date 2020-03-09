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
            name: "Alert",
            targets: ["Alert"]
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
            path: "Utils/UtilsCore/Sources"
        ),
        .target(
            name: "Analytics",
            dependencies: ["UtilsCore"],
            path: "Utils/Analytics/Core/Sources"
        ),
        .target(
            name: "Alert",
            dependencies: [],
            path: "Utils/Alert/Sources"
        ),
        .target(
            name: "AnalyticsFacebookDrain",
            dependencies: ["Analytics", "FacebookCore"],
            path: "Utils/Analytics/Facebook/Sources"
        ),
        .testTarget(
            name: "UtilsTests",
            dependencies: ["UtilsCore", "Analytics"],
            path: "UtilsTests/Sources"
        ),
    ],
    swiftLanguageVersions: [
        .v5
    ]
)
