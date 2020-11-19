import '../decorator/extensions.dart';
import 'device.dart';
import 'sample.dart';
import 'source_revision.dart';

class Quantity extends Sample<Harmonized> {
  const Quantity(
    String identifier,
    int startTimestamp,
    int endTimestamp,
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

  @override
  Map<String, dynamic> get map => {
        'identifier': identifier,
        'startTimestamp': startTimestamp,
        'endTimestamp': endTimestamp,
        'device': device.map,
        'sourceRevision': sourceRevision.map,
        'harmonized': harmonized.map,
      };

  Quantity.fromJson(Map<String, dynamic> json)
      : super.fromJson(json,
            harmonized: Harmonized.fromJson(json['harmonized']));
}

class Harmonized {
  const Harmonized(
    this.value,
    this.unit,
    this.metadata,
  );

  final double value;
  final String unit;
  final Map<String, dynamic> metadata;

  Map<String, dynamic> get map => {
        'value': value,
        'unit': unit,
        'metadata': metadata,
      };

  Harmonized.fromJson(Map<String, dynamic> json)
      : value = json['value'].toString().integer.toDouble(),
        unit = json['unit'],
        metadata = json['metadata'];
}
