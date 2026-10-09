# 9. Architecture Decisions

The decisions are recorded as ADRs in Nygard format (status, context, decision, consequences) in [`doc/adr/`](../adr).

| ADR | Decision | Status |
| :--- | :--- | :--- |
| [0001](../adr/0001-sample-timestamps-are-seconds.md) | Sample timestamps are seconds in both directions | Accepted |
| [0002](../adr/0002-swift-package-manager-only.md) | Swift Package Manager only (with `FlutterFramework`, Flutter 3.44+) | Accepted |
| [0003](../adr/0003-one-event-channel-per-subscription.md) | One event channel per live subscription | Accepted |
| [0004](../adr/0004-static-api-mocked-through-channels.md) | Static API, mocked through its channels | Accepted |
| [0005](../adr/0005-unknown-samples-fail-loudly.md) | Unknown sample kinds fail loudly | Accepted |
| [0006](../adr/0006-own-semver-with-release-please.md) | Own semantic versioning, released by release-please | Accepted |
| [0007](../adr/0007-example-bloc-on-plain-streams.md) | Example app: BLoC on plain streams | Accepted |

The JSON contract itself is decided by HealthKitReporter's
[ADR 0004](https://github.com/kvs-coder/HealthKitReporter/blob/master/docs/adr/0004-contract-changes-for-the-next-major-release.md),
and its library-typed API (`QueryHandle`, `Anchor`) by its ADR 0005.
