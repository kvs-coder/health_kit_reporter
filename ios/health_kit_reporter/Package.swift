// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "health_kit_reporter",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(name: "health-kit-reporter", targets: ["health_kit_reporter"])
    ],
    dependencies: [
        .package(url: "https://github.com/kvs-coder/HealthKitReporter.git", from: "4.0.0")
    ],
    targets: [
        .target(
            name: "health_kit_reporter",
            dependencies: [
                .product(name: "HealthKitReporter", package: "HealthKitReporter")
            ],
            // Health data stays on the device: the plugin neither tracks nor collects it
            resources: [
                .process("PrivacyInfo.xcprivacy")
            ]
        )
    ]
)
