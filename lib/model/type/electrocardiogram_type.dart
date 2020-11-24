import '../../exceptions.dart';

/// Equivalent of [ElectrocardiogramType]
/// from [HealthKitReporter] https://cocoapods.org/pods/HealthKitReporter
///
/// Supports [identifier] extension representing
/// original [String] of the type.
///
/// Has a factory methods [from] and [tryFrom]
/// Creating from [String]
///
enum ElectrocardiogramType {
  electrocardiogramType,
}

extension ElectrocardiogramTypeIdentifier on ElectrocardiogramType {
  String get identifier {
    switch (this) {
      case ElectrocardiogramType.electrocardiogramType:
        return 'HKDataTypeIdentifierElectrocardiogram';
    }
    throw InvalidValueException('Unknown case: $this');
  }
}

extension ElectrocardiogramTypeFactory on ElectrocardiogramType {
  static ElectrocardiogramType from(String identifier) {
    for (final type in ElectrocardiogramType.values) {
      if (type.identifier == identifier) {
        return type;
      }
    }
    throw InvalidValueException('Unknown identifier: $identifier');
  }

  static ElectrocardiogramType tryFrom(String identifier) {
    try {
      return from(identifier);
    } on InvalidValueException {
      return null;
    }
  }
}
