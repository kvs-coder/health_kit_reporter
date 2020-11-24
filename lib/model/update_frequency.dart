import '../exceptions.dart';

/// Equivalent of [UpdateFrequency]
/// from [HealthKitReporter] https://cocoapods.org/pods/HealthKitReporter
///
/// Supports [value] extension representing
/// original [int] of the type.
///
enum UpdateFrequency {
  immediate,
  hourly,
  daily,
  weekly,
}

extension Value on UpdateFrequency {
  int get value {
    switch (this) {
      case UpdateFrequency.immediate:
        return 1;
      case UpdateFrequency.hourly:
        return 2;
      case UpdateFrequency.daily:
        return 3;
      case UpdateFrequency.weekly:
        return 4;
    }
    throw InvalidValueException('Unknown case: $this');
  }
}
