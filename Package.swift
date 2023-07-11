// swift-tools-version:5.7

import PackageDescription

let package = Package(
    name: "Utils",
    platforms: [
        .iOS(.v14),
        .watchOS(.v6),
        .macOS(.v10_15)
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
    ],
    targets: [
        .target(
            name: "UtilsCore",
            dependencies: [],
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
