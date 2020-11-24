import 'package:health_kit_reporter/model/type/electrocardiogram_type.dart';

import 'device.dart';
import 'sample.dart';
import 'source_revision.dart';

/// Equivalent of [Electrocardiogram]
/// from [HealthKitReporter] https://cocoapods.org/pods/HealthKitReporter
///
/// Supports [map] representation.
///
/// Has a [Electrocardiogram.fromJson] constructor
/// to create instances from JSON payload coming from iOS native code.
///
/// Requires [ElectrocardiogramType] permissions provided.
///
class Electrocardiogram extends Sample<ElectrocardiogramHarmonized> {
  const Electrocardiogram(
    String identifier,
    num startTimestamp,
    num endTimestamp,
    Device device,
    SourceRevision sourceRevision,
    ElectrocardiogramHarmonized harmonized,
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
            harmonized:
                ElectrocardiogramHarmonized.fromJson(json['harmonized']));
}

/// Equivalent of [Electrocardiogram.Harmonized]
/// from [HealthKitReporter] https://cocoapods.org/pods/HealthKitReporter
///
/// Supports [map] representation.
///
/// Has a [ElectrocardiogramHarmonized.fromJson] constructor
/// to create instances from JSON payload coming from iOS native code.
///
class ElectrocardiogramHarmonized {
  const ElectrocardiogramHarmonized(
    this.averageHeartRate,
    this.averageHeartRateUnit,
    this.samplingFrequency,
    this.samplingFrequencyUnit,
    this.classification,
    this.symptomsStatus,
    this.metadata,
  );

  final num averageHeartRate;
  final String averageHeartRateUnit;
  final num samplingFrequency;
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

  ElectrocardiogramHarmonized.fromJson(Map<String, dynamic> json)
      : averageHeartRate = json['averageHeartRate'],
        averageHeartRateUnit = json['averageHeartRateUnit'],
        samplingFrequency = json['averageHeartRate'],
        samplingFrequencyUnit = json['samplingFrequencyUnit'],
        classification = json['classification'],
        symptomsStatus = json['symptomsStatus'],
        metadata = json['metadata'];
}
