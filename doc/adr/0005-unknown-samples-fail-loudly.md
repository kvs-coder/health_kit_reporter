# 5. Unknown sample kinds fail loudly

Date: 09.10.2026

## Status

Accepted. Ships with 3.0.0.

## Context

`Sample.factory` returned `null` for heartbeat series, workout routes, audiograms, CDA documents, states of mind,
scored assessments and medication doses, although HealthKitReporter encodes all of them. `sampleQuery` and
`anchoredObjectQuery` skipped the `null`s silently. In the anchored query the anchor still advanced, so a persisted
anchor never returned those samples again: permanent data loss for apps that sync. HealthKit keeps adding sample
kinds, so a kind the plugin doesn't know yet will reach `Sample.factory` again.

The alternatives were a raw fallback sample (keeps the data, but every consumer must handle an untyped kind) or an error.

## Decision

`Sample.factory` returns a non-null `Sample` for every kind the library encodes and throws `InvalidValueException`
naming the identifier for anything else. `sampleQuery` and `sampleQueryWithDescriptors` fail with it; an
`anchoredObjectQuery` update fails through `onError`, so the app never receives, and never persists, the anchor that
would skip the sample. Swift-side encoding failures likewise fail the whole reply instead of dropping elements.

## Consequences

- No sample is lost behind an anchor; once the plugin knows the new kind, the same anchor returns it.
- Until then, a sync that meets an unknown kind stops at that update and keeps reporting the error; apps can narrow
  their identifiers to continue.
- A new library sample kind needs a Dart model and a `Sample.factory` case in the next plugin release (AGENTS.md §1).
