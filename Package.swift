// swift-tools-version: 6.2
import PackageDescription

let package = Package(
    name: "CASpec",
    platforms: [.macOS(.v15)],
    products: [
        .executable(name: "caspec", targets: ["caspec"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.2.0"),
        .package(url: "https://github.com/jpsim/Yams.git", from: "5.1.0"),
    ],
    targets: [
        .executableTarget(
            name: "caspec",
            dependencies: [
                "CASpecCore",
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ]
        ),
        .target(
            name: "CASpecCore",
            dependencies: [
                .product(name: "Yams", package: "Yams")
            ]
        ),
        .testTarget(
            name: "CASpecCoreTests",
            dependencies: [
                "CASpecCore"
            ]
        )
    ]
)
