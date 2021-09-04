import 'package:health_kit_reporter/model/payload/workout_activity_type.dart';

import '../type/workout_type.dart';
import 'device.dart';
import 'sample.dart';
import 'source_revision.dart';
import 'workout_event.dart';

/// Equivalent of [Workout]
/// from [HealthKitReporter] https://cocoapods.org/pods/HealthKitReporter
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
    String uuid,
    String identifier,
    num startTimestamp,
    num endTimestamp,
    Device? device,
    SourceRevision sourceRevision,
    WorkoutHarmonized harmonized,
    this.duration,
    this.workoutEvents,
  ) : super(
          uuid,
          identifier,
          startTimestamp,
          endTimestamp,
          device,
          sourceRevision,
          harmonized,
        );

  final num duration;
  final List<WorkoutEvent> workoutEvents;

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
      };

  /// General constructor from JSON payload
  ///
  Workout.fromJson(Map<String, dynamic> json)
      : duration = json['duration'],
        workoutEvents = WorkoutEvent.collect(json['workoutEvents']),
        super.from(json, WorkoutHarmonized.fromJson(json['harmonized']));
}

/// Equivalent of [Workout.Harmonized]
/// from [HealthKitReporter] https://cocoapods.org/pods/HealthKitReporter
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
  final Map<String, dynamic>? metadata;

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
        'metadata': metadata
      };

  /// General constructor from JSON payload
  ///
  WorkoutHarmonized.fromJson(Map<String, dynamic> json)
      : type = WorkoutActivityTypeFactory.from(json['value']),
        totalEnergyBurned = json['totalEnergyBurned'],
        totalEnergyBurnedUnit = json['totalEnergyBurnedUnit'],
        totalDistance = json['totalDistance'],
        totalDistanceUnit = json['totalDistanceUnit'],
        totalSwimmingStrokeCount = json['totalSwimmingStrokeCount'],
        totalSwimmingStrokeCountUnit = json['totalSwimmingStrokeCountUnit'],
        totalFlightsClimbed = json['totalFlightsClimbed'],
        totalFlightsClimbedUnit = json['totalFlightsClimbedUnit'],
        metadata = json['metadata'];
}
