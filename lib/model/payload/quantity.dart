import 'device.dart';
import 'sample.dart';
import 'source_revision.dart';

class Quantity extends Sample<Harmonized> {
  const Quantity(
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

  static List<Quantity> collect(List<dynamic> list) {
    final samples = <Quantity>[];
    for (final Map<String, dynamic> map in list) {
      final sample = Quantity.fromJson(map);
      samples.add(sample);
    }
    return samples;
  }
}

class Harmonized {
  const Harmonized(
    this.value,
    this.unit,
    this.metadata,
  );

  final num value;
  final String unit;
  final Map<String, dynamic> metadata;

  Map<String, dynamic> get map => {
        'value': value,
        'unit': unit,
        'metadata': metadata,
      };

  Harmonized.fromJson(Map<String, dynamic> json)
      : value = json['value'],
        unit = json['unit'],
        metadata = json['metadata'];
}
