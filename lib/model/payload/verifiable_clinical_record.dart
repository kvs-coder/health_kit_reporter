import '../decorator/extensions.dart';
import 'sample.dart';

/// Equivalent of [VerifiableClinicalRecord]
/// from [HealthKitReporter] https://github.com/kvs-coder/HealthKitReporter
///
/// Verifiable clinical record such as a SMART Health Card. Read only.
///
/// Supports [map] representation.
///
/// Has a [VerifiableClinicalRecord.fromJson] constructor
/// to create instances from JSON payload coming from iOS native code.
/// And supports multiple object creation by [collect] method from JSON list.
///
class VerifiableClinicalRecord
    extends Sample<VerifiableClinicalRecordHarmonized> {
  const VerifiableClinicalRecord(
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
  VerifiableClinicalRecord.fromJson(Map<String, dynamic> json)
      : super.from(
            json,
            VerifiableClinicalRecordHarmonized.fromJson(
                Map<String, dynamic>.from(json['harmonized'])));

  /// Simplifies creating a list of objects from JSON payload.
  ///
  static List<VerifiableClinicalRecord> collect(List<dynamic> list) =>
      parseList(list, VerifiableClinicalRecord.fromJson);
}

/// Equivalent of [VerifiableClinicalRecord.Harmonized]
/// from [HealthKitReporter] https://github.com/kvs-coder/HealthKitReporter
///
class VerifiableClinicalRecordHarmonized {
  const VerifiableClinicalRecordHarmonized(
    this.recordTypes,
    this.issuerIdentifier,
    this.subject,
    this.issuedTimestamp,
    this.relevantTimestamp,
    this.expirationTimestamp,
    this.itemNames,
    this.sourceType,
    this.dataRepresentation,
  );

  final List<String> recordTypes;
  final String issuerIdentifier;
  final VerifiableClinicalRecordSubject subject;

  /// Seconds since 1970
  final num issuedTimestamp;

  /// Seconds since 1970
  final num relevantTimestamp;

  /// Seconds since 1970
  final num? expirationTimestamp;
  final List<String> itemNames;

  /// E.g. SMART Health Card, EU Digital COVID Certificate
  final String? sourceType;

  /// Base64 encoded record (JWS for SMART Health Cards); empty before iOS 15.4
  final String dataRepresentation;

  /// General map representation
  ///
  Map<String, dynamic> get map => {
        'recordTypes': recordTypes,
        'issuerIdentifier': issuerIdentifier,
        'subject': subject.map,
        'issuedTimestamp': issuedTimestamp,
        'relevantTimestamp': relevantTimestamp,
        'expirationTimestamp': expirationTimestamp,
        'itemNames': itemNames,
        'sourceType': sourceType,
        'dataRepresentation': dataRepresentation,
      };

  /// General constructor from JSON payload
  ///
  VerifiableClinicalRecordHarmonized.fromJson(Map<String, dynamic> json)
      : recordTypes = List<String>.from(json['recordTypes']),
        issuerIdentifier = json['issuerIdentifier'],
        subject = VerifiableClinicalRecordSubject.fromJson(
            Map<String, dynamic>.from(json['subject'])),
        issuedTimestamp = parseNum(json['issuedTimestamp']),
        relevantTimestamp = parseNum(json['relevantTimestamp']),
        expirationTimestamp = tryParseNum(json['expirationTimestamp']),
        itemNames = List<String>.from(json['itemNames']),
        sourceType = json['sourceType'],
        dataRepresentation = json['dataRepresentation'];
}

/// Equivalent of [VerifiableClinicalRecord.Subject]
/// from [HealthKitReporter] https://github.com/kvs-coder/HealthKitReporter
///
/// The person a verifiable record is about.
///
class VerifiableClinicalRecordSubject {
  const VerifiableClinicalRecordSubject(
    this.fullName,
    this.dateOfBirth,
  );

  final String fullName;

  /// yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ
  final String? dateOfBirth;

  /// General map representation
  ///
  Map<String, dynamic> get map => {
        'fullName': fullName,
        'dateOfBirth': dateOfBirth,
      };

  /// General constructor from JSON payload
  ///
  VerifiableClinicalRecordSubject.fromJson(Map<String, dynamic> json)
      : fullName = json['fullName'],
        dateOfBirth = json['dateOfBirth'];
}
