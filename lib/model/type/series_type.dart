import '../../exceptions.dart';

/// Equivalent of [SeriesType]
/// from [HealthKitReporter] https://github.com/kvs-coder/HealthKitReporter
///
/// Supports [identifier] extension representing
/// original [String] of the type.
///
/// Has a factory methods [from] and [tryFrom]
/// Creating from [String]
///
enum SeriesType {
  heartbeatSeries,
  workoutRoute,
}

extension SeriesTypeIdentifier on SeriesType {
  String get identifier {
    switch (this) {
      case SeriesType.heartbeatSeries:
        return 'HKDataTypeIdentifierHeartbeatSeries';
      case SeriesType.workoutRoute:
        return 'HKWorkoutRouteTypeIdentifier';
    }
  }
}

extension SeriesTypeFactory on SeriesType {
  static SeriesType from(String identifier) {
    for (final type in SeriesType.values) {
      if (type.identifier == identifier) {
        return type;
      }
    }
    throw InvalidValueException('Unknown identifier: $identifier');
  }

  /// The [from] exception handling
  ///
  static SeriesType? tryFrom(String identifier) {
    try {
      return from(identifier);
    } on InvalidValueException {
      return null;
    }
  }
}
