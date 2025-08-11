// swift-tools-version: 6.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import Foundation
import PackageDescription

let package = Package(
    name: "SwiftyLogger",
    platforms: [.iOS(.v13), .macOS(.v12)],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "SwiftyLogger",
            targets: ["SwiftyLogger"],
        ),
    ],
    dependencies: [
        .package(url: "https://github.com/SwiftyBeaver/SwiftyBeaver.git", from: "2.1.1"),
        .package(url: "https://github.com/realm/SwiftLint.git", from: "0.59.1"),
        .package(url: "https://github.com/nicklockwood/SwiftFormat", from: "0.57.2"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "SwiftyLogger",
            dependencies: [
                .product(name: "SwiftyBeaver", package: "SwiftyBeaver"),
            ],
            plugins: ProcessInfo.processInfo.environment["CI"] == "true" ? [] : [
                .plugin(name: "SwiftLintBuildToolPlugin", package: "SwiftLint"),
            ],
        ),
        .testTarget(
            name: "SwiftyLoggerTests",
            dependencies: ["SwiftyLogger"],
        ),
    ],
)
