import 'package:health_kit_reporter/model/type/correlation_type.dart';

import 'category.dart';
import 'quantity.dart';
import 'sample.dart';
import 'metadata.dart';
import 'payload.dart';

/// Equivalent of [Correlation]
/// from [HealthKitReporter] https://github.com/kvs-coder/HealthKitReporter
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
    super.uuid,
    super.identifier,
    super.startTimestamp,
    super.endTimestamp,
    super.device,
    super.sourceRevision,
    super.harmonized,
  );

  /// General constructor from JSON payload
  ///
  Correlation.fromJson(Map<String, dynamic> json)
      : super.from(json, CorrelationHarmonized.fromJson(json['harmonized']));

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
}

/// Equivalent of [Correlation.Harmonized]
/// from [HealthKitReporter] https://github.com/kvs-coder/HealthKitReporter
///
/// Supports [map] representation.
///
/// Has a [CorrelationHarmonized.fromJson] constructor
/// to create instances from JSON payload coming from iOS native code.
///
class CorrelationHarmonized with Payload {
  const CorrelationHarmonized(
    this.quantitySamples,
    this.categorySamples,
    this.metadata,
  );

  final List<Quantity> quantitySamples;
  final List<Category> categorySamples;
  final Metadata? metadata;

  /// General map representation
  ///
  @override
  Map<String, dynamic> get map => {
        'quantitySamples': quantitySamples.map((e) => e.map).toList(),
        'categorySamples': categorySamples.map((e) => e.map).toList(),
        'metadata': metadata?.map,
      };

  /// General constructor from JSON payload
  ///
  CorrelationHarmonized.fromJson(Map<String, dynamic> json)
      : quantitySamples = Quantity.collect(json['quantitySamples']),
        categorySamples = Category.collect(json['categorySamples']),
        metadata = Metadata.tryFromJson(json['metadata']);
}
