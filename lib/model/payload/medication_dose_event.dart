import '../decorator/extensions.dart';
import '../type/medication_type.dart';
import 'metadata.dart';
import 'sample.dart';
import 'payload.dart';

/// Equivalent of [MedicationDoseEvent]
/// from [HealthKitReporter] https://github.com/kvs-coder/HealthKitReporter
///
/// Logged medication dose (iOS 26+). Read only.
/// Schedule type follows HKMedicationDoseEvent.ScheduleType (1 as needed, 2 scheduled),
/// log status HKMedicationDoseEvent.LogStatus (1 not interacted ... 6 not logged).
///
/// Supports [map] representation.
///
/// Has a [MedicationDoseEvent.fromJson] constructor
/// to create instances from JSON payload coming from iOS native code.
/// And supports multiple object creation by [collect] method from JSON list.
///
/// Requires per-object read authorization of [MedicationType.medicationDoseEvent].
///
class MedicationDoseEvent extends Sample<MedicationDoseEventHarmonized> {
  const MedicationDoseEvent(
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
  MedicationDoseEvent.fromJson(Map<String, dynamic> json)
      : super.from(
            json,
            MedicationDoseEventHarmonized.fromJson(
                Map<String, dynamic>.from(json['harmonized'])));

  /// Simplifies creating a list of objects from JSON payload.
  ///
  static List<MedicationDoseEvent> collect(List<dynamic> list) =>
      parseList(list, MedicationDoseEvent.fromJson);
}

/// Equivalent of [MedicationDoseEvent.Harmonized]
/// from [HealthKitReporter] https://github.com/kvs-coder/HealthKitReporter
///
class MedicationDoseEventHarmonized with Payload {
  const MedicationDoseEventHarmonized(
    this.scheduleType,
    this.medicationConceptIdentifier,
    this.scheduledTimestamp,
    this.scheduledDoseQuantity,
    this.doseQuantity,
    this.logStatus,
    this.unit,
    this.metadata,
  );

  final int scheduleType;

  /// Opaque identifier of the medication, see [UserAnnotatedMedicationConcept.identifier]
  final String medicationConceptIdentifier;

  /// Seconds since 1970
  final num? scheduledTimestamp;
  final num? scheduledDoseQuantity;
  final num? doseQuantity;
  final int logStatus;
  final String unit;
  final Metadata? metadata;

  /// General map representation
  ///
  @override
  Map<String, dynamic> get map => {
        'scheduleType': scheduleType,
        'medicationConceptIdentifier': medicationConceptIdentifier,
        'scheduledTimestamp': scheduledTimestamp,
        'scheduledDoseQuantity': scheduledDoseQuantity,
        'doseQuantity': doseQuantity,
        'logStatus': logStatus,
        'unit': unit,
        'metadata': metadata?.map,
      };

  /// General constructor from JSON payload
  ///
  MedicationDoseEventHarmonized.fromJson(Map<String, dynamic> json)
      : scheduleType = parseNum(json['scheduleType']).toInt(),
        medicationConceptIdentifier = json['medicationConceptIdentifier'],
        scheduledTimestamp = tryParseNum(json['scheduledTimestamp']),
        scheduledDoseQuantity = tryParseNum(json['scheduledDoseQuantity']),
        doseQuantity = tryParseNum(json['doseQuantity']),
        logStatus = parseNum(json['logStatus']).toInt(),
        unit = json['unit'],
        metadata = Metadata.tryFromJson(json['metadata']);
}
