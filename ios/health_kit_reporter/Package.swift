// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "health_kit_reporter",
    platforms: [
        .iOS("9.0")
    ],
    products: [
        .library(name: "health-kit-reporter", targets: ["health_kit_reporter"])
    ],
    dependencies: [
        .package(name: "FlutterFramework", path: "../FlutterFramework"),
        .package(
            url: "https://github.com/quentinleguennec/HealthKitReporter.git",
            exact: "3.1.0"
        )
    ],
    targets: [
        .target(
            name: "health_kit_reporter",
            dependencies: [
                .product(name: "FlutterFramework", package: "FlutterFramework"),
                .product(name: "HealthKitReporter", package: "HealthKitReporter")
            ]
        )
    ]
)
