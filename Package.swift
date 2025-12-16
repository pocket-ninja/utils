// swift-tools-version:5.9

import PackageDescription

let package = Package(
    name: "Utils",
    platforms: [
        .iOS(.v15),
        .watchOS(.v9),
        .macOS(.v13)
    ],
    products: [
        .library(
            name: "UtilsCore",
            type: .dynamic,
            targets: ["UtilsCore"]
        ),
        .library(
            name: "PocketSharing",
            type: .dynamic,
            targets: ["PocketSharing"]
        ),
        .library(
            name: "Vector",
            type: .dynamic,
            targets: ["Vector"]
        )
    ],
    dependencies: [
        .package(url: "https://github.com/pointfreeco/swift-snapshot-testing.git", from: "1.10.0"),
        .package(url: "https://github.com/apple/swift-algorithms.git", from: "1.2.0"),
    ],
    targets: [
        .target(
            name: "UtilsCore",
            dependencies: [
                .product(name: "Algorithms", package: "swift-algorithms"),
            ],
            path: "Utils/UtilsCore/Sources"
        ),
        .target(
            name: "PocketSharing",
            dependencies: [],
            path: "Utils/Sharing/Sources"
        ),
        .target(
            name: "Vector",
            dependencies: ["UtilsCore"],
            path: "Utils/Vector/Sources"
        ),
        .testTarget(
            name: "UtilsTests",
            dependencies: [
                "UtilsCore",
                "Vector",
                .product(name: "SnapshotTesting", package: "swift-snapshot-testing"),
            ],
            path: "UtilsTests/Sources"
        ),
    ],
    swiftLanguageVersions: [
        .v5
    ]
)
