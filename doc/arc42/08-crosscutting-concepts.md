# 8. Crosscutting Concepts

## 8.1 JSON contract

Payloads cross the channel as HealthKitReporter's `encoded()` JSON and come back as model `map`s, which the library
reads with `make(from:)`. Keys mirror the library's `Codable` names; metadata is a flat object of strings, numbers,
booleans, `{"timestamp"}` dates and `{"value", "unit"}` quantities; non-finite numbers are the strings `"Infinity"`,
`"-Infinity"`, `"NaN"` and are read with `parseNum`. Fields the library added later are nullable in Dart, so older JSON
keeps parsing. Renaming a key or changing a value's meaning is a breaking change (library ADR 0004).

## 8.2 Timestamps

Every payload timestamp is seconds since 1970, also in samples built in Dart (`DateTime.secondsSinceEpoch`), so
samples round-trip unchanged. Only non-payload arguments — `Predicate` and `DateTime` parameters — are milliseconds,
converted by the dispatcher with `Date.make(from:)` (ADR 0001).

## 8.3 Errors

Every failure reaches Dart as a `PlatformException` whose `code` is the Dart method name, whose `message` is the native
error's `localizedDescription` and whose `details` is a `String` (`FlutterError(code:error:)`). No `try?` on reply paths:
an encoding failure fails the reply. Live queries route every failure — planning, HealthKit, encoding, Dart parsing —
to `onError`. A sample of a kind the plugin doesn't know throws `InvalidValueException` (ADR 0005).

## 8.4 Threads

HealthKit calls back on its own queues; the dispatcher and the stream handlers hop to `DispatchQueue.main` before
replying or sending events, as Flutter requires. Stream handlers are created, listened to, cancelled and closed on the
main queue, so the plugin's `eventChannels` needs no lock.

## 8.5 Identity

A payload's `uuid` names the stored HealthKit sample. `delete`, `addQuantity` / `addCategory`, `unrelateWorkoutEffort`
and the attachment methods look the stored sample up by it, so models always keep and send `uuid`; `save` returns the
uuid HealthKit gave the new sample.

## 8.6 Availability

Library APIs newer than iOS 15 run behind `#available` and reply `HealthKitError.notAvailable`. Without Health data the
plugin has no `HealthKitReporter`, and every method but `isAvailable` replies `notAvailable`.

## 8.7 Value equality

Models compare, hash and print by their `map` (`Payload` mixin). Samples therefore compare their `uuid` and every field;
NaN equals NaN, so a payload holding one equals itself.

## 8.8 Testing

| Level | Tooling | Covers |
| :--- | :--- | :--- |
| Dart unit | `flutter_test`, `test/fixtures.dart` | Parsing and round trips of every payload; every API method against mocked channels (arguments sent, replies and errors parsed). |
| Swift unit | XCTest, `example/ios/RunnerTests` | Argument helpers, error mapping, dispatcher replies and codes, stream handler planning, listening and cancelling. |
| Example | `example/test` | Blocs. |
| Integration | `integration_test`, `example/integration_test/catalog_test.dart` | Every demo row against HealthKit in a simulator. |
