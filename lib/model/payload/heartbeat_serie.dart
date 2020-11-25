/// Equivalent of [HeartbeatSerie]
/// from [HealthKitReporter] https://cocoapods.org/pods/HealthKitReporter
///
/// Supports [map] representation.
///
/// Has a [HeartbeatSerie.fromJson] constructor
/// to create instances from JSON payload coming from iOS native code.
///
/// Requires [SeriesType] permissions provided.
///
class HeartbeatSerie {
  const HeartbeatSerie(
    this.timeSinceSeriesStart,
    this.precededByGap,
    this.done,
  );

  final num timeSinceSeriesStart;
  final bool precededByGap;
  final bool done;

  Map<String, dynamic> get map => {
        'timeSinceSeriesStart': timeSinceSeriesStart,
        'precededByGap': precededByGap,
        'done': done,
      };

  HeartbeatSerie.fromJson(Map<String, dynamic> json)
      : timeSinceSeriesStart = json['timeSinceSeriesStart'],
        precededByGap = json['precededByGap'],
        done = json['done'];
}
