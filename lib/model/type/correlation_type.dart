import '../../exceptions.dart';

enum CorrelationType {
  bloodPressure,
  food,
}

extension Identifier on CorrelationType {
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

  static CorrelationType tryFrom(String identifier) {
    try {
      return from(identifier);
    } on InvalidValueException {
      return null;
    }
  }
}
