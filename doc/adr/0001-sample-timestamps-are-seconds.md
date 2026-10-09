# 1. Sample timestamps are seconds in both directions

Date: 09.10.2026

## Status

Accepted. Ships with 3.0.0, a major release, since it changes what consumers send.

## Context

HealthKitReporter encodes every payload timestamp as seconds since 1970 (ADR 0004 of the library). Until now the plugin expected samples built in Dart for saving to hold milliseconds (`DateTime.millisecondsSinceEpoch`) and divided the start and end of every sample by 1000 before `save`, `saveSamples`, `addQuantity`, `addCategory` and `relateWorkoutEffort`.

A sample read from HealthKit holds seconds, so sending it back (e.g. re-saving a read sample, or relating an effort sample that isn't stored yet) divided its dates again and stored them in January 1970. Vision prescriptions mixed both units in one payload: `dateIssuedTimestamp` and `expirationDateTimestamp` in seconds, start and end in milliseconds.

## Decision

Dart models hold seconds since 1970 in every timestamp field, whether they were read or built in Dart. The native side reads them with the library's `make(from:)` as they are; `fromDart()` is gone.

`DateTime.secondsSinceEpoch` (`lib/model/decorator/extensions.dart`) builds them, `dateFromSeconds` reads them.

Arguments that aren't payloads keep milliseconds: `Predicate`, the `DateTime` arguments of the live queries and `recalibrateEstimates`. They are converted by `Date.make(from:)` in the dispatcher.

## Consequences

- A sample read from HealthKit round-trips through `save` with its own dates.
- Code that built samples with `millisecondsSinceEpoch` must switch to `secondsSinceEpoch`; otherwise its dates land about 50,000 years in the future and HealthKit rejects them. This is listed under the breaking changes of 3.0.0.
- One unit per payload, the library's, so the plugin no longer converts payloads at all.
