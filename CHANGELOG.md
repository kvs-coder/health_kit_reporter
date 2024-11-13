## [2.3.0] - 13.11.2024

* Add max value to Statistics

## [2.2.0] - 01.08.2024

* Add support for Clinical Reports

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
