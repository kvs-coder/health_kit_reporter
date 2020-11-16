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
