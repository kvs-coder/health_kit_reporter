import 'package:health_kit_reporter/exceptions.dart';

enum WorkoutEventType {
  pause,
  resume,
  lap,
  marker,
  motionPaused,
  motionResumed,
  segment,
  pauseOrResumeRequest
}

extension Value on WorkoutEventType {
  int get value {
    switch (this) {
      case WorkoutEventType.pause:
        return 1;
      case WorkoutEventType.resume:
        return 2;
      case WorkoutEventType.lap:
        return 3;
      case WorkoutEventType.marker:
        return 4;
      case WorkoutEventType.motionPaused:
        return 5;
      case WorkoutEventType.motionResumed:
        return 6;
      case WorkoutEventType.segment:
        return 7;
      case WorkoutEventType.pauseOrResumeRequest:
        return 8;
    }
  }
}

extension Description on WorkoutEventType {
  String get description {
    switch (this) {
      case WorkoutEventType.pause:
        return 'Pause';
      case WorkoutEventType.resume:
        return 'Resume';
      case WorkoutEventType.lap:
        return 'Lap';
      case WorkoutEventType.marker:
        return 'Marker';
      case WorkoutEventType.motionPaused:
        return 'Motion paused';
      case WorkoutEventType.motionResumed:
        return 'Motion Resumed';
      case WorkoutEventType.segment:
        return 'Segment';
      case WorkoutEventType.pauseOrResumeRequest:
        return 'Pause on resume request';
    }
  }
}

extension WorkoutEventTypeFactory on WorkoutEventType {
  static WorkoutEventType from(int value) {
    switch (value) {
      case 1:
        return WorkoutEventType.pause;
      case 2:
        return WorkoutEventType.resume;
      case 3:
        return WorkoutEventType.lap;
      case 4:
        return WorkoutEventType.marker;
      case 5:
        return WorkoutEventType.motionPaused;
      case 6:
        return WorkoutEventType.motionResumed;
      case 7:
        return WorkoutEventType.segment;
      case 8:
        return WorkoutEventType.pauseOrResumeRequest;
      default:
        throw (InvalidValueException('Unknown value: $value'));
    }
  }
}
