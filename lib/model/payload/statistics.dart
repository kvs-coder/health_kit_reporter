import '../decorator/extensions.dart';
import 'source.dart';

class Statistics {
  const Statistics(
    this.identifier,
    this.startTimestamp,
    this.endTimestamp,
    this.harmonized,
    this.sources,
  );

  final String identifier;
  final int startTimestamp;
  final int endTimestamp;
  final List<Source> sources;
  final Harmonized harmonized;

  Map<String, dynamic> get map => {
        'identifier': identifier,
        'startTimestamp': startTimestamp,
        'endTimestamp': endTimestamp,
        'harmonized': harmonized.map,
      };

  Statistics.fromJson(Map<String, dynamic> json, {Harmonized harmonized})
      : identifier = json['identifier'],
        startTimestamp = json['startTimestamp'].toString().integer,
        endTimestamp = json['endTimestamp'].toString().integer,
        sources = Source.collect(json['sources']),
        harmonized = Harmonized.fromJson(json['harmonized']);
}

class Harmonized {
  const Harmonized(
    this.summary,
    this.average,
    this.recent,
    this.unit,
  );

  final double summary;
  final double average;
  final double recent;
  final String unit;

  Map<String, dynamic> get map => {
        'summary': summary,
        'average': average,
        'recent': recent,
        'unit': unit,
      };

  Harmonized.fromJson(Map<String, dynamic> json)
      : summary = double.tryParse(json['summary']),
        average = double.tryParse(json['average']),
        recent = double.tryParse(json['recent']),
        unit = json['unit'];
}
