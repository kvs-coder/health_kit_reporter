import '../../exceptions.dart';

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
