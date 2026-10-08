import '../decorator/extensions.dart';
import 'sample.dart';
import 'metadata.dart';

/// Equivalent of [Quantity]
/// from [HealthKitReporter] https://github.com/kvs-coder/HealthKitReporter
///
/// Supports [map] representation.
///
/// Has a [Quantity.fromJson] constructor
/// to create instances from JSON payload coming from iOS native code.
/// And supports multiple object creation by [collect] method from JSON list.
///
/// Requires [QuantityType] permissions provided.
///
class Quantity extends Sample<QuantityHarmonized> {
  const Quantity(
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
  Quantity.fromJson(Map<String, dynamic> json)
      : super.from(json, QuantityHarmonized.fromJson(json['harmonized']));

  /// Simplifies creating a list of objects from JSON payload.
  ///
  static List<Quantity> collect(List<dynamic> list) {
    final samples = <Quantity>[];
    for (final Map<String, dynamic> map in list) {
      final sample = Quantity.fromJson(map);
      samples.add(sample);
    }
    return samples;
  }
}

/// Equivalent of [Quantity.Harmonized]
/// from [HealthKitReporter] https://github.com/kvs-coder/HealthKitReporter
///
/// Supports [map] representation.
///
/// Has a [QuantityHarmonized.fromJson] constructor
/// to create instances from JSON payload coming from iOS native code.
///
class QuantityHarmonized {
  const QuantityHarmonized(
    this.value,
    this.unit,
    this.metadata,
  );

  final num value;
  final String unit;
  final Metadata? metadata;

  /// General map representation
  ///
  Map<String, dynamic> get map => {
        'value': value,
        'unit': unit,
        'metadata': metadata?.map,
      };

  /// General constructor from JSON payload
  ///
  QuantityHarmonized.fromJson(Map<String, dynamic> json)
      : value = parseNum(json['value']),
        unit = json['unit'],
        metadata = Metadata.tryFromJson(json['metadata']);
}
