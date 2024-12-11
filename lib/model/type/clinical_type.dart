import '../../exceptions.dart';

/// Equivalent of [ClinicalType]
/// from [HealthKitReporter] https://cocoapods.org/pods/HealthKitReporter
///
/// Supports [identifier] extension representing
/// original [String] of the type.
///
/// Has a factory methods [from] and [tryFrom]
/// Creating from [String]
///
enum ClinicalType {
  allergyRecord,
  conditionRecord,
  immunizationRecord,
  labResultRecord,
  medicationRecord,
  procedureRecord,
  vitalSignRecord,
}

extension ClinicalTypeIdentifier on ClinicalType {
  String get identifier {
    switch (this) {
      case ClinicalType.allergyRecord:
        return "HKClinicalTypeIdentifierAllergyRecord";
      case ClinicalType.conditionRecord:
        return "HKClinicalTypeIdentifierConditionRecord";
      case ClinicalType.immunizationRecord:
        return "HKClinicalTypeIdentifierImmunizationRecord";
      case ClinicalType.labResultRecord:
        return "HKClinicalTypeIdentifierLabResultRecord";
      case ClinicalType.medicationRecord:
        return "HKClinicalTypeIdentifierMedicationRecord";
      case ClinicalType.procedureRecord:
        return "HKClinicalTypeIdentifierProcedureRecord";
      case ClinicalType.vitalSignRecord:
        return "HKClinicalTypeIdentifierVitalSignRecord";
    }
  }
}

extension ClinicalTypeFactory on ClinicalType {
  static ClinicalType from(String identifier) {
    for (final type in ClinicalType.values) {
      if (type.identifier == identifier) {
        return type;
      }
    }
    throw InvalidValueException('Unknown identifier: $identifier');
  }

  /// The [from] exception handling
  ///
  static ClinicalType? tryFrom(String identifier) {
    try {
      return from(identifier);
    } on InvalidValueException {
      return null;
    }
  }
}
