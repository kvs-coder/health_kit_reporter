import '../decorator/extensions.dart';
import 'metadata.dart';
import 'statistics.dart';
import 'workout_activity_type.dart';
import 'workout_event.dart';

/// Equivalent of [WorkoutActivity]
/// from [HealthKitReporter] https://github.com/kvs-coder/HealthKitReporter
///
/// One activity of a multi-sport [Workout] (iOS 16+).
///
/// Supports [map] representation.
///
/// Has a [WorkoutActivity.fromJson] constructor
/// to create instances from JSON payload coming from iOS native code.
///
class WorkoutActivity {
  const WorkoutActivity(
    this.uuid,
    this.activityValue,
    this.activityDescription,
    this.locationValue,
    this.swimmingLocationValue,
    this.lapLength,
    this.startTimestamp,
    this.endTimestamp,
    this.duration,
    this.workoutEvents,
    this.statistics,
    this.metadata,
  );

  final String uuid;

  /// [WorkoutActivityType] value
  final int activityValue;
  final String activityDescription;

  /// HKWorkoutSessionLocationType raw value
  final int locationValue;

  /// HKWorkoutSwimmingLocationType raw value
  final int swimmingLocationValue;

  /// Meters
  final num? lapLength;

  /// Seconds since 1970
  final num startTimestamp;

  /// Seconds since 1970; null while the activity runs
  final num? endTimestamp;

  /// Seconds
  final num duration;
  final List<WorkoutEvent> workoutEvents;

  /// Statistics of every quantity type recorded during the activity, in SI units
  final List<Statistics> statistics;
  final Metadata? metadata;

  WorkoutActivityType get activityType =>
      WorkoutActivityTypeFactory.from(activityValue);

  /// General map representation
  ///
  Map<String, dynamic> get map => {
        'uuid': uuid,
        'activityValue': activityValue,
        'activityDescription': activityDescription,
        'locationValue': locationValue,
        'swimmingLocationValue': swimmingLocationValue,
        'lapLength': lapLength,
        'startTimestamp': startTimestamp,
        'endTimestamp': endTimestamp,
        'duration': duration,
        'workoutEvents': workoutEvents.map((e) => e.map).toList(),
        'statistics': statistics.map((e) => e.map).toList(),
        'metadata': metadata?.map,
      };

  /// General constructor from JSON payload
  ///
  WorkoutActivity.fromJson(Map<String, dynamic> json)
      : uuid = json['uuid'],
        activityValue = json['activityValue'],
        activityDescription = json['activityDescription'],
        locationValue = json['locationValue'],
        swimmingLocationValue = json['swimmingLocationValue'],
        lapLength = tryParseNum(json['lapLength']),
        startTimestamp = parseNum(json['startTimestamp']),
        endTimestamp = tryParseNum(json['endTimestamp']),
        duration = parseNum(json['duration']),
        workoutEvents = parseList(json['workoutEvents'], WorkoutEvent.fromJson),
        statistics = parseList(json['statistics'], Statistics.fromJson),
        metadata = Metadata.tryFromJson(json['metadata']);
}
