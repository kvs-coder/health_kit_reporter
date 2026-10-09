# 4. Static API, mocked through its channels

Date: 09.10.2026

## Status

Accepted.

## Context

`HealthKitReporter` exposes static methods, so apps can't substitute it in their own tests. An instance-based facade would duplicate about 60 method signatures and their documentation, and a shared default instance would be a singleton, which AGENTS.md §4 bans.

## Decision

Keep the static API. Consumers mock the method channel (`setMockMethodCallHandler`) and, for live queries, the event channel whose name the method call replies (`setMockStreamHandler`), as the plugin's own `test/api_test.dart` does; the README's "Testing your app" shows both. Apps that prefer a Dart-level seam wrap the methods they use in an interface of their own.

## Consequences

- No second API surface to keep in sync with HealthKitReporter.
- Consumer tests depend on the channel contract (method names, argument maps, JSON replies), which is the stable contract of the plugin anyway.
