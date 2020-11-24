import 'package:health_kit_reporter/health_kit_reporter.dart';

import '../../../exceptions.dart';

/// Equivalent of [BiologicalSex]
/// from [HealthKitReporter] https://cocoapods.org/pods/HealthKitReporter
///
enum BiologicalSex {
  notSet,
  female,
  male,
  other,
}

/// String description of [BiologicalSex] cases
///
extension Description on BiologicalSex {
  String get string {
    switch (this) {
      case BiologicalSex.notSet:
        return 'na';
      case BiologicalSex.female:
        return 'Female';
      case BiologicalSex.male:
        return 'Male';
      case BiologicalSex.other:
        return 'Other';
    }
    throw InvalidValueException('Unknown case: $this');
  }
}

/// Factory for [BiologicalSex]
/// Creating from [String]
///
extension BiologicalSexFactory on BiologicalSex {
  static BiologicalSex from(String string) {
    switch (string) {
      case 'na':
        return BiologicalSex.notSet;
      case 'Female':
        return BiologicalSex.female;
      case 'Male':
        return BiologicalSex.male;
      case 'Other':
        return BiologicalSex.other;
      default:
        return null;
    }
  }
}
