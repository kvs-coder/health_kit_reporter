import 'source.dart';

/// Equivalent of [Statistics]
/// from [HealthKitReporter] https://cocoapods.org/pods/HealthKitReporter
///
/// Supports [map] representation.
///
/// Has a [Statistics.fromJson] constructor
/// to create instances from JSON payload coming from iOS native code.
/// And supports multiple object creation by [collect] method from JSON list.
///
/// Requires [QuantityType] permissions provided.
///
class Statistics {
  const Statistics(
    this.identifier,
    this.startTimestamp,
    this.endTimestamp,
    this.harmonized,
    this.sources,
  );

  final String identifier;
  final num startTimestamp;
  final num endTimestamp;
  final List<Source> sources;
  final StatisticsHarmonized harmonized;

  Map<String, dynamic> get map => {
        'identifier': identifier,
        'startTimestamp': startTimestamp,
        'endTimestamp': endTimestamp,
        'harmonized': harmonized.map,
      };

  Statistics.fromJson(Map<String, dynamic> json,
      {StatisticsHarmonized harmonized})
      : identifier = json['identifier'],
        startTimestamp = json['startTimestamp'],
        endTimestamp = json['endTimestamp'],
        sources =
            json['sources'] != null ? Source.collect(json['sources']) : null,
        harmonized = StatisticsHarmonized.fromJson(json['harmonized']);
}

/// Equivalent of [Statistics.Harmonized]
/// from [HealthKitReporter] https://cocoapods.org/pods/HealthKitReporter
///
/// Supports [map] representation.
///
/// Has a [StatisticsHarmonized.fromJson] constructor
/// to create instances from JSON payload coming from iOS native code.
///
class StatisticsHarmonized {
  const StatisticsHarmonized(
    this.summary,
    this.average,
    this.recent,
    this.unit,
  );

  final num summary;
  final num average;
  final num recent;
  final String unit;

  Map<String, dynamic> get map => {
        'summary': summary,
        'average': average,
        'recent': recent,
        'unit': unit,
      };

  StatisticsHarmonized.fromJson(Map<String, dynamic> json)
      : summary = json['summary'],
        average = json['average'],
        recent = json['recent'],
        unit = json['unit'];
}
