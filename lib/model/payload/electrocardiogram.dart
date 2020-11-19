import '../decorator/extensions.dart';
import 'device.dart';
import 'sample.dart';
import 'source_revision.dart';

class Electrocardiogram extends Sample<Harmonized> {
  const Electrocardiogram(
    String identifier,
    int startTimestamp,
    int endTimestamp,
    Device device,
    SourceRevision sourceRevision,
    Harmonized harmonized,
    this.numberOfMeasurements,
  ) : super(
          identifier,
          startTimestamp,
          endTimestamp,
          device,
          sourceRevision,
          harmonized,
        );

  final int numberOfMeasurements;

  @override
  Map<String, dynamic> get map => {
        'identifier': identifier,
        'startTimestamp': startTimestamp,
        'endTimestamp': endTimestamp,
        'device': device.map,
        'sourceRevision': sourceRevision.map,
        'harmonized': harmonized.map,
        'numberOfMeasurements': numberOfMeasurements,
      };

  Electrocardiogram.fromJson(Map<String, dynamic> json)
      : numberOfMeasurements = json['numberOfMeasurements'],
        super.fromJson(json,
            harmonized: Harmonized.fromJson(json['harmonized']));
}

class Harmonized {
  const Harmonized(
    this.averageHeartRate,
    this.averageHeartRateUnit,
    this.samplingFrequency,
    this.samplingFrequencyUnit,
    this.classification,
    this.symptomsStatus,
    this.metadata,
  );

  final int averageHeartRate;
  final String averageHeartRateUnit;
  final double samplingFrequency;
  final String samplingFrequencyUnit;
  final String classification;
  final String symptomsStatus;
  final Map<String, dynamic> metadata;

  Map<String, dynamic> get map => {
        'averageHeartRate': averageHeartRate,
        'averageHeartRateUnit': averageHeartRateUnit,
        'samplingFrequency': samplingFrequency,
        'samplingFrequencyUnit': samplingFrequencyUnit,
        'classification': classification,
        'symptomsStatus': symptomsStatus,
        'metadata': metadata,
      };

  Harmonized.fromJson(Map<String, dynamic> json)
      : averageHeartRate = json['averageHeartRate'].toString().integer,
        averageHeartRateUnit = json['averageHeartRateUnit'],
        samplingFrequency = double.tryParse(json['averageHeartRate']),
        samplingFrequencyUnit = json['samplingFrequencyUnit'],
        classification = json['classification'],
        symptomsStatus = json['symptomsStatus'],
        metadata = json['metadata'];
}
