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
  final String type;
  final num startTimestamp;
  final num endTimestamp;
  final num duration;
  final WorkoutEventHarmonized harmonized;

  const WorkoutEvent(
    this.type,
    this.startTimestamp,
    this.endTimestamp,
    this.duration,
    this.harmonized,
  );

  Map<String, dynamic> get map => {
        'type': type,
        'startTimestamp': startTimestamp,
        'endTimestamp': endTimestamp,
        'duration': duration,
        'harmonized': harmonized.map,
      };

  WorkoutEvent.fromJson(Map<String, dynamic> json)
      : type = json['type'],
        startTimestamp = json['startTimestamp'],
        endTimestamp = json['endTimestamp'],
        duration = json['duration'],
        harmonized = WorkoutEventHarmonized.fromJson(json['harmonized']);

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
  const WorkoutEventHarmonized(
    this.value,
    this.metadata,
  );

  final int value;
  final Map<String, dynamic> metadata;

  Map<String, dynamic> get map => {
        'value': value,
        'metadata': metadata,
      };

  WorkoutEventHarmonized.fromJson(Map<String, dynamic> json)
      : value = json['value'],
        metadata = json['metadata'];
}
