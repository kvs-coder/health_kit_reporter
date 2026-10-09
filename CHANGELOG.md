# Changelog

## [3.0.0] - 09.10.2026


### BREAKING CHANGES

* the plugin's version is 3.0.0 instead of 4.0.0; depend on health_kit_reporter ^3.0.0.
* sample timestamps built in Dart are seconds since 1970 (use DateTime.secondsSinceEpoch instead of millisecondsSinceEpoch); Sample.factory returns non-null and throws for unknown identifiers; live query error codes are the Dart method names.
* metadata fields are Metadata instead of Map<String, dynamic>; save returns Future<String?> (the uuid); anchoredObjectQuery's onUpdate takes a third anchor argument; delete needs the uuid of the stored sample; model/SampleQueryOptions.dart moved.
* save replies with {status, uuid}, preferredUnits takes {identifiers}, the anchored object query event carries an anchor, and unknown identifiers fail instead of being ignored.
* the plugin builds only with Swift Package Manager enabled (flutter config --enable-swift-package-manager) and requires iOS 15.

### Features

* adapt the iOS plugin to the HealthKitReporter 4.0.0 API ([95cddd7](https://github.com/kvs-coder/health_kit_reporter/commit/95cddd7537f43d594c947ae7136fa032b5022693))
* **example:** BLoC on plain streams and a redesigned catalog ([05e79de](https://github.com/kvs-coder/health_kit_reporter/commit/05e79dec3d75d2da256d59c9a0949b3c93baa654))
* **example:** list every plugin method, grouped by area ([c2cbc0d](https://github.com/kvs-coder/health_kit_reporter/commit/c2cbc0dc3deed473b9e29036d8fbba590befd7c3))
* limit and query options for the sample queries ([44e3e44](https://github.com/kvs-coder/health_kit_reporter/commit/44e3e44b80032ae4da3c2f27dc8af4be7310da72))
* match the HealthKitReporter 4.0.0 JSON contract in Dart ([9065782](https://github.com/kvs-coder/health_kit_reporter/commit/9065782e1fe41a954cfaf786a4d9bdf674cd6f55))
* resolve the 4.0.0 audit findings and reach HealthKitReporter parity ([b2b8830](https://github.com/kvs-coder/health_kit_reporter/commit/b2b8830fb65809275a24124945a51c10e9e603fd))
* Swift tests, SwiftLint, privacy manifest, model equality and architecture docs ([378f1bd](https://github.com/kvs-coder/health_kit_reporter/commit/378f1bd492c2475feaaebae9193ad23fbc91d115))
* workout routes of a stored workout ([1d8287b](https://github.com/kvs-coder/health_kit_reporter/commit/1d8287b90d64409b81cf0e3daf279e9372c42f74))


### Fixes

* depend on FlutterFramework, time out the demo setup, attach a PNG ([4e788e6](https://github.com/kvs-coder/health_kit_reporter/commit/4e788e6418464958550a873a606127f62f6247b8))
* **example:** delete only the seeded samples this app wrote ([ec82c7e](https://github.com/kvs-coder/health_kit_reporter/commit/ec82c7eadd2044972be88df8f4de5da052c651a6))
* require HealthKitReporter 4.1.1 ([0c6944b](https://github.com/kvs-coder/health_kit_reporter/commit/0c6944bd2eb8acb6c145a53ff01f555b1330bd08))
* sync quantity and category types with HealthKitReporter 4.0.0 ([65bfe44](https://github.com/kvs-coder/health_kit_reporter/commit/65bfe44b949cf102d37760da3416c99e6265b8da))


### CI

* release with release-please as 3.0.0 ([ab074ef](https://github.com/kvs-coder/health_kit_reporter/commit/ab074efacf224ec3ab058ce845ae8961c6b59865))


### Build

* move the iOS plugin to Swift Package Manager ([318fd73](https://github.com/kvs-coder/health_kit_reporter/commit/318fd73fc60c2b793bd7c8d73e3b93ef81dabda9))

## [2.3.1] - 12.12.2024

* Add missing Workout types 

## [2.3.0] - 13.11.2024

* Add max value to Statistics

## [2.2.0] - 01.08.2024

* Add support for Clinical Reports

## [2.1.1] - 29.05.2023

* Add check for HealthKit availability

## [2.1.0] - 30.10.2022

* Add new types for iOS 16 (also missing for iOS 15)

## [2.0.4] - 27.05.2022

* Add Correlation samples writing

## [2.0.3] - 18.04.2022

* ECG with Voltage measurements in one query on demand

## [2.0.2] - 18.04.2022

* ECG with Voltage measurements in one query

## [2.0.1] - 17.04.2022

* Add workout route as query method, remove it as event stream
* Minor fixes in the code

## [2.0.0] - 09.03.2022

* A way not to provide a predicate where it can be omitted

## [1.5.2] - 04.11.2021

* invalid timstamps fixes for data saving

## [1.5.1] - 15.10.2021

* package minor fixes

## [1.5.0] - 15.10.2021

* no stream heartbeatSeriesQuery. HeartbeatSeries now is a valid sample with a set of beat by beat measurements 

## [1.4.1] - 12.09.2021

* Fix characteristic parsing if not all types are requested for reading

## [1.4.0] - 05.09.2021

* Activity Move mode added
* Wheelchair use added
* Workout activity type added
* Workout configuration fix
* Unit testing DTOs

## [1.3.1] - 28.05.2021

* Fix with error objects coming from Swift

## [1.3.0] - 18.04.2021

* Fix with reinitilizing subscriptions for Events
* Remove Android support

## [1.2.0-nullsafety.0] - 12.03.2021

* Null safety support

## [1.1.1] - 12.03.2021

* Anchored Query fix with deleted objects

## [1.1.0] - 25.02.2021

* iOS 9.0 support
* FIx with workout values
* Fix with UUID of Samples

## [1.0.10] - 01.02.2021

* Fix issue with saving Workout

## [1.0.9] - 01.02.2021

* Added UUID property for Wrappers of original HKObjectTypes

## [1.0.8] - 28.01.2021

* Extended enum cases for Characteristic, Quantity and Category types

## [1.0.7] - 17.01.2021

* Fix with PreferredUnit

## [1.0.6] - 23.12.2020

* Fix with HKActivitySummaryType

## [1.0.5] - 09.12.2020

* Add background delivery in the sample app
* Fix with enable background delivery

## [1.0.4] - 09.12.2020

* Event channels fix for long-running queries

## [1.0.2] - 25.11.2020

* Example app add Electrocardiogram read

## [1.0.1] - 25.11.2020

* Better code documentation

## [1.0.0] - 25.11.2020

* Initial release.
* Full wrap for the HealthKitReporter library
* All models from HealthKitReporter represented in Dart
* Method channel functions
* Event channel handling for long-running queries
* Code documentation

## [0.0.1+1]

* Dart HK Models from HealthKitReporter
* iOS Swift bridging
* Event and Method channel wrappers
