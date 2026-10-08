/// Equivalent of [ActivitySummaryType]
/// from [HealthKitReporter] https://github.com/kvs-coder/HealthKitReporter
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
  }
}
