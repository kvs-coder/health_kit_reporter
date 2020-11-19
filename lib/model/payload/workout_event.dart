import '../decorator/extensions.dart';

class WorkoutEvent {
  final String type;
  final int startTimestamp;
  final int endTimestamp;
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

  WorkoutEvent.fromJson(Map<String, dynamic> json)
      : type = json['type'],
        startTimestamp = json['startTimestamp'].toString().integer,
        endTimestamp = json['endTimestamp'].toString().integer,
        duration = json['duration'].toString().integer.toDouble(),
        harmonized = Harmonized.fromJson(json['harmonized']);

  static List<WorkoutEvent> collect(List<dynamic> list) {
    final samples = <WorkoutEvent>[];
    for (final Map<String, dynamic> map in list) {
      final sample = WorkoutEvent.fromJson(map);
      samples.add(sample);
    }
    return samples;
  }
}

class Harmonized {
  const Harmonized(
    this.value,
    this.metadata,
  );

  final int value;
  final Map<String, dynamic> metadata;

  Map<String, dynamic> get map => {
        'value': value,
        'metadata': metadata,
      };

  Harmonized.fromJson(Map<String, dynamic> json)
      : value = json['value'].toString().integer,
        metadata = json['metadata'];
}
