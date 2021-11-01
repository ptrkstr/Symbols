// swift-tools-version:5.3

import PackageDescription

let package = Package(
    name: "Symbols",
    platforms: [
        .iOS(.v13),
        .tvOS(.v13),
        .watchOS(.v6),
        .macOS(.v11)
    ],
    products: [
        .library(
            name: "Symbols",
            targets: ["Symbols"]
        ),
    ],
    targets: [
        .target(
            name: "Symbols",
            dependencies: []
        ),
        .testTarget(
            name: "SymbolsTests",
            dependencies: ["Symbols"]),
    ]
)
