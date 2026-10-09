import '../../exceptions.dart';

/// Equivalent of [StateOfMindType]
/// from [HealthKitReporter] https://github.com/kvs-coder/HealthKitReporter
///
/// All HealthKit state of mind types (iOS 18+)
///
/// Supports [identifier] extension representing
/// original [String] of the type.
///
/// Has a factory methods [from] and [tryFrom]
/// Creating from [String]
///
enum StateOfMindType {
  stateOfMind,
}

extension StateOfMindTypeIdentifier on StateOfMindType {
  String get identifier {
    switch (this) {
      case StateOfMindType.stateOfMind:
        return 'HKDataTypeStateOfMind';
    }
  }
}

extension StateOfMindTypeFactory on StateOfMindType {
  static StateOfMindType from(String identifier) {
    for (final type in StateOfMindType.values) {
      if (type.identifier == identifier) {
        return type;
      }
    }
    throw InvalidValueException('Unknown identifier: $identifier');
  }

  /// The [from] exception handling
  ///
  static StateOfMindType? tryFrom(String identifier) {
    try {
      return from(identifier);
    } on InvalidValueException {
      return null;
    }
  }
}
