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
        ),
        .library(
            name: "Vector",
            targets: ["Vector"]
        ),
        .library(
            name: "MacawAdditions",
            targets: ["MacawAdditions"]
        ),
        .library(
            name: "RxPocket",
            targets: ["RxPocket"]
        ),
    ],
    dependencies: [
        .package(
            url: "https://github.com/sroik/Macaw.git",
            .branch("master")
        ),
        .package(
            url: "https://github.com/ReactiveX/RxSwift.git",
            from: "5.0.0"
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
        .target(
            name: "RxPocket",
            dependencies: ["RxSwift", "RxRelay"],
            path: "Utils/RxPocket/Sources"
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
