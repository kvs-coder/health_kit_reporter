import 'package:health_kit_reporter/model/type/correlation_type.dart';

import 'category.dart';
import 'device.dart';
import 'quantity.dart';
import 'sample.dart';
import 'source_revision.dart';

/// Equivalent of [Correlation]
/// from [HealthKitReporter] https://cocoapods.org/pods/HealthKitReporter
///
/// Supports [map] representation.
///
/// Has a [Correlation.fromJson] constructor
/// to create instances from JSON payload coming from iOS native code.
///
/// Requires [CorrelationType] permissions provided.
///
class Correlation extends Sample<CorrelationHarmonized> {
  const Correlation(
    String uuid,
    String identifier,
    num startTimestamp,
    num endTimestamp,
    Device device,
    SourceRevision sourceRevision,
    CorrelationHarmonized harmonized,
  ) : super(
          uuid,
          identifier,
          startTimestamp,
          endTimestamp,
          device,
          sourceRevision,
          harmonized,
        );

  /// General constructor from JSON payload
  ///
  Correlation.fromJson(Map<String, dynamic> json)
      : super.fromJson(json,
            harmonized: CorrelationHarmonized.fromJson(json['harmonized']));

  /// General map representation
  ///
  @override
  Map<String, dynamic> get map => {
        'uuid': uuid,
        'identifier': identifier,
        'startTimestamp': startTimestamp,
        'endTimestamp': endTimestamp,
        'device': device.map,
        'sourceRevision': sourceRevision.map,
        'harmonized': harmonized.map,
      };
}

/// Equivalent of [Correlation.Harmonized]
/// from [HealthKitReporter] https://cocoapods.org/pods/HealthKitReporter
///
/// Supports [map] representation.
///
/// Has a [CorrelationHarmonized.fromJson] constructor
/// to create instances from JSON payload coming from iOS native code.
///
class CorrelationHarmonized {
  const CorrelationHarmonized(
    this.quantitySamples,
    this.categorySamples,
    this.metadata,
  );

  final List<Quantity> quantitySamples;
  final List<Category> categorySamples;
  final Map<String, dynamic> metadata;

  /// General map representation
  ///
  Map<String, dynamic> get map => {
        'quantitySamples': quantitySamples.map((e) => e.map).toList(),
        'categorySamples': categorySamples.map((e) => e.map).toList(),
        'metadata': metadata,
      };

  /// General constructor from JSON payload
  ///
  CorrelationHarmonized.fromJson(Map<String, dynamic> json)
      : quantitySamples = Quantity.collect(json['quantitySamples']),
        categorySamples = Category.collect(json['categorySamples']),
        metadata = json['metadata'];
}
