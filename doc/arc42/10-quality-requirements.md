# 10. Quality Requirements

## 10.1 Quality Tree

```text
Quality
├── Reliability
│   ├── Data fidelity ............. S1, S2, S3
│   └── Predictable failure ....... S4, S5, S6
├── Compatibility
│   ├── Contract fidelity ......... S7
│   └── Library parity ............ S8
├── Maintainability
│   ├── Testability ............... S9, S10
│   └── Extensibility ............. S11
└── Usability
    └── Learnability .............. S12
```

## 10.2 Quality Scenarios

| ID | Scenario | Expected response |
| :--- | :--- | :--- |
| S1 | An app syncing with `anchoredObjectQuery` meets heartbeat series, routes, audiograms or medication doses. | Each arrives as its Dart model; nothing is skipped behind the anchor (ADR 0005). |
| S2 | A sample read from HealthKit is saved again or related to a workout. | It keeps its dates; timestamps are seconds in both directions (ADR 0001). |
| S3 | A route location holds an infinite speed, or metadata mixes strings, numbers, dates and quantities. | The values survive the round trip (`parseNum`, flat `Metadata`). |
| S4 | A method is called with a missing argument, or on a device without Health data. | `PlatformException` with the method's name as `code` and the native message; no crash. |
| S5 | Two `observerQuery` subscriptions run and one is cancelled. | The other keeps reporting (ADR 0003); the example's "Two anchoredObjectQuery subscriptions" row proves it against HealthKit. |
| S6 | HealthKit never answers the authorization request in the example. | The setup card reports it after 60 s with a retry hint instead of spinning forever. |
| S7 | HealthKitReporter adds an optional payload field. | Older JSON still parses; the new field is a nullable Dart field. |
| S8 | HealthKitReporter adds a public method. | The plugin adds a Dart method, dispatcher case, API test, demo row and README snippet (AGENTS.md §5C). |
| S9 | A PR changes Dart code. | Analyze is clean and line coverage of `lib/` stays ≥ `COVERAGE_THRESHOLD` (90 %; measured about 95 % with 116 tests). |
| S10 | A PR changes the Swift bridge. | SwiftLint passes, `RunnerTests` pass (20 tests), and the catalog integration run passes (55 rows, 5 skipped for system sheets). |
| S11 | A new HealthKit sample kind appears. | One type enum, one payload model, one `Sample.factory` case and one `parseSample` key; until then the kind fails loudly. |
| S12 | A Flutter developer wants last week's step counts. | A README snippet and the example's catalog row show it: `requestAuthorization`, then `quantityQuery`. |
