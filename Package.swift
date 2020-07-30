// swift-tools-version:5.1

import PackageDescription

let package = Package(
    name: "Utils",
    platforms: [
        .iOS(.v11),
        .watchOS(.v4),
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
            dependencies: ["UtilsCore", "Analytics", "Vector", "MacawAdditions", "RxPocket"],
            path: "UtilsTests/Sources"
        ),
    ],
    swiftLanguageVersions: [
        .v5
    ]
)
