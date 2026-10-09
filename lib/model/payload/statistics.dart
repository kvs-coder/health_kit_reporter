import '../decorator/extensions.dart';
import 'source.dart';
import 'payload.dart';

/// Equivalent of [Statistics]
/// from [HealthKitReporter] https://github.com/kvs-coder/HealthKitReporter
///
/// Supports [map] representation.
///
/// Has a [Statistics.fromJson] constructor
/// to create instances from JSON payload coming from iOS native code.
///
/// [sourceStatistics] holds the values per source when the query
/// separated them by source, otherwise it is null.
///
/// Requires [QuantityType] permissions provided.
///
class Statistics with Payload {
  const Statistics(
    this.identifier,
    this.startTimestamp,
    this.endTimestamp,
    this.harmonized,
    this.sources, [
    this.sourceStatistics,
  ]);

  final String identifier;
  final num startTimestamp;
  final num endTimestamp;
  final List<Source> sources;
  final StatisticsHarmonized harmonized;
  final List<SourceStatistics>? sourceStatistics;

  /// General map representation
  ///
  @override
  Map<String, dynamic> get map => {
        'identifier': identifier,
        'startTimestamp': startTimestamp,
        'endTimestamp': endTimestamp,
        'harmonized': harmonized.map,
        'sources': sources.map((e) => e.map).toList(),
        'sourceStatistics': sourceStatistics?.map((e) => e.map).toList(),
      };

  /// General constructor from JSON payload
  ///
  Statistics.fromJson(Map<String, dynamic> json)
      : identifier = json['identifier'],
        startTimestamp = parseNum(json['startTimestamp']),
        endTimestamp = parseNum(json['endTimestamp']),
        sources = parseList(json['sources'], Source.fromJson),
        harmonized = StatisticsHarmonized.fromJson(
            Map<String, dynamic>.from(json['harmonized'])),
        sourceStatistics = json['sourceStatistics'] == null
            ? null
            : parseList(json['sourceStatistics'], SourceStatistics.fromJson);

  /// Simplifies creating a list of objects from JSON payload.
  ///
  static List<Statistics> collect(List<dynamic> list) =>
      parseList(list, Statistics.fromJson);
}

/// Equivalent of [Statistics.Harmonized]
/// from [HealthKitReporter] https://github.com/kvs-coder/HealthKitReporter
///
/// Supports [map] representation.
///
/// Has a [StatisticsHarmonized.fromJson] constructor
/// to create instances from JSON payload coming from iOS native code.
///
class StatisticsHarmonized with Payload {
  const StatisticsHarmonized(
    this.summary,
    this.average,
    this.recent,
    this.unit,
    this.max, [
    this.min,
    this.duration,
  ]);

  final num? summary;
  final num? average;
  final num? recent;
  final String unit;
  final num? max;
  final num? min;

  /// Seconds of the interval that contain samples (iOS 13+), when HealthKit reports it
  final num? duration;

  /// General map representation
  ///
  @override
  Map<String, dynamic> get map => {
        'summary': summary,
        'average': average,
        'recent': recent,
        'unit': unit,
        'max': max,
        'min': min,
        'duration': duration,
      };

  /// General constructor from JSON payload
  ///
  StatisticsHarmonized.fromJson(Map<String, dynamic> json)
      : summary = tryParseNum(json['summary']),
        average = tryParseNum(json['average']),
        recent = tryParseNum(json['recent']),
        unit = json['unit'],
        max = tryParseNum(json['max']),
        min = tryParseNum(json['min']),
        duration = tryParseNum(json['duration']);
}

/// Equivalent of [Statistics.SourceStatistics]
/// from [HealthKitReporter] https://github.com/kvs-coder/HealthKitReporter
///
/// The statistics values of one [source].
///
class SourceStatistics with Payload {
  const SourceStatistics(this.source, this.harmonized);

  final Source source;
  final StatisticsHarmonized harmonized;

  /// General map representation
  ///
  @override
  Map<String, dynamic> get map => {
        'source': source.map,
        'harmonized': harmonized.map,
      };

  /// General constructor from JSON payload
  ///
  SourceStatistics.fromJson(Map<String, dynamic> json)
      : source = Source.fromJson(Map<String, dynamic>.from(json['source'])),
        harmonized = StatisticsHarmonized.fromJson(
            Map<String, dynamic>.from(json['harmonized']));
}
