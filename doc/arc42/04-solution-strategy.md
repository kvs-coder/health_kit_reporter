# 4. Solution Strategy

| Goal | Approach | Details |
| :--- | :--- | :--- |
| Parity with the library at low cost | **Thin bridge.** The plugin adds no HealthKit logic: the dispatcher parses arguments, calls the library and replies with its `encoded()` JSON; Dart parses it into models. | §5, AGENTS.md §1 |
| Contract fidelity | **The library's JSON is the contract.** Dart models mirror the `Codable` names; samples go back as model `map`s read by `make(from:)`. | §8.1, library ADR 0004 |
| Data fidelity | **One unit per field and loud failures.** Seconds in every payload; an unknown sample kind or an encoding failure fails the call instead of shrinking the result. | ADR 0001, ADR 0005 |
| Predictable failure | **Errors carry the Dart method's name**, the native localized description and a `String` detail; live queries report on `onError`. | §8.3 |
| Independent live subscriptions | **A channel per subscription**, opened by a method call that also validates the arguments. | ADR 0003, §6.2 |
| Safe evolution | **Release-please, own semver.** Conventional Commits drive versions; `!` marks a major. | ADR 0006 |
| Testability | **Mock the channels** in Dart tests, test the Swift dispatcher in `RunnerTests`, run every demo row as an integration test. | ADR 0004, §10 |
