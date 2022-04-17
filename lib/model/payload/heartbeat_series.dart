import 'package:health_kit_reporter/model/payload/device.dart';
import 'package:health_kit_reporter/model/payload/sample.dart';
import 'package:health_kit_reporter/model/payload/source_revision.dart';
import 'package:health_kit_reporter/model/type/quantity_type.dart';
import 'package:health_kit_reporter/model/type/series_type.dart';

/// Equivalent of [HeartbeatSeries]
/// from [HealthKitReporter] https://cocoapods.org/pods/HealthKitReporter
///
/// Supports [map] representation.
///
/// Has a [HeartbeatSeriesSample.fromJson] constructor
/// to create instances from JSON payload coming from iOS native code.
/// And supports multiple object creation by [collect] method from JSON list.
///
/// Requires [SeriesType.heartbeatSeries] and
/// [QuantityType.heartRateVariabilitySDNN] permissions provided.
///
class HeartbeatSeries extends Sample<HeartbeatSeriesHarmonized> {
  const HeartbeatSeries(
    String uuid,
    String identifier,
    num startTimestamp,
    num endTimestamp,
    Device? device,
    SourceRevision sourceRevision,
    HeartbeatSeriesHarmonized harmonized,
  ) : super(
          uuid,
          identifier,
          startTimestamp,
          endTimestamp,
          device,
          sourceRevision,
          harmonized,
        );

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
        'harmonized': harmonized.map,
      };

  /// General constructor from JSON payload
  ///
  HeartbeatSeries.fromJson(Map<String, dynamic> json)
      : super.from(
            json, HeartbeatSeriesHarmonized.fromJson(json['harmonized']));
}

/// Equivalent of [HeartbeatSeries.Harmonized]
/// from [HealthKitReporter] https://cocoapods.org/pods/HealthKitReporter
///
/// Supports [map] representation.
///
/// Has a [HeartbeatSeriesHarmonized.fromJson] constructor
/// to create instances from JSON payload coming from iOS native code.
///
class HeartbeatSeriesHarmonized {
  const HeartbeatSeriesHarmonized(
    this.count,
    this.measurements,
    this.metadata,
  );

  final int count;
  final List<HeartbeatSeriesMeasurement> measurements;
  final Map<String, dynamic>? metadata;

  /// General map representation
  ///
  Map<String, dynamic> get map => {
        'count': count,
        'measurements': measurements.map((e) => e.map).toList(),
        'metadata': metadata,
      };

  /// General constructor from JSON payload
  ///
  HeartbeatSeriesHarmonized.fromJson(Map<String, dynamic> json)
      : count = json['count'],
        measurements = HeartbeatSeriesMeasurement.collect(json['measurements']),
        metadata = json['metadata'];
}

/// Equivalent of [HeartbeatSeries]
/// from [HealthKitReporter] https://cocoapods.org/pods/HealthKitReporter
///
/// Supports [map] representation.
///
/// Has a [HeartbeatSeries.fromJson] constructor
/// to create instances from JSON payload coming from iOS native code.
///
/// Requires [SeriesType] permissions provided.
///
class HeartbeatSeriesMeasurement {
  const HeartbeatSeriesMeasurement(
    this.timeSinceSeriesStart,
    this.precededByGap,
    this.done,
  );

  final num timeSinceSeriesStart;
  final bool precededByGap;
  final bool done;

  /// General map representation
  ///
  Map<String, dynamic> get map => {
        'timeSinceSeriesStart': timeSinceSeriesStart,
        'precededByGap': precededByGap,
        'done': done,
      };

  /// General constructor from JSON payload
  ///
  HeartbeatSeriesMeasurement.fromJson(Map<String, dynamic> json)
      : timeSinceSeriesStart = json['timeSinceSeriesStart'],
        precededByGap = json['precededByGap'],
        done = json['done'];

  /// Simplifies creating a list of objects from JSON payload.
  ///
  static List<HeartbeatSeriesMeasurement> collect(List<dynamic> list) {
    final measurements = <HeartbeatSeriesMeasurement>[];
    for (final Map<String, dynamic> map in list) {
      final measurement = HeartbeatSeriesMeasurement.fromJson(map);
      measurements.add(measurement);
    }
    return measurements;
  }
}
