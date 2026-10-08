# health_kit_reporter

## Features

A Flutter wrapper for [HealthKitReporter](https://github.com/kvs-coder/HealthKitReporter).

- **iOS only**, since Apple Health is not available on Android devices.
- Reads, writes and observes values in the HealthKit repository.
- The methods of **HealthKitReporter** are wrapped in the Method and Event channels of a **FlutterPlugin**; every payload arrives as the library's JSON and is parsed into Dart models.

## Requirements

- iOS 15 or newer (vision prescriptions need iOS 16, workout effort iOS 18).
- Flutter 3.24 / Dart 3.5 or newer.
- **Swift Package Manager.** The plugin resolves HealthKitReporter `from: "4.0.0"` through SwiftPM; it is not available through CocoaPods (CocoaPods trunk becomes read-only on 2 December 2026, and HealthKitReporter stays on CocoaPods at 3.1.0).

## Getting Started

1. Enable Swift Package Manager for Flutter, once per machine:

```shell
flutter config --enable-swift-package-manager
```

2. Add the plugin to your `pubspec.yaml`:

```yaml
dependencies:
  health_kit_reporter: ^4.0.0
```

3. Get the dependencies and run the app. `flutter run` migrates the `Runner` project to Swift Package Manager the first time:

```shell
flutter pub get
flutter run
```

4. Set the iOS deployment target of `Runner` to 15.0. If no other plugin of your app needs CocoaPods, remove `ios/Podfile`, `ios/Podfile.lock` and `ios/Pods`.

## How to use

### Preparation

In Xcode, go to Runner > Signing and Capabilities and add the entitlement for Health Kit.
If you want to read Clinical Records then also check "Clinical Health Records" under Health Kit.

***NOTE:*** *You can only tick the "Clinical Health Records" checkmark if your development team has a paid Apple developer subscription. To test on a real device, or to publish your application, you will need a paid Apple subscription, but you can still test on the iOS simulator without a subscription by setting the Development Team to None.*


Then in your app's info.plist file add permissions:

```xml
<key>NSHealthShareUsageDescription</key>
<string>WHY_YOU_NEED_TO_SHARE_DATA</string>
<key>NSHealthUpdateUsageDescription</key>
<string>WHY_YOU_NEED_TO_USE_DATA</string>
```

If you plan to use **WorkoutRoute** **Series** please provide additionally CoreLocation permissions:

```xml
<key>NSLocationAlwaysAndWhenInUseUsageDescription</key>
<string>WHY_YOU_NEED_TO_ALWAYS_SHARE_LOCATION</string>
<key>NSLocationWhenInUseUsageDescription</key>
<string>WHY_YOU_NEED_TO_SHARE_LOCATION</string>
```

If you plan to read **Clinical Records** please provide additionally:

```xml
<key>NSHealthClinicalHealthRecordsShareUsageDescription</key>
<string>WHY_YOU_NEED_TO_SHARE_DATA</string>
```

### Common usage

Call the static methods of <i>HealthKitReporter</i> inside try / catch blocks. Native errors arrive as a `PlatformException` whose `message` is the localized description of the HealthKitReporter error, e.g. `HealthKit doesn't let apps write HKQuantityTypeIdentifierAppleExerciseTime`.

Check `HealthKitReporter.isAvailable()` first: it is false on devices without Apple Health, e.g. some iPads.

The reporter supports following operations with **HealthKit**:
* accessing to permissions
* reading data
* writing data
* observing data changes

Apple Health shows the authorization window only once per type while the app is installed. If the user declined some types, they have to allow them in the Health app.

### Requesting permissions

Call **requestAuthorization** with the identifiers of the types to read and to write.

Only types whose **isWritable** is true can be requested for writing; HealthKit computes the others itself (e.g. `QuantityType.appleExerciseTime`, ECGs). Correlations and per-object types (vision prescriptions) can't be requested here at all. For all of these the call fails with a `PlatformException` instead of HealthKit crashing the app.

```dart
Future<bool> requestAuthorization() async {
  final readTypes = QuantityType.values.map((e) => e.identifier).toList();
  final writeTypes = <String>[];
  for (final identifier in readTypes) {
    if (await HealthKitReporter.isWritable(identifier)) {
      writeTypes.add(identifier);
    }
  }
  return HealthKitReporter.requestAuthorization(readTypes, writeTypes);
}
```

**Warning: Apple Health does not tell apps whether reading permissions were granted.** The user can decline some of them and the result is still **true**. See [Authorization status](https://developer.apple.com/documentation/healthkit/hkhealthstore/1614154-authorizationstatus).

**Clinical records** are requested in a separate call, since they start Health's records flow, which needs an Apple Account and the Clinical Health Records entitlement:

```dart
if (await HealthKitReporter.supportsHealthRecords()) {
  await HealthKitReporter.requestClinicalRecordsAuthorization(
      ClinicalType.values.map((e) => e.identifier).toList());
  final immunizations =
      await HealthKitReporter.clinicalRecordQuery(ClinicalType.immunizationRecord);
}
```

**Vision prescriptions** (iOS 16) use per-object authorization: the user picks which prescriptions the app may read. Their `dateIssuedTimestamp` and `expirationDateTimestamp` are seconds since 1970.

```dart
await HealthKitReporter.requestPerObjectReadAuthorization(
    VisionPrescriptionType.visionPrescription.identifier);
final prescriptions = await HealthKitReporter.visionPrescriptionQuery();
print(prescriptions.first.harmonized.dateIssued);
```

### Reading Data

After authorization, you can read data. Timestamps in the payloads are seconds since 1970.

```dart
final predicate = Predicate(
  DateTime.now().subtract(const Duration(days: 7)),
  DateTime.now(),
);
final preferredUnits =
    await HealthKitReporter.preferredUnits([QuantityType.stepCount]);
for (final preferredUnit in preferredUnits) {
  final type = QuantityTypeFactory.from(preferredUnit.identifier);
  final quantities =
      await HealthKitReporter.quantityQuery(type, preferredUnit.unit, predicate);
  final statistics = await HealthKitReporter.statisticsQuery(
      type, preferredUnit.unit, predicate,
      separateBySource: true);
  print('${quantities.length} samples, sum ${statistics.harmonized.summary}');
}
final sleep =
    await HealthKitReporter.categoryQuery(CategoryType.sleepAnalysis, predicate);
final workouts = await HealthKitReporter.workoutQuery(predicate);
final bloodPressure = await HealthKitReporter.correlationQuery(
    CorrelationType.bloodPressure.identifier, predicate);
```

**preferredUnits** returns the units of the current locale for quantity types. A unit that doesn't fit the type fails the query. **sampleQuery** returns quantities in SI units.

**Metadata** is a flat JSON object, modelled as `Metadata`, a map of `MetadataValue`s: `MetadataString`, `MetadataNumber`, `MetadataBool`, `MetadataDate` (`{"timestamp": <seconds since 1970>}`) and `MetadataQuantity` (`{"value": <number>, "unit": <unit>}`). Saving sends it back in the same shape.

```dart
final metadata = quantity.harmonized.metadata;
if (metadata?['HKWasUserEntered'] case MetadataBool(value: true)) {
  print('entered by hand');
}
```

Numbers that JSON can't represent arrive as `"Infinity"`, `"-Infinity"` and `"NaN"`; the models parse them into `double`s.

### Writing Data

Activity summaries, ECGs, characteristics and clinical records are read-only. Check **isAuthorizedToWrite** before writing.

Build a **Sample** and call **save**. It returns the uuid HealthKit gave the stored sample; keep it to delete the sample later. The timestamps of samples you build are milliseconds since 1970 (`DateTime.millisecondsSinceEpoch`); a new sample has no uuid yet, so pass an empty string.

```dart
final now = DateTime.now();
final steps = Quantity(
  '',
  QuantityType.stepCount.identifier,
  now.subtract(const Duration(minutes: 1)).millisecondsSinceEpoch,
  now.millisecondsSinceEpoch,
  null,
  const SourceRevision(Source('myApp', 'com.example.app'), null, null, '18.0',
      OperatingSystem(18, 0, 0)),
  QuantityHarmonized(100, 'count', Metadata({'HKWasUserEntered': const MetadataBool(true)})),
);
final uuid = await HealthKitReporter.save(steps);
```

**Delete**, **addQuantity** / **addCategory** and **unrelateWorkoutEffort** act on the **stored** sample with the payload's uuid. Samples you read carry it, so send them back as they are:

```dart
final stored = (await HealthKitReporter.quantityQuery(
        QuantityType.stepCount, 'count', predicate))
    .firstWhere((e) => e.uuid == uuid);
await HealthKitReporter.delete(stored);
```

**saveSamples** and **deleteSamples** do the same for several samples at once; either all of them are stored or deleted, or none. **saveSamples** returns the uuids in the order of the samples.

```dart
final uuids = await HealthKitReporter.saveSamples([morningSteps, eveningSteps]);
```

Workout effort (iOS 18): relate an effort score sample to a stored workout with **relateWorkoutEffort**, read the relationships with **workoutEffortRelationshipQuery** and remove one with **unrelateWorkoutEffort**.

**Recommendation:** call **preferredUnits** first to know which unit is valid for a type, see [HKUnit.init](https://developer.apple.com/documentation/healthkit/hkunit/1615733-init/). HealthKit rejects invalid values, e.g. 0 steps.

### Anchors

**anchoredObjectQuery** delivers the samples and deleted objects since an anchor, and the new anchor with every update. The anchor is a base64 string, so persist it as is and pass it to the next query to receive only the changes. Without an anchor the query starts from the beginning; a corrupt anchor fails with a `PlatformException`. Deleted objects carry only their uuid, so match it against the samples you keep.

```dart
final subscription = HealthKitReporter.anchoredObjectQuery(
  [QuantityType.stepCount.identifier],
  null,
  anchor: prefs.getString('stepsAnchor'),
  onUpdate: (samples, deletedObjects, anchor) {
    prefs.setString('stepsAnchor', anchor!);
  },
);
```

## Observing Data

If you want to know, that something was changed in HealthKit, you can observe the repository.

Try simple **observerQuery** to get notifications if something is changed.

This call is a subscription for EventChannel of the plugin, so don't forget to cancel it as soon as you don't need it anymore.

```dart
 Future<void> observerQuery() async {
  final identifier = QuantityType.stepCount.identifier;
  final sub = HealthKitReporter.observerQuery(
    [identifier],
    _predicate,
    onUpdate: (identifier) async {
      print('Updates for observerQuerySub');
      print(identifier);
    },
  );
  print('observerQuerySub: $sub');
  final isSet = await HealthKitReporter.enableBackgroundDelivery(
    identifier,
    UpdateFrequency.immediate,
  );
  print('enableBackgroundDelivery: $isSet');
}
```

According to [Observing Query](https://developer.apple.com/documentation/healthkit/hkobserverquery) and [Background Delivery](https://developer.apple.com/documentation/healthkit/hkhealthstore/1614175-enablebackgrounddelivery)
you might create an App which will be called every time by HealthKit, even if the app is in background, to notify, that some data was changed in HealthKit depending on frequency. But keep in mind that sometimes the desired frequency you set cannot be fulfilled by HealthKit. 

To receive notifications when the app is killed by the system or in background:
- provide an additional capability **Background Mode** and select **Background fetch**
- with calling **observerQuery**, you need to call **enableBackgroundDelivery** function as well

As a recommendation set up the subscription inside **initState** or **build** methods of your widget or as more preferred in **main** function of your app.

If you want to stop observation, you need to:
- remove the subscription for **observerQuery**
- call **disableBackgroundDelivery** or **disableAllBackgroundDelivery**

## Migrating to 4.0.0

4.0.0 depends on HealthKitReporter 4.0.0, which changed its API and its JSON contract ([ADR 0004](https://github.com/kvs-coder/HealthKitReporter/blob/master/docs/adr/0004-contract-changes-for-the-next-major-release.md)):

- **Swift Package Manager only, iOS 15.** Enable SPM (`flutter config --enable-swift-package-manager`), raise the deployment target, and drop the `HealthKitReporter` pod from your `Podfile`.
- **Anchors are strings.** `anchoredObjectQuery`'s `onUpdate` receives a third argument, the anchor as a base64 string; pass it back as `anchor:` to continue from it.
- **`save` returns the uuid** of the stored sample (`Future<String?>` instead of `Future<bool>`).
- **`delete` needs the uuid.** It deletes the stored sample with the payload's uuid; samples you built yourself must carry the uuid `save` returned. The same holds for `addQuantity` / `addCategory` (the workout's uuid) and `unrelateWorkoutEffort`.
- **Flat metadata.** Metadata fields are `Metadata` instead of `Map<String, dynamic>`; the old `{"string": {"dictionary": ...}}` shape is gone.
- **Vision prescription dates are seconds**, not milliseconds.
- **Corrected strings**: "Pickleball", "Hand Cycling", "Preparation and Recovery", "Pause or resume request", "Sinus rhythm"; audio exposure events are described as `HKCategoryValueEnvironmentalAudioExposureEvent` / "Momentary Limit". Update comparisons against the old strings.
- `requestAuthorization` fails for types HealthKit can't authorize (read-only types to write, correlations, per-object types) and for unknown identifiers, instead of ignoring them or crashing; use `isWritable`.
- `preferredUnits` and the other methods report errors with the native error's localized description.
- `model/SampleQueryOptions.dart` moved to `model/sample_query_option.dart`; `deleteObjects` returns `Map<String, dynamic>`; `ActivitySummary.date` and `ElectrocardiogramHarmonized.averageHeartRate` are nullable.

## Example

`example/` lists every method of the plugin, grouped by area. Tap a row to run it; its result, live updates or error appear in the row. Live queries keep updating until **Stop live queries**.

In the simulator the app authorizes and seeds 7 days of plausible samples for every writable type on launch (once per day and type, marked with an `HKExternalUUID` starting with `hkr-seed-`); **Delete seeded data** removes only that data. Read-only data (ECGs, characteristics, activity summaries, clinical records) comes from Apple Watch or the Health app.

```shell
flutter config --enable-swift-package-manager
cd example && flutter run
```

## License
Under <a href=https://github.com/kvs-coder/health_kit_reporter/blob/master/LICENSE>MIT License</a>

## Sponsorship
If you think that my repo helped you to solve the issues you struggle with, please don't be shy and sponsor :-)
