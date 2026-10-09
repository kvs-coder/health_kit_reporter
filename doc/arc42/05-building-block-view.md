# 5. Building block view

| Block | Location | Responsibility |
| :--- | :--- | :--- |
| Dart API | `lib/health_kit_reporter.dart` | Static methods: build argument maps, call the method channel, parse replies; `_subscribe` for live queries |
| Dart models | `lib/model/payload/`, `lib/model/type/` | Payloads mirroring the library's `Codable` types (`Payload` mixin: value equality and `toString`), type enums mapping to HealthKit identifiers, `Sample.factory` |
| Plugin registration | `SwiftHealthKitReporterPlugin.swift` | One `HealthKitReporter` (nil without Health data), the method channel, the event channels of live subscriptions |
| Dispatcher | `Extensions+SwiftHealthKitReporterPlugin.swift` | `Method` enum, one case per Dart method; reads arguments, calls the library, replies JSON, maps, bools or `FlutterError`s |
| Argument helpers | `Extensions+Dictionary.swift` | Typed reads of the argument map, predicates, anchors, identifiers |
| Stream handlers | `<Query>StreamHandler.swift`, `Extensions+FlutterStreamHandler.swift` | Plan, execute and stop the `QueryHandle`s of one live subscription |
| Example | `example/` | A row per public method (`Catalog`), simulator seeding, the integration test and the Swift unit tests (`ios/RunnerTests`) |
