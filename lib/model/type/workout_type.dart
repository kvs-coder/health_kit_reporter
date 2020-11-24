import '../../exceptions.dart';

enum WorkoutType {
  workoutType,
}

extension WorkoutTypeIdentifier on WorkoutType {
  String get identifier {
    switch (this) {
      case WorkoutType.workoutType:
        return 'HKWorkoutTypeIdentifier';
    }
    throw InvalidValueException('Unknown case: $this');
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

  static WorkoutType tryFrom(String identifier) {
    try {
      return from(identifier);
    } on InvalidValueException {
      return null;
    }
  }
}
