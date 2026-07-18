// swift-tools-version: 5.9
import PackageDescription

let package = Package(
    name: "ForgeEngine",
    platforms: [.iOS(.v17), .macOS(.v14)],
    products: [
        .library(name: "ForgeEngine", targets: ["ForgeEngine"])
    ],
    targets: [
        .target(name: "ForgeEngine"),
        .testTarget(name: "ForgeEngineTests", dependencies: ["ForgeEngine"])
    ]
)
