import 'package:health_kit_reporter/model/payload/device.dart';
import 'package:health_kit_reporter/model/payload/sample.dart';
import 'package:health_kit_reporter/model/payload/source_revision.dart';
import 'package:health_kit_reporter/model/type/quantity_type.dart';
import 'package:health_kit_reporter/model/type/series_type.dart';

/// Equivalent of [HeartbeatSeriesSample]
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
class HeartbeatSeriesSample extends Sample<HeartbeatSeriesSampleHarmonized> {
  const HeartbeatSeriesSample(
    String uuid,
    String identifier,
    num startTimestamp,
    num endTimestamp,
    Device? device,
    SourceRevision sourceRevision,
    HeartbeatSeriesSampleHarmonized harmonized,
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
  HeartbeatSeriesSample.fromJson(Map<String, dynamic> json)
      : super.from(
            json, HeartbeatSeriesSampleHarmonized.fromJson(json['harmonized']));
}

class HeartbeatSeriesSampleHarmonized {
  const HeartbeatSeriesSampleHarmonized(
    this.count,
    this.series,
    this.metadata,
  );

  final int count;
  final List<HeartbeatSeries> series;
  final Map<String, dynamic>? metadata;

  /// General map representation
  ///
  Map<String, dynamic> get map => {
        'count': count,
        'series': series.map((e) => e.map).toList(),
        'metadata': metadata,
      };

  /// General constructor from JSON payload
  ///
  HeartbeatSeriesSampleHarmonized.fromJson(Map<String, dynamic> json)
      : count = json['count'],
        series = HeartbeatSeries.collect(json['series']),
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
class HeartbeatSeries {
  const HeartbeatSeries(
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
  HeartbeatSeries.fromJson(Map<String, dynamic> json)
      : timeSinceSeriesStart = json['timeSinceSeriesStart'],
        precededByGap = json['precededByGap'],
        done = json['done'];

  /// Simplifies creating a list of objects from JSON payload.
  ///
  static List<HeartbeatSeries> collect(List<dynamic> list) {
    final series = <HeartbeatSeries>[];
    for (final Map<String, dynamic> map in list) {
      final sample = HeartbeatSeries.fromJson(map);
      series.add(sample);
    }
    return series;
  }
}
