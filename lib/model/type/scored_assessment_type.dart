import '../../exceptions.dart';

/// Equivalent of [ScoredAssessmentType]
/// from [HealthKitReporter] https://github.com/kvs-coder/HealthKitReporter
///
/// All HealthKit scored assessment types (iOS 18+)
///
/// Supports [identifier] extension representing
/// original [String] of the type.
///
/// Has a factory methods [from] and [tryFrom]
/// Creating from [String]
///
enum ScoredAssessmentType {
  /// GAD-7 anxiety assessment
  gad7,

  /// PHQ-9 depression assessment
  phq9,
}

extension ScoredAssessmentTypeIdentifier on ScoredAssessmentType {
  String get identifier {
    switch (this) {
      case ScoredAssessmentType.gad7:
        return 'HKScoredAssessmentTypeIdentifierGAD7';
      case ScoredAssessmentType.phq9:
        return 'HKScoredAssessmentTypeIdentifierPHQ9';
    }
  }
}

extension ScoredAssessmentTypeFactory on ScoredAssessmentType {
  static ScoredAssessmentType from(String identifier) {
    for (final type in ScoredAssessmentType.values) {
      if (type.identifier == identifier) {
        return type;
      }
    }
    throw InvalidValueException('Unknown identifier: $identifier');
  }

  /// The [from] exception handling
  ///
  static ScoredAssessmentType? tryFrom(String identifier) {
    try {
      return from(identifier);
    } on InvalidValueException {
      return null;
    }
  }
}
