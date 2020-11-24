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
    this.ibiArray,
    this.indexArray,
  );

  final List<double> ibiArray;
  final List<int> indexArray;

  Map<String, dynamic> get map => {
        'ibiArray': ibiArray,
        'indexArray': indexArray,
      };

  HeartbeatSerie.fromJson(Map<String, dynamic> json)
      : ibiArray = json['ibiArray'],
        indexArray = json['indexArray'];
}
