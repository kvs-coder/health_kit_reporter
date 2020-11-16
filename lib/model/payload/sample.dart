import 'device.dart';
import 'source_revision.dart';

abstract class Sample<Harmonized> {
  const Sample(
    this.identifier,
    this.startTimestamp,
    this.endTimestamp,
    this.device,
    this.sourceRevision,
    this.harmonized,
  );

  final String identifier;
  final double startTimestamp;
  final double endTimestamp;
  final Device device;
  final SourceRevision sourceRevision;
  final Harmonized harmonized;

  Map<String, dynamic> get map;
}
