# 6. Runtime view

## A method call: `quantityQuery`

```mermaid
sequenceDiagram
    participant Dart as HealthKitReporter (Dart)
    participant Disp as Dispatcher (Swift)
    participant Lib as HealthKitReporter (Swift)
    Dart->>Disp: invokeMethod('quantityQuery', {identifier, unit, startTimestamp, endTimestamp})
    Disp->>Lib: reader.quantityQuery(type, unit, predicate) → QueryHandle
    Disp->>Lib: manager.executeQuery(handle)
    Lib-->>Disp: [Quantity] or Error (HealthKit queue)
    Disp-->>Dart: JSON string, or FlutterError(code: 'quantityQuery') — on the main thread
    Dart->>Dart: Quantity.fromJson for every element
```

## A live query: `anchoredObjectQuery`

```mermaid
sequenceDiagram
    participant Dart as _subscribe (Dart)
    participant Disp as Dispatcher (Swift)
    participant Handler as AnchoredObjectQueryStreamHandler
    participant Lib as HealthKitReporter (Swift)
    Dart->>Disp: invokeMethod('anchoredObjectQuery', {identifiers, anchor})
    Disp->>Handler: plan(arguments) → planned QueryHandle
    Disp-->>Dart: 'health_kit_reporter_event_channel_anchoredObjectQuery_<uuid>'
    Dart->>Handler: listen on that channel
    Handler->>Lib: executeQuery(handle)
    loop every change
        Lib-->>Handler: samples, deleted objects, anchor
        Handler-->>Dart: {samples: [JSON], deletedObjects: [JSON], anchor} — main thread
        Dart->>Dart: Sample.collect → onUpdate, or onError
    end
    Dart->>Handler: cancel
    Handler->>Lib: stopQuery(handle)
    Handler->>Disp: onClose → channel removed
```

Planning failures (invalid arguments, no Health data) fail the method call and reach `onError` before any channel exists.
