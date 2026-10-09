# 2. Swift Package Manager only

Date: 08.10.2026

## Status

Accepted. Ships with 3.0.0.

## Context

HealthKitReporter 4.0.0 is published through Swift Package Manager only; on CocoaPods it stays frozen at 3.1.0, and CocoaPods trunk becomes read-only on 2 December 2026. Flutter resolves plugin dependencies through SwiftPM since Flutter 3.24, and since Flutter 3.44 it generates a `FlutterFramework` package that plugins depend on to import Flutter. A plugin that keeps a podspec would either pin consumers to HealthKitReporter 3.1.0 or need two dependency manifests that drift apart.

## Decision

The plugin ships only `ios/health_kit_reporter/Package.swift`, depending on HealthKitReporter `from: "4.0.0"`, with a Swift-only target (a SwiftPM target can't mix Swift and Objective-C, so the Objective-C registration is gone). The target depends on `FlutterFramework` (`path: "../FlutterFramework"`), so the minimum is iOS 15, Flutter 3.44, Dart 3.5.

## Consequences

- Consumers enable SwiftPM (`flutter config --enable-swift-package-manager`) and raise their deployment target to iOS 15; apps that still need CocoaPods for other plugins keep both, Flutter supports the mix.
- No podspec, Podfile or Objective-C files in the repository (AGENTS.md §4).
- Resources such as the privacy manifest are SwiftPM resources of the target.
