# 12. Glossary

| Term | Definition |
| :--- | :--- |
| **HealthKit** | Apple's framework and on-device database for health and fitness data. |
| **HealthKitReporter** | The Swift library the plugin wraps; owns every mapping between HealthKit objects and payloads. Also the name of the plugin's Dart class of static methods. |
| **Plugin** | `health_kit_reporter`: the Dart API, the Dart models and the Swift native bridge. |
| **Method channel** | `health_kit_reporter_method_channel`, carrying every one-shot call and the opening of live queries. |
| **Event channel** | `health_kit_reporter_event_channel_<method>_<uuid>`, one per live subscription (ADR 0003). |
| **Dispatcher** | The Swift `Method` enum and `handle` switch, one case per Dart method. |
| **Stream handler** | The Swift object behind one event channel: plans, executes and stops its `QueryHandle`s. |
| **Live query** | `observerQuery`, `anchoredObjectQuery`, `statisticsCollectionQuery`, `queryActivitySummaryUpdates`: a `StreamSubscription` reporting until cancelled. |
| **Payload** | A Dart model mirroring a library `Codable` payload (`map` ⇄ `fromJson`); also the mixin giving models value equality. |
| **Sample** | A payload of a stored HealthKit sample, with `uuid`, `identifier`, start/end timestamps, device, source revision and `harmonized` values. |
| **Harmonized** | The value part of a payload (value, unit, metadata) as the library harmonizes it. |
| **Identifier** | HealthKit's string name of a type, e.g. `HKQuantityTypeIdentifierStepCount`; the key both sides use. |
| **Type** | A Dart enum case naming a HealthKit type, e.g. `QuantityType.stepCount`, with its identifier. |
| **Predicate** | Start and end `DateTime`s narrowing a query; sent as milliseconds. |
| **Query option** | `SampleQueryOption`: whether samples must start and/or end inside the predicate (`strictStartDate`, `strictEndDate`, `notStrict`). |
| **Limit** | The most samples a query returns, newest first. |
| **Query descriptor** | An identifier + predicate pair for reading several types at once. |
| **Anchor** | Base64 string marking the position after which `anchoredObjectQuery` returns new and deleted objects; apps persist it. |
| **Metadata** | A sample's flat key/value annotations as `MetadataValue`s. |
| **Superseded PR** | A contributor PR recorded with `git merge -s ours` for credit when the plugin already covers it differently. |
| **Catalog** | The example app's rows, one per public method, grouped by area; also run as the integration test. |
| **Seeding** | Writing a week of plausible simulator data, marked with an `HKExternalUUID` starting `hkr-seed-`. |
