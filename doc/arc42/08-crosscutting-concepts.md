# 8. Crosscutting concepts

## JSON contract

Payloads cross the channel as HealthKitReporter's `encoded()` JSON and come back as model `map`s, which the library reads with `make(from:)`. Keys mirror the library's `Codable` names; metadata is a flat object; non-finite numbers are the strings `"Infinity"`, `"-Infinity"`, `"NaN"` (`parseNum`). Renaming a key is a breaking change.

## Timestamps

Every payload timestamp is seconds since 1970, also in samples built in Dart (`DateTime.secondsSinceEpoch`), so samples round-trip unchanged. Only non-payload arguments, `Predicate` and `DateTime` parameters, are milliseconds. See [ADR 0001](../adr/0001-sample-timestamps-are-seconds.md).

## Errors

Every failure reaches Dart as a `PlatformException` whose `code` is the Dart method name, whose `message` is the native error's `localizedDescription` and whose `details` is a `String` (`FlutterError(code:error:)`). Encoding failures fail the reply instead of dropping elements; a sample of an unknown kind throws `InvalidValueException` in `Sample.factory`. Live queries route all of these to `onError`.

## Threads

HealthKit calls back on its own queues; the dispatcher and the stream handlers hop to `DispatchQueue.main` before replying or sending events, as Flutter requires.

## Identity

A payload's `uuid` names the stored HealthKit sample; delete, add-to-workout, unrelate and attachments look the stored sample up by it. Model equality compares the `uuid` and every field.

## Availability

Library APIs newer than iOS 15 run behind `#available` and otherwise reply `HealthKitError.notAvailable`. Without Health data every method but `isAvailable` replies `notAvailable`.
