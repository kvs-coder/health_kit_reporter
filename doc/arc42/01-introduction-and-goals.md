# 1. Introduction and Goals

## 1.1 Requirements Overview

`health_kit_reporter` is a Flutter plugin (iOS only) that gives Dart apps the Swift library
[HealthKitReporter](https://github.com/kvs-coder/HealthKitReporter), and through it Apple Health. Dart code calls static
methods of `HealthKitReporter`, gets plain Dart models back and never touches HealthKit or Swift.

Core capabilities, mirroring the library's services:

| Capability | Dart entry points (examples) | Library service |
| :--- | :--- | :--- |
| Authorize | `requestAuthorization`, `requestPerObjectReadAuthorization`, `authorizationRequestStatus`, `isWritable` | `manager` |
| Read | `quantityQuery`, `categoryQuery`, `workoutQuery`, `sampleQuery`, `sampleQueryWithDescriptors`, `statisticsQuery`, series, records, wellbeing and medication queries | `reader` |
| Write | `save`, `saveSamples`, `saveWorkout`, `saveQuantitySeries`, `saveHeartbeatSeries`, `delete*`, `addQuantity` / `addCategory`, workout effort, attachments | `writer`, `manager` |
| Observe live | `observerQuery`, `anchoredObjectQuery`, `statisticsCollectionQuery`, `queryActivitySummaryUpdates`, background delivery | `observer`, `reader` |

The plugin exposes 59 public methods; every public library feature has one (AGENTS.md §1, "Mirror the Library").
The example app lists every method, grouped by area, and seeds simulator data.

## 1.2 Quality Goals

| Priority | Quality goal | Motivation |
| :--- | :--- | :--- |
| 1 | **Data fidelity** | What HealthKit stores reaches Dart unchanged, and what Dart sends is stored unchanged: no sample kind is dropped (ADR 0005), timestamps round-trip (ADR 0001), non-finite numbers and mixed metadata survive. |
| 2 | **Contract fidelity** | The plugin follows HealthKitReporter's JSON contract exactly; a Dart model key that drifts from the library's `Codable` name breaks users at runtime, not at compile time. |
| 3 | **Predictable failure** | Every native failure reaches Dart as a `PlatformException` coded with the method name; nothing is swallowed, nothing crashes. |
| 4 | **Parity with the library** | A library feature without a Dart method is a gap, closed in the next plugin release. |
| 5 | **Testability** | Dart, Swift and the integration catalog are tested in CI without a HealthKit entitlement; coverage only rises. |

## 1.3 Stakeholders

| Role | Expectation |
| :--- | :--- |
| Flutter app developers | A typed Dart API over Apple Health with documented arguments, iOS versions and failures; channels mockable in their own tests (ADR 0004). |
| HealthKitReporter maintainers | The plugin consumes the JSON contract as designed (library ADR 0004) and reports missing library features instead of working around them in Swift. |
| Plugin maintainers / contributors | Clear layering and a mechanical recipe for adding a method (AGENTS.md §5C); CI that catches drift. |
| End users of consuming apps | Their health data is read and written correctly, only with their authorization, and stays on the device (privacy manifest). |
