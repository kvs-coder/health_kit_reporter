import 'package:health_kit_reporter/model/payload/category.dart';
import 'package:health_kit_reporter/model/payload/quantity.dart';
import 'package:health_kit_reporter/model/payload/sample.dart';

import 'device.dart';
import 'source_revision.dart';

class Correlation extends Sample<Harmonized> {
  const Correlation(
    String identifier,
    num startTimestamp,
    num endTimestamp,
    Device device,
    SourceRevision sourceRevision,
    Harmonized harmonized,
  ) : super(
          identifier,
          startTimestamp,
          endTimestamp,
          device,
          sourceRevision,
          harmonized,
        );

  Correlation.fromJson(Map<String, dynamic> json)
      : super.fromJson(json,
            harmonized: Harmonized.fromJson(json['harmonized']));

  @override
  Map<String, dynamic> get map => {
        'identifier': identifier,
        'startTimestamp': startTimestamp,
        'endTimestamp': endTimestamp,
        'device': device.map,
        'sourceRevision': sourceRevision.map,
        'harmonized': harmonized.map,
      };
}

class Harmonized {
  const Harmonized(
    this.quantitySamples,
    this.categorySamples,
    this.metadata,
  );

  final List<Quantity> quantitySamples;
  final List<Category> categorySamples;
  final Map<String, dynamic> metadata;

  Map<String, dynamic> get map => {
        'quantitySamples': quantitySamples.map((e) => e.map),
        'categorySamples': categorySamples.map((e) => e.map),
        'metadata': metadata,
      };

  Harmonized.fromJson(Map<String, dynamic> json)
      : quantitySamples = Quantity.collect(json['quantitySamples']),
        categorySamples = Category.collect(json['categorySamples']),
        metadata = json['metadata'];
}
