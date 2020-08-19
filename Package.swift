// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "Utils",
    platforms: [
        .iOS(.v11),
        .watchOS(.v4)
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
            name: "Vector",
            targets: ["Vector"]
        ),
        .library(
            name: "MacawAdditions",
            targets: ["MacawAdditions"]
        )
    ],
    dependencies: [
        .package(
            url: "https://github.com/sroik/Macaw.git",
            .branch("master")
        ),
        .package(url: "https://github.com/pointfreeco/swift-snapshot-testing.git", from: "1.8.1"),
    ],
    targets: [
        .target(
            name: "UtilsCore",
            dependencies: [],
            path: "Utils/UtilsCore/Sources"
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
        .target(
            name: "Vector",
            dependencies: ["UtilsCore"],
            path: "Utils/Vector/Sources"
        ),
        .target(
            name: "MacawAdditions",
            dependencies: ["Vector", "Macaw"],
            path: "Utils/MacawAdditions/Sources"
        ),
        .testTarget(
            name: "UtilsTests",
            dependencies: ["UtilsCore", "Vector", "MacawAdditions", "SnapshotTesting"],
            path: "UtilsTests/Sources"
        ),
    ],
    swiftLanguageVersions: [
        .v5
    ]
)
