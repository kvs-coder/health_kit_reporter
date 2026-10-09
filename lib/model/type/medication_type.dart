import '../../exceptions.dart';

/// Equivalent of [MedicationType]
/// from [HealthKitReporter] https://github.com/kvs-coder/HealthKitReporter
///
/// All HealthKit medication types (iOS 26+).
/// Medications need per-object read authorization,
/// see [HealthKitReporter.requestPerObjectReadAuthorization]
///
/// Supports [identifier] extension representing
/// original [String] of the type.
///
/// Has a factory methods [from] and [tryFrom]
/// Creating from [String]
///
enum MedicationType {
  /// [MedicationDoseEvent] samples
  medicationDoseEvent,

  /// medications the user tracks, not samples
  userAnnotatedMedication,
}

extension MedicationTypeIdentifier on MedicationType {
  String get identifier {
    switch (this) {
      case MedicationType.medicationDoseEvent:
        return 'HKMedicationDoseEventTypeIdentifierMedicationDoseEvent';
      case MedicationType.userAnnotatedMedication:
        return 'HKDataTypeUserAnnotatedMedicationConcept';
    }
  }
}

extension MedicationTypeFactory on MedicationType {
  static MedicationType from(String identifier) {
    for (final type in MedicationType.values) {
      if (type.identifier == identifier) {
        return type;
      }
    }
    throw InvalidValueException('Unknown identifier: $identifier');
  }

  /// The [from] exception handling
  ///
  static MedicationType? tryFrom(String identifier) {
    try {
      return from(identifier);
    } on InvalidValueException {
      return null;
    }
  }
}
