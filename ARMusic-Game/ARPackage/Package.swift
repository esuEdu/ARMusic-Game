// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "ARPackage",
    platforms: [
        // platforms define the version of OS.
        .iOS(.v17),
        .visionOS(.v1)
    ],
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "ARPackage",
            targets: ["ARPackage"]),
    ],
    dependencies: [
        .package(path: "../DataPackage"),
        .package(path: "../AudioPackage")
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "ARPackage",
            dependencies: [
                .product(name: "DataPackage", package: "DataPackage", condition: nil),
                .product(name: "AudioPackage", package: "AudioPackage", condition: nil),
            ]
        ),
        .testTarget(
            name: "ARPackageTests",
            dependencies: ["ARPackage"]),
    ]
)
