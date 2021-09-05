import 'package:health_kit_reporter/model/payload/workout_event_type.dart';

/// Equivalent of [WorkoutEvent]
/// from [HealthKitReporter] https://cocoapods.org/pods/HealthKitReporter
///
/// Supports [map] representation.
///
/// Has a [WorkoutEvent.fromJson] constructor
/// to create instances from JSON payload coming from iOS native code.
/// And supports multiple object creation by [collect] method from JSON list.
///
/// Requires [WorkoutType] permissions provided.
///
class WorkoutEvent {
  final num startTimestamp;
  final num endTimestamp;
  final num duration;
  final WorkoutEventHarmonized harmonized;

  const WorkoutEvent(
    this.startTimestamp,
    this.endTimestamp,
    this.duration,
    this.harmonized,
  );

  /// General map representation
  ///
  Map<String, dynamic> get map => {
        'startTimestamp': startTimestamp,
        'endTimestamp': endTimestamp,
        'duration': duration,
        'harmonized': harmonized.map,
      };

  /// General constructor from JSON payload
  ///
  WorkoutEvent.fromJson(Map<String, dynamic> json)
      : startTimestamp = json['startTimestamp'],
        endTimestamp = json['endTimestamp'],
        duration = json['duration'],
        harmonized = WorkoutEventHarmonized.fromJson(json['harmonized']);

  /// Simplifies creating a list of objects from JSON payload.
  ///
  static List<WorkoutEvent> collect(List<dynamic> list) {
    final samples = <WorkoutEvent>[];
    for (final Map<String, dynamic> map in list) {
      final sample = WorkoutEvent.fromJson(map);
      samples.add(sample);
    }
    return samples;
  }
}

/// Equivalent of [WorkoutEvent.Harmonized]
/// from [HealthKitReporter] https://cocoapods.org/pods/HealthKitReporter
///
/// Supports [map] representation.
///
/// Has a [WorkoutEventHarmonized.fromJson] constructor
/// to create instances from JSON payload coming from iOS native code.
///
class WorkoutEventHarmonized {
  const WorkoutEventHarmonized(this.type, [this.metadata]);

  final WorkoutEventType type;
  final Map<String, dynamic>? metadata;

  /// General map representation
  ///
  Map<String, dynamic> get map => {
        'value': type.value,
        'description': type.description,
        'metadata': metadata,
      };

  /// General constructor from JSON payload
  ///
  WorkoutEventHarmonized.fromJson(Map<String, dynamic> json)
      : type = WorkoutEventTypeFactory.from(json['value']),
        metadata = json['metadata'];
}
