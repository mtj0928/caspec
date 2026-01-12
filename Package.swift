// swift-tools-version: 6.1
import PackageDescription

let package = Package(
    name: "AgentAdapter",
    platforms: [.macOS(.v15)],
    products: [
        .executable(name: "agent-adapter", targets: ["AgentAdapter"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-argument-parser.git", from: "1.2.0"),
        .package(url: "https://github.com/jpsim/Yams.git", from: "5.1.0"),
    ],
    targets: [
        .executableTarget(
            name: "AgentAdapter",
            dependencies: [
                "AgentAdapterCore",
                .product(name: "ArgumentParser", package: "swift-argument-parser"),
            ]
        ),
        .target(
            name: "AgentAdapterCore",
            dependencies: [
                .product(name: "Yams", package: "Yams")
            ]
        ),
        .testTarget(
            name: "AgentAdapterCoreTests",
            dependencies: [
                "AgentAdapterCore"
            ]
        )
    ]
)
