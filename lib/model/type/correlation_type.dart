import '../../exceptions.dart';

/// Equivalent of [CorrelationType]
/// from [HealthKitReporter] https://cocoapods.org/pods/HealthKitReporter
///
/// Supports [identifier] extension representing
/// original [String] of the type.
///
/// Has a factory methods [from] and [tryFrom]
/// Creating from [String]
///
enum CorrelationType {
  bloodPressure,
  food,
}

extension CorrelationTypeIdentifier on CorrelationType {
  String get identifier {
    switch (this) {
      case CorrelationType.bloodPressure:
        return 'HKCorrelationTypeIdentifierBloodPressure';
      case CorrelationType.food:
        return 'HKCorrelationTypeIdentifierFood';
    }
    throw InvalidValueException('Unknown case: $this');
  }
}

extension CorrelationTypeFactory on CorrelationType {
  static CorrelationType from(String identifier) {
    for (final type in CorrelationType.values) {
      if (type.identifier == identifier) {
        return type;
      }
    }
    throw InvalidValueException('Unknown identifier: $identifier');
  }

  /// The [from] exception handling
  ///
  static CorrelationType tryFrom(String identifier) {
    try {
      return from(identifier);
    } on InvalidValueException {
      return null;
    }
  }
}
