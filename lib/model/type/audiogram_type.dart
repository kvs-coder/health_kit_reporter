import '../../exceptions.dart';

/// Equivalent of [AudiogramType]
/// from [HealthKitReporter] https://github.com/kvs-coder/HealthKitReporter
///
/// All HealthKit audiogram types
///
/// Supports [identifier] extension representing
/// original [String] of the type.
///
/// Has a factory methods [from] and [tryFrom]
/// Creating from [String]
///
enum AudiogramType {
  audiogram,
}

extension AudiogramTypeIdentifier on AudiogramType {
  String get identifier {
    switch (this) {
      case AudiogramType.audiogram:
        return 'HKDataTypeIdentifierAudiogram';
    }
  }
}

extension AudiogramTypeFactory on AudiogramType {
  static AudiogramType from(String identifier) {
    for (final type in AudiogramType.values) {
      if (type.identifier == identifier) {
        return type;
      }
    }
    throw InvalidValueException('Unknown identifier: $identifier');
  }

  /// The [from] exception handling
  ///
  static AudiogramType? tryFrom(String identifier) {
    try {
      return from(identifier);
    } on InvalidValueException {
      return null;
    }
  }
}
