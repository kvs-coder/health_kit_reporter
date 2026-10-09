# 3. One event channel per live subscription

Date: 09.10.2026

## Status

Accepted. Ships with 4.0.0.

## Context

The live queries (`observerQuery`, `anchoredObjectQuery`, `queryActivitySummaryUpdates`, `statisticsCollectionQuery`) used one fixed `EventChannel` per method, and each stream handler kept one list of running queries. Flutter allows one listener per channel name on each side: a second `receiveBroadcastStream` replaced the first one's message handler, the engine cancelled the first native subscription, and cancelling either Dart subscription stopped the queries of both. Errors raised while listening were reported to `FlutterError.reportError` instead of `onError`, and without Health data the channels weren't registered at all, so listeners got a `MissingPluginException`.

## Decision

A live query is a method call of its own, named like the Dart method. The dispatcher builds the stream handler and plans its queries, so invalid arguments and missing Health data fail that call with a `PlatformException` coded with the method name. It then registers a new event channel `health_kit_reporter_event_channel_<method>_<uuid>` and replies with its name. Dart listens to that channel to execute the queries and cancels it to stop them; the handler then closes the channel. `_subscribe` in `health_kit_reporter.dart` hides this behind the existing `StreamSubscription` API and routes every failure, including events the models can't parse, to `onError`.

## Consequences

- Subscriptions, also several of the same method, run and stop independently; the example's "Two anchoredObjectQuery subscriptions" row proves it against HealthKit.
- One extra platform round trip per subscription.
- Tests mock the method call to reply a channel name and mock that channel.
