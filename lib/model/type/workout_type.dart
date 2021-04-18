import '../../exceptions.dart';

/// Equivalent of [WorkoutType]
/// from [HealthKitReporter] https://cocoapods.org/pods/HealthKitReporter
///
/// Supports [identifier] extension representing
/// original [String] of the type.
///
enum WorkoutType {
  workoutType,
}

extension WorkoutTypeIdentifier on WorkoutType {
  String get identifier {
    switch (this) {
      case WorkoutType.workoutType:
        return 'HKWorkoutTypeIdentifier';
    }
  }
}

extension WorkoutTypeFactory on WorkoutType {
  static WorkoutType from(String identifier) {
    for (final type in WorkoutType.values) {
      if (type.identifier == identifier) {
        return type;
      }
    }
    throw InvalidValueException('Unknown identifier: $identifier');
  }

  /// The [from] exception handling
  ///
  static WorkoutType? tryFrom(String identifier) {
    try {
      return from(identifier);
    } on InvalidValueException {
      return null;
    }
  }
}
