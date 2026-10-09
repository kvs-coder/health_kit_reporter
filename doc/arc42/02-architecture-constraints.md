# 2. Architecture Constraints

## 2.1 Technical Constraints

| Constraint | Background |
| :--- | :--- |
| iOS only, iOS 15+ | Apple Health exists only on Apple platforms; `Package.swift` `platforms: [.iOS(.v15)]`. Newer library APIs run behind `#available` and reply `HealthKitError.notAvailable`. |
| Flutter 3.44+ / Dart 3.5+ | The Swift target depends on the `FlutterFramework` package that Flutter generates since 3.44 (ADR 0002). |
| Swift Package Manager only, Swift only | No podspec, Podfile or Objective-C; a SwiftPM target can't mix languages (ADR 0002). |
| HealthKitReporter owns HealthKit | Plugin Swift imports `HealthKitReporter`, `Flutter` and `Foundation`, never `HealthKit`; a missing mapping is a library feature, not plugin code. |
| Platform channels | One `MethodChannel` for calls, one `EventChannel` per live subscription (ADR 0003); values cross as JSON strings, maps, lists, bools, numbers and typed data. |
| HealthKit needs an entitlement and user authorization | Unit tests run without data; the integration catalog needs the authorization sheet answered by hand, so CI runs only the rows that need no authorization. |

## 2.2 Organizational Constraints

| Constraint | Background |
| :--- | :--- |
| Releases via release-please | Conventional Commits on `master` determine the semver bump and `CHANGELOG.md`; tags are `vX.Y.Z`; publishing to pub.dev runs from the tag (ADR 0006). No hand-made version bumps. |
| CI gates on every PR | Version / changelog guard; analyze, tests and a Dart coverage floor; example tests; SwiftPM build, Swift unit tests and the authorization-free integration rows; SwiftLint. |
| Test-first | A failing test precedes every change (AGENTS.md §1, §6). |
| Publishing on request only | Tagging, merging the release PR and publishing happen when the maintainer asks. |

## 2.3 Conventions

| Convention | Background |
| :--- | :--- |
| JSON contract | Model `map` and `fromJson` keys mirror the library's `Codable` names; renaming one is a breaking change. |
| Seconds in payloads, milliseconds in arguments | Payload timestamps are seconds since 1970 in both directions; `Predicate` and `DateTime` arguments are milliseconds (ADR 0001). |
| Errors | `PlatformException(code: <Dart method>, message: localizedDescription, details: String)`. |
| Immutable models | `final` fields, `const` constructors, value equality through the `Payload` mixin. |
| No singletons | Static methods over `const` channels on the Dart side; state on the plugin instance and its stream handlers on the Swift side. |
| Style | `dart format` + `flutter_lints`; SwiftLint (`.swiftlint.yml`); Xcode header blocks; one extended type per `Extensions+<Type>.swift`. |
