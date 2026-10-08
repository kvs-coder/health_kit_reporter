import '../decorator/extensions.dart';
import 'package:health_kit_reporter/model/payload/sample.dart';
import 'package:health_kit_reporter/model/type/quantity_type.dart';
import 'package:health_kit_reporter/model/type/series_type.dart';
import 'metadata.dart';

/// Equivalent of [HeartbeatSeries]
/// from [HealthKitReporter] https://github.com/kvs-coder/HealthKitReporter
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
    super.uuid,
    super.identifier,
    super.startTimestamp,
    super.endTimestamp,
    super.device,
    super.sourceRevision,
    super.harmonized,
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
/// from [HealthKitReporter] https://github.com/kvs-coder/HealthKitReporter
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
  final Metadata? metadata;

  /// General map representation
  ///
  Map<String, dynamic> get map => {
        'count': count,
        'measurements': measurements.map((e) => e.map).toList(),
        'metadata': metadata?.map,
      };

  /// General constructor from JSON payload
  ///
  HeartbeatSeriesHarmonized.fromJson(Map<String, dynamic> json)
      : count = json['count'],
        measurements = HeartbeatSeriesMeasurement.collect(json['measurements']),
        metadata = Metadata.tryFromJson(json['metadata']);
}

/// Equivalent of [HeartbeatSeries]
/// from [HealthKitReporter] https://github.com/kvs-coder/HealthKitReporter
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
      : timeSinceSeriesStart = parseNum(json['timeSinceSeriesStart']),
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
