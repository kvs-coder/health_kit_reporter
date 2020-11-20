import 'device.dart';
import 'sample.dart';
import 'source_revision.dart';
import 'workout_event.dart';

class Workout extends Sample<Harmonized> {
  const Workout(
    String identifier,
    num startTimestamp,
    num endTimestamp,
    Device device,
    SourceRevision sourceRevision,
    Harmonized harmonized,
    this.workoutName,
    this.duration,
    this.workoutEvents,
  ) : super(
          identifier,
          startTimestamp,
          endTimestamp,
          device,
          sourceRevision,
          harmonized,
        );

  final String workoutName;
  final num duration;
  final List<WorkoutEvent> workoutEvents;

  @override
  Map<String, dynamic> get map => {
        'identifier': identifier,
        'startTimestamp': startTimestamp,
        'endTimestamp': endTimestamp,
        'workoutName': workoutName,
        'device': device.map,
        'sourceRevision': sourceRevision.map,
        'duration': duration,
        'workoutEvents': workoutEvents.map((e) => e.map),
        'harmonized': harmonized.map,
      };

  Workout.fromJson(Map<String, dynamic> json)
      : workoutName = json['workoutName'],
        duration = json['duration'],
        workoutEvents = WorkoutEvent.collect(json['workoutEvents']),
        super.fromJson(json,
            harmonized: Harmonized.fromJson(json['harmonized']));
}

class Harmonized {
  const Harmonized(
    this.value,
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

  final int value;
  final num totalEnergyBurned;
  final String totalEnergyBurnedUnit;
  final num totalDistance;
  final String totalDistanceUnit;
  final num totalSwimmingStrokeCount;
  final String totalSwimmingStrokeCountUnit;
  final num totalFlightsClimbed;
  final String totalFlightsClimbedUnit;
  final Map<String, dynamic> metadata;

  Map<String, dynamic> get map => {
        'value': value,
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

  Harmonized.fromJson(Map<String, dynamic> json)
      : value = json['value'],
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
