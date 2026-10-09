# 6. Runtime View

## 6.1 A method call: `quantityQuery`

```mermaid
sequenceDiagram
    participant Dart as HealthKitReporter (Dart)
    participant Disp as Dispatcher (Swift)
    participant Lib as HealthKitReporter (Swift)
    Dart->>Disp: invokeMethod('quantityQuery', {identifier, unit, startTimestamp, endTimestamp, limit?, predicateOptions?})
    Disp->>Lib: reader.quantityQuery(type, unit, predicate, limit) → QueryHandle
    Disp->>Lib: manager.executeQuery(handle)
    Lib-->>Disp: [Quantity] or Error (HealthKit queue)
    Disp-->>Dart: JSON string, or FlutterError(code: 'quantityQuery') — main queue
    Dart->>Dart: Quantity.fromJson for every element
```

Arguments the dispatcher can't read (a missing identifier, an unknown predicate option, a non-positive `limit`) fail the
call before HealthKit is touched.

## 6.2 A live query: `anchoredObjectQuery`

```mermaid
sequenceDiagram
    participant Dart as _subscribe (Dart)
    participant Disp as Dispatcher
    participant Handler as AnchoredObjectQueryStreamHandler
    participant Lib as HealthKitReporter (Swift)
    Dart->>Disp: invokeMethod('anchoredObjectQuery', {identifiers, anchor?, predicate?})
    Disp->>Handler: StreamHandlerFactory.make, plan(arguments) → planned QueryHandle
    Disp-->>Dart: 'health_kit_reporter_event_channel_anchoredObjectQuery_{uuid}'
    Dart->>Handler: listen on that channel
    Handler->>Lib: executeQuery(handle)
    loop every change
        Lib-->>Handler: samples, deleted objects, anchor
        Handler-->>Dart: {samples: [JSON], deletedObjects: [JSON], anchor} — main queue
        Dart->>Dart: Sample.collect → onUpdate, or onError
    end
    Dart->>Handler: cancel
    Handler->>Lib: stopQuery(handle)
    Handler->>Disp: onClose → channel removed (main queue)
```

Planning failures (invalid arguments, no Health data) fail the method call and reach `onError` before a channel exists.
A subscription cancelled while it is planned still listens once and cancels, so the native queries are released.

## 6.3 Read, change, save back

```mermaid
sequenceDiagram
    participant App
    participant Dart as HealthKitReporter (Dart)
    participant Disp as Dispatcher
    participant Lib as HealthKitReporter (Swift)
    App->>Dart: workoutQuery(predicate)
    Dart-->>App: [Workout] (uuid, timestamps in seconds)
    App->>Dart: delete(workout) / addQuantity([...], workout) / save(copy)
    Dart->>Disp: {workout: workout.map}
    Disp->>Lib: Workout.make(from:) — same seconds, same uuid
    Lib->>Lib: stored sample looked up by uuid / saved
    Lib-->>Disp: status (and the new uuid for save)
    Disp-->>Dart: true / {status, uuid}
```

Because payload timestamps are seconds in both directions (ADR 0001), a sample read from HealthKit saves with its own dates.

## 6.4 Failure paths

| Situation | What Dart sees |
| :--- | :--- |
| Health data unavailable (some iPads) | `isAvailable()` is false; every other call, live queries included, fails with `PlatformException(code: <method>, message: 'HealthKit data is not available')`. |
| API newer than the device's iOS | `PlatformException` with `HealthKitError.notAvailable`'s message, e.g. "State of mind is available from iOS 18". |
| A payload fails to encode | The whole reply or event fails with the method's code; no element is dropped. |
| A sample of an unknown kind | `InvalidValueException` from `Sample.factory`; the anchored query's update fails and its anchor isn't advanced (ADR 0005). |
| `saveWorkout` stores the workout but not its route | `PlatformException` whose `details` hold the stored workout's JSON. |
