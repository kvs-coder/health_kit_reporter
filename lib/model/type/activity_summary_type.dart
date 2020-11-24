import '../../exceptions.dart';

/// Equivalent of [ActivitySummaryType]
/// from [HealthKitReporter] https://cocoapods.org/pods/HealthKitReporter
///
/// Supports [identifier] extension representing
/// original [String] of the type.
///
enum ActivitySummaryType {
  activitySummaryType,
}

extension ActivitySummaryTypeIdentifier on ActivitySummaryType {
  String get identifier {
    switch (this) {
      case ActivitySummaryType.activitySummaryType:
        return 'HKActivitySummaryTypeIdentifier';
    }
    throw InvalidValueException('Unknown case: $this');
  }
}
