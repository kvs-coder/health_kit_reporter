# health_kit_reporter

## Features

A Flutter wrapper for [HealthKitReporter](https://cocoapods.org/pods/HealthKitReporter)

- **iOS only usage**, since AppleHealth is not available on Android devices.

- The library supports reading, writing, observing values from HealthKit repository.

- All methods from **HealthKitReporter** original library are wrapped in Method and Event channels provided by **FlutterPlugin**

## Getting Started

- Go inside pubspec.yaml file
- Add this to your package's pubspec.yaml file: 
``` Dart
dependencies:
     health_kit_reporter: ^1.0.8
```
- Get dependencies

``` shell
flutter pub get
``` 

## How to use

### Preparation

At first in your app's entitlements select HealthKit and in your app's info.plist file add permissions:

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

### Common usage

You simply call a <i>HealthKitReporter</i> methods surrounding by try catch blocks. 

Warning: If Apple Health is not supported by the device (i.e. iPad) the error result will occur.

The reporter supports following operations with **HealthKit**:
* accessing to permissions
* reading data 
* writing data 
* observing data changes

If you want to read, write data or observe data changes, you always need to be sure that the data types are authorized to be read/written/observed. In that case call authorization method and await for the result telling about the presentation of the authorization window. Notice that Apple Health Kit will show this window only once during the whole time app is installed on the device, in this case if some types were denied to be read or written, user should manually allow this in Apple Health App.

### Requesting permissions

As was mentioned above, you need to provide HealthKit entitlements and extend the info.plist file of your App with HealthKit permissions. (see [Preparation](#preparation))

Call the method: **requestAuthorization**

For this method you need to specify the strings identifiers of types you want to get access.

In the example, we want to read data for all **QuantityTypes** and write data for **QuantityType.stepCount**:
```dart
  void requestAuthorization() async {
    try {
      final readTypes = <String>[];
      readTypes.addAll(QuantityType.values.map((e) => e.identifier));
      final writeTypes = <String>[
        QuantityType.stepCount.identifier,
      ];
      final isRequested =
          await HealthKitReporter.requestAuthorization(readTypes, writeTypes);
      if (isRequested) {
        // read data/write data/observe data
      }
    } catch (e) {
      print(e);
    }
  }
```

**Warning: Please keep in mind, Apple Health Kit does not let anyone to know if reading permissions were provided.**

User can decline some of the reading permissions, but the result of the function will still be **true**.
See [Authorization status](https://developer.apple.com/documentation/healthkit/hkhealthstore/1614154-authorizationstatus) 


### Reading Data

After authorization, you can try to start reading data.

```dart
void read(bool isRequested) async {
    if (isRequested) {
      final preferredUnits =
      await HealthKitReporter.preferredUnits([QuantityType.stepCount]);
      preferredUnits.forEach((preferredUnit) async {
        print('preferredUnit: ${preferredUnit.identifier}');
        final type = QuantityTypeFactory.from(preferredUnit.identifier);
        final quantities = await HealthKitReporter.quantityQuery(
            type, preferredUnit, _predicate);
        print('quantity: ${quantities.map((e) => e.map)}');
        final statistics = await HealthKitReporter.statisticsQuery(
            type, preferredUnit, _predicate);
        print('statistics: ${statistics.map}');
      });
      final characteristics = await HealthKitReporter.characteristicsQuery();
      print('characteristics: ${characteristics.map}');
      final categories = await HealthKitReporter.categoryQuery(
          CategoryType.sleepAnalysis, _predicate);
      print('categories: ${categories.map((e) => e.map)}');
      final samples = await HealthKitReporter.sampleQuery(
          QuantityType.stepCount.identifier, _predicate);
      print('samples: ${samples.map((e) => e.map)}');
      final sources = await HealthKitReporter.sourceQuery(
          QuantityType.stepCount.identifier, _predicate);
      print('sources: ${sources.map((e) => e.map)}');
      final correlations = await HealthKitReporter.correlationQuery(
          CorrelationType.bloodPressure.identifier, _predicate);
      print('correlations: ${correlations.map((e) => e.map)}');
    } else {
      print('error isRequested: $isRequested');
    }
  }
```

In the example above, there is a call of **preferredUnits** function. You can provide identifiers to get preferred units for them and eventually receive properly calculated values from queries. The units will be chosen automatically based on you current localization. This is only required for **QuantityTypes**. If you will try to provide invalid unit for a type, you will get an error.

The usage of **sampleQuery** for quantity types will return nearly the same result as **quantityQuery**, but the units for the values will be used according to SI, while **quantityQuery** together with **preferredUnits** will handle values units according to thee current localization.

### Writing Data

Before writing data, you may need to check if writing is allowed by calling **isAuthorizedToWrite**.

If it is ok to write, you need to create a **Sample** object and call a **save** method.

```dart
  Future<bool> saveSteps() {
    final now = DateTime.now();
    final minuteAgo = now.add(Duration(minutes: -1));
    final device = Device('FlutterTracker', 'kvs', 'T-800', '3', '3.0', '1.1.1',
        'kvs.f.t', '444-888-555');
    final source = Source('maApp', 'com.kvs.health_kit_reporter_example');
    final operatingSystem = OperatingSystem(1, 2, 3);
    final sourceRevision =
        SourceRevision(source, '5', 'fit', '4', operatingSystem);
    final harmonized = QuantityHarmonized(100, 'count', null);
    final steps = Quantity(
        QuantityType.stepCount.identifier,
        minuteAgo.millisecondsSinceEpoch,
        now.millisecondsSinceEpoch,
        device,
        sourceRevision,
        harmonized);
    print(steps.map);
    return HealthKitReporter.save(steps);
  }

  void write() async {
    final canWrite = await HealthKitReporter.isAuthorizedToWrite(
        QuantityType.stepCount.identifier);
    if (canWrite) {
      final stepsSaved = await saveSteps();
      print('stepsSaved: $stepsSaved');
    } else {
      print('error canWrite: $canWrite');
    }
  }
```

**Recommendation: As well as for reading, here will better as well to call preferredUnits first, to know what unit is valid for a type.**

**Warning: PLease be sure to provide valid values for the appropriate types. For example, HealthKit will not allow to save Quantity value for the QuantityType.stepCount if the value is 0**

## Observing Data

If you want to know, that something was changed in HealthKit, you can observe the repository.

Try simple **observerQuery** to get notifications if something is changed.

This call is a subscription for EventChannel of the plugin, so don't forget to cancel it as soon as you don't need it anymore.

```dart
  void observerQuery() async {
    final identifier = QuantityType.stepCount.identifier;
    final sub = HealthKitReporter.observerQuery(identifier, _predicate,
        onUpdate: (identifier) async {
      print('Updates for observerQuerySub');
      print(identifier);
    });
    print('observerQuerySub: $sub');
    final isSet = await HealthKitReporter.enableBackgroundDelivery(
        identifier, UpdateFrequency.immediate);
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

## Requirements
The library supports minimum iOS 12. 
Some features like **HeartbeatSeries** are available only starting with iOS 13.0 and like **Electrocardiogramm** starting with iOS 14.0.

## License
Under <a href=https://github.com/VictorKachalov/localized/blob/master/LICENSE>MIT License</a>

## Donation
If you think that this repo helped you to solve the issues you struggle with, please don't be shy and donate :-)

[![Donate](https://img.shields.io/badge/Donate-PayPal-green.svg)](https://www.paypal.com/paypalme/VictorKachalov/5EUR)
