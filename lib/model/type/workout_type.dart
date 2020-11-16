import '../../exceptions.dart';

enum WorkoutType {
  workoutType,
}

extension Identifier on WorkoutType {
  String get identifier {
    switch (this) {
      case WorkoutType.workoutType:
        return 'HKWorkoutTypeIdentifier';
    }
    throw InvalidValueException('Unknown case: $this');
  }
}
