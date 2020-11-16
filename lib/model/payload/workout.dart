import 'device.dart';
import 'sample.dart';
import 'source_revision.dart';
import 'workout_event.dart';

class Workout extends Sample {
  const Workout(
    String identifier,
    double startTimestamp,
    double endTimestamp,
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
  final double duration;
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
  final double totalEnergyBurned;
  final String totalEnergyBurnedUnit;
  final double totalDistance;
  final String totalDistanceUnit;
  final double totalSwimmingStrokeCount;
  final String totalSwimmingStrokeCountUnit;
  final double totalFlightsClimbed;
  final String totalFlightsClimbedUnit;
  final Map<String, String> metadata;

  Map<String, dynamic> get map => {
        'value': value,
        'totalEnergyBurned': totalEnergyBurned,
        'totalEnergyBurnedUnit': totalEnergyBurnedUnit,
        'totalDistance': totalDistance,
        'totalDistanceUnit': totalDistanceUnit,
        'totalSwimmingStrokeCount': totalSwimmingStrokeCount,
        'totalFlightsClimbed': totalFlightsClimbed,
        'totalFlightsClimbedUnit': totalFlightsClimbedUnit,
        'metadata': metadata
      };
}
