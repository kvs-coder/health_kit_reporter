class WorkoutEvent {
  final String type;
  final double startTimestamp;
  final double endTimestamp;
  final double duration;
  final Harmonized harmonized;

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
}

class Harmonized {
  const Harmonized(
    this.value,
    this.metadata,
  );

  final int value;
  final Map<String, String> metadata;

  Map<String, dynamic> get map => {
        'value': value,
        'metadata': metadata,
      };
}
