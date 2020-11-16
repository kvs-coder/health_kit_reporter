import 'device.dart';
import 'sample.dart';
import 'source_revision.dart';

class Quantity extends Sample {
  const Quantity(
    String identifier,
    double startTimestamp,
    double endTimestamp,
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
}

class Harmonized {
  const Harmonized(
    this.value,
    this.unit,
    this.metadata,
  );

  final double value;
  final String unit;
  final Map<String, String> metadata;

  Map<String, dynamic> get map => {
        'value': value,
        'unit': unit,
        'metadata': metadata,
      };
}
