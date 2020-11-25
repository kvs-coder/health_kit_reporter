import 'device.dart';
import 'sample.dart';
import 'source_revision.dart';

/// Equivalent of [Quantity]
/// from [HealthKitReporter] https://cocoapods.org/pods/HealthKitReporter
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
    String identifier,
    num startTimestamp,
    num endTimestamp,
    Device device,
    SourceRevision sourceRevision,
    QuantityHarmonized harmonized,
  ) : super(
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
        'identifier': identifier,
        'startTimestamp': startTimestamp,
        'endTimestamp': endTimestamp,
        'device': device.map,
        'sourceRevision': sourceRevision.map,
        'harmonized': harmonized.map,
      };

  /// General constructor from JSON payload
  ///
  Quantity.fromJson(Map<String, dynamic> json)
      : super.fromJson(json,
            harmonized: QuantityHarmonized.fromJson(json['harmonized']));

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
/// from [HealthKitReporter] https://cocoapods.org/pods/HealthKitReporter
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
  final Map<String, dynamic> metadata;

  /// General map representation
  ///
  Map<String, dynamic> get map => {
        'value': value,
        'unit': unit,
        'metadata': metadata,
      };

  /// General constructor from JSON payload
  ///
  QuantityHarmonized.fromJson(Map<String, dynamic> json)
      : value = json['value'],
        unit = json['unit'],
        metadata = json['metadata'];
}
