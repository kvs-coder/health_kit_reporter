# 7. Example app: BLoC on plain streams

Date: 09.10.2026

## Status

Accepted.

## Context

The example app's single stateful page ran rows, kept live subscriptions and rendered results at once, which made it
hard to test and to extend with search, filters and setup handling. The example is also read as documentation of how
to use the plugin, so extra packages (`flutter_bloc`, `provider`, ...) would add dependencies and concepts that have
nothing to do with Apple Health.

## Decision

The example follows the BLoC pattern on plain Dart streams: `example/lib/bloc/bloc.dart` takes events through a
`StreamController` and publishes states on a broadcast stream; `BlocBuilder` wraps `StreamBuilder`. `SetupBloc`
checks Apple Health and, in the simulator, authorizes (with a timeout) and seeds; `CatalogBloc` runs rows, keeps
results and live subscriptions, search and section filter. Events are `sealed` classes, states immutable; widgets
render states and send events, and never call the plugin.

## Consequences

- The logic is unit-tested without widgets (`example/test/bloc_test.dart`).
- No state-management dependency; the pattern is a few dozen lines a reader can follow.
- Each event is handled as it arrives, so a slow HealthKit row doesn't hold back others.
