import '../decorator/extensions.dart';
import '../type/medication_type.dart';

/// Equivalent of [UserAnnotatedMedication]
/// from [HealthKitReporter] https://github.com/kvs-coder/HealthKitReporter
///
/// Medication the user tracks in the Health app (iOS 26+). Read only.
///
/// Supports [map] representation.
///
/// Has a [UserAnnotatedMedication.fromJson] constructor
/// to create instances from JSON payload coming from iOS native code.
/// And supports multiple object creation by [collect] method from JSON list.
///
/// Requires per-object read authorization of [MedicationType.userAnnotatedMedication].
///
class UserAnnotatedMedication {
  const UserAnnotatedMedication(
    this.nickname,
    this.isArchived,
    this.hasSchedule,
    this.medication,
  );

  final String? nickname;
  final bool isArchived;
  final bool hasSchedule;
  final UserAnnotatedMedicationConcept medication;

  /// General map representation
  ///
  Map<String, dynamic> get map => {
        'nickname': nickname,
        'isArchived': isArchived,
        'hasSchedule': hasSchedule,
        'medication': medication.map,
      };

  /// General constructor from JSON payload
  ///
  UserAnnotatedMedication.fromJson(Map<String, dynamic> json)
      : nickname = json['nickname'],
        isArchived = json['isArchived'],
        hasSchedule = json['hasSchedule'],
        medication = UserAnnotatedMedicationConcept.fromJson(
            Map<String, dynamic>.from(json['medication']));

  /// Simplifies creating a list of objects from JSON payload.
  ///
  static List<UserAnnotatedMedication> collect(List<dynamic> list) =>
      parseList(list, UserAnnotatedMedication.fromJson);
}

/// Equivalent of [UserAnnotatedMedication.Concept]
/// from [HealthKitReporter] https://github.com/kvs-coder/HealthKitReporter
///
/// The medication a user tracks, with its codings.
///
class UserAnnotatedMedicationConcept {
  const UserAnnotatedMedicationConcept(
    this.identifier,
    this.domain,
    this.displayText,
    this.generalForm,
    this.relatedCodings,
  );

  /// Opaque identifier; pass it to
  /// [HealthKitReporter.medicationDoseEventQuery] to read this medication's doses
  final String identifier;
  final String domain;
  final String displayText;

  /// E.g. tablet, capsule, liquid
  final String generalForm;
  final List<UserAnnotatedMedicationCoding> relatedCodings;

  /// General map representation
  ///
  Map<String, dynamic> get map => {
        'identifier': identifier,
        'domain': domain,
        'displayText': displayText,
        'generalForm': generalForm,
        'relatedCodings': relatedCodings.map((e) => e.map).toList(),
      };

  /// General constructor from JSON payload
  ///
  UserAnnotatedMedicationConcept.fromJson(Map<String, dynamic> json)
      : identifier = json['identifier'],
        domain = json['domain'],
        displayText = json['displayText'],
        generalForm = json['generalForm'],
        relatedCodings = parseList(
            json['relatedCodings'], UserAnnotatedMedicationCoding.fromJson);
}

/// Equivalent of [UserAnnotatedMedication.Coding]
/// from [HealthKitReporter] https://github.com/kvs-coder/HealthKitReporter
///
/// One code of a medication concept, e.g. RxNorm.
///
class UserAnnotatedMedicationCoding {
  const UserAnnotatedMedicationCoding(
    this.system,
    this.version,
    this.code,
  );

  final String system;
  final String? version;
  final String code;

  /// General map representation
  ///
  Map<String, dynamic> get map => {
        'system': system,
        'version': version,
        'code': code,
      };

  /// General constructor from JSON payload
  ///
  UserAnnotatedMedicationCoding.fromJson(Map<String, dynamic> json)
      : system = json['system'],
        version = json['version'],
        code = json['code'];
}
