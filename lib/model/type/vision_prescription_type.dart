/// Equivalent of [VisionPrescriptionType]
/// from [HealthKitReporter] https://cocoapods.org/pods/HealthKitReporter
///
/// Supports [identifier] extension representing
/// original [String] of the type.
///
enum VisionPrescriptionType {
  visionPrescription,
}

extension VisionPrescriptionTypeIdentifier on VisionPrescriptionType {
  String get identifier {
    switch (this) {
      case VisionPrescriptionType.visionPrescription:
        return 'HKVisionPrescriptionTypeIdentifier';
    }
  }
}
