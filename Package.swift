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
            name: "Sharing",
            targets: ["Sharing"]
        ),
        .library(
            name: "Analytics",
            targets: ["Analytics"]
        )
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
            name: "Sharing",
            dependencies: [],
            path: "Utils/Sharing/Sources"
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
