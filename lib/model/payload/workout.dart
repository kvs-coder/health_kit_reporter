import '../decorator/extensions.dart';
import 'package:health_kit_reporter/model/payload/workout_activity_type.dart';

import '../type/workout_type.dart';
import 'sample.dart';
import 'statistics.dart';
import 'workout_activity.dart';
import 'workout_event.dart';
import 'metadata.dart';

/// Equivalent of [Workout]
/// from [HealthKitReporter] https://github.com/kvs-coder/HealthKitReporter
///
/// Supports [map] representation.
///
/// Has a [Workout.fromJson] constructor
/// to create instances from JSON payload coming from iOS native code.
///
/// Requires [WorkoutType] permissions provided.
///
class Workout extends Sample<WorkoutHarmonized> {
  const Workout(
    super.uuid,
    super.identifier,
    super.startTimestamp,
    super.endTimestamp,
    super.device,
    super.sourceRevision,
    super.harmonized,
    this.duration,
    this.workoutEvents, [
    this.statistics,
    this.activities,
  ]);

  final num duration;
  final List<WorkoutEvent> workoutEvents;

  /// Statistics of every quantity type recorded during the workout (iOS 16+)
  final List<Statistics>? statistics;

  /// Activities of a multi-sport workout (iOS 16+)
  final List<WorkoutActivity>? activities;

  /// General map representation
  ///
  @override
  Map<String, dynamic> get map => {
        'uuid': uuid,
        'identifier': identifier,
        'startTimestamp': startTimestamp,
        'endTimestamp': endTimestamp,
        'device': device?.map,
        'sourceRevision': sourceRevision.map,
        'duration': duration,
        'workoutEvents': workoutEvents.map((e) => e.map).toList(),
        'harmonized': harmonized.map,
        'statistics': statistics?.map((e) => e.map).toList(),
        'activities': activities?.map((e) => e.map).toList(),
      };

  /// General constructor from JSON payload
  ///
  Workout.fromJson(Map<String, dynamic> json)
      : duration = parseNum(json['duration']),
        workoutEvents = parseList(json['workoutEvents'], WorkoutEvent.fromJson),
        statistics = json['statistics'] == null
            ? null
            : parseList(json['statistics'], Statistics.fromJson),
        activities = json['activities'] == null
            ? null
            : parseList(json['activities'], WorkoutActivity.fromJson),
        super.from(
            json,
            WorkoutHarmonized.fromJson(
                Map<String, dynamic>.from(json['harmonized'])));
}

/// Equivalent of [Workout.Harmonized]
/// from [HealthKitReporter] https://github.com/kvs-coder/HealthKitReporter
///
/// Supports [map] representation.
///
/// Has a [WorkoutHarmonized.fromJson] constructor
/// to create instances from JSON payload coming from iOS native code.
///
class WorkoutHarmonized {
  const WorkoutHarmonized(
    this.type,
    this.totalEnergyBurned,
    this.totalEnergyBurnedUnit,
    this.totalDistance,
    this.totalDistanceUnit,
    this.totalSwimmingStrokeCount,
    this.totalSwimmingStrokeCountUnit,
    this.totalFlightsClimbed,
    this.totalFlightsClimbedUnit,
    this.metadata,
  );

  final WorkoutActivityType type;
  final num? totalEnergyBurned;
  final String totalEnergyBurnedUnit;
  final num? totalDistance;
  final String totalDistanceUnit;
  final num? totalSwimmingStrokeCount;
  final String totalSwimmingStrokeCountUnit;
  final num? totalFlightsClimbed;
  final String totalFlightsClimbedUnit;
  final Metadata? metadata;

  /// General map representation
  ///
  Map<String, dynamic> get map => {
        'value': type.value,
        'description': type.description,
        'totalEnergyBurned': totalEnergyBurned,
        'totalEnergyBurnedUnit': totalEnergyBurnedUnit,
        'totalDistance': totalDistance,
        'totalDistanceUnit': totalDistanceUnit,
        'totalSwimmingStrokeCount': totalSwimmingStrokeCount,
        'totalSwimmingStrokeCountUnit': totalSwimmingStrokeCountUnit,
        'totalFlightsClimbed': totalFlightsClimbed,
        'totalFlightsClimbedUnit': totalFlightsClimbedUnit,
        'metadata': metadata?.map
      };

  /// General constructor from JSON payload
  ///
  WorkoutHarmonized.fromJson(Map<String, dynamic> json)
      : type = WorkoutActivityTypeFactory.from(json['value']),
        totalEnergyBurned = tryParseNum(json['totalEnergyBurned']),
        totalEnergyBurnedUnit = json['totalEnergyBurnedUnit'],
        totalDistance = tryParseNum(json['totalDistance']),
        totalDistanceUnit = json['totalDistanceUnit'],
        totalSwimmingStrokeCount =
            tryParseNum(json['totalSwimmingStrokeCount']),
        totalSwimmingStrokeCountUnit = json['totalSwimmingStrokeCountUnit'],
        totalFlightsClimbed = tryParseNum(json['totalFlightsClimbed']),
        totalFlightsClimbedUnit = json['totalFlightsClimbedUnit'],
        metadata = Metadata.tryFromJson(json['metadata']);
}
