import 'package:health_kit_reporter/model/type/clinical_type.dart';

import 'device.dart';
import 'sample.dart';
import 'source_revision.dart';

/// Equivalent of [ClinicalRecord]
/// from [HealthKitReporter] https://cocoapods.org/pods/HealthKitReporter
///
/// Supports [map] representation.
///
/// Has a [ClinicalRecord.fromJson] constructor
/// to create instances from JSON payload coming from iOS native code.
///
/// Requires [ClinicalType] permissions provided.
///
class ClinicalRecord extends Sample<ClinicalRecordHarmonized> {
  const ClinicalRecord(
    String uuid,
    String identifier,
    num startTimestamp,
    num endTimestamp,
    Device? device,
    SourceRevision sourceRevision,
    ClinicalRecordHarmonized harmonized,
  ) : super(
          uuid,
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
  ClinicalRecord.fromJson(Map<String, dynamic> json)
      : super.from(json, ClinicalRecordHarmonized.fromJson(json['harmonized']));
}

/// Equivalent of [ClinicalRecord.Harmonized]
/// from [HealthKitReporter] https://cocoapods.org/pods/HealthKitReporter
///
/// Supports [map] representation.
///
/// Has a [ClinicalRecordHarmonized.fromJson] constructor
/// to create instances from JSON payload coming from iOS native code.
///
class ClinicalRecordHarmonized {
  const ClinicalRecordHarmonized(
    this.displayName,
    this.fhirSourceUrl,
    this.fhirVersion,
    this.fhirData,
    this.metadata,
  );

  final String displayName;
  final String? fhirSourceUrl;
  final String? fhirVersion;
  final String? fhirData;
  final Map<String, dynamic>? metadata;

  /// General map representation
  ///
  Map<String, dynamic> get map => {
        'displayName': displayName,
        'fhirSourceUrl': fhirSourceUrl,
        'fhirVersion': fhirVersion,
        'fhirData': fhirData,
        'metadata': metadata,
      };

  /// General constructor from JSON payload
  ///
  ClinicalRecordHarmonized.fromJson(Map<String, dynamic> json)
      : displayName = json['displayName'],
        fhirSourceUrl = json['fhirSourceUrl'],
        fhirVersion = json['fhirVersion'],
        fhirData = json['fhirData'],
        metadata = json['metadata'];
}
