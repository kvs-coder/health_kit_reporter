import '../decorator/extensions.dart';
import '../type/vision_prescription_type.dart';
import 'metadata.dart';
import 'sample.dart';

/// Equivalent of [VisionPrescription]
/// from [HealthKitReporter] https://github.com/kvs-coder/HealthKitReporter
///
/// Glasses or contacts prescription (iOS 16+).
/// Lens powers are in diopters, angles in degrees, distances in millimeters
/// and prism amounts in prism diopters.
///
/// Supports [map] representation.
///
/// Has a [VisionPrescription.fromJson] constructor
/// to create instances from JSON payload coming from iOS native code.
///
/// Requires per-object read authorization,
/// see [HealthKitReporter.requestPerObjectReadAuthorization]
/// with [VisionPrescriptionType.visionPrescription].
///
class VisionPrescription extends Sample<VisionPrescriptionHarmonized> {
  const VisionPrescription(
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
  VisionPrescription.fromJson(Map<String, dynamic> json)
      : super.from(
            json,
            VisionPrescriptionHarmonized.fromJson(
                Map<String, dynamic>.from(json['harmonized'])));

  /// Simplifies creating a list of objects from JSON payload.
  ///
  static List<VisionPrescription> collect(List<dynamic> list) =>
      parseList(list, VisionPrescription.fromJson);
}

/// Equivalent of [VisionPrescription.Harmonized]
/// from [HealthKitReporter] https://github.com/kvs-coder/HealthKitReporter
///
/// [dateIssuedTimestamp] and [expirationDateTimestamp] are seconds since 1970.
///
class VisionPrescriptionHarmonized {
  const VisionPrescriptionHarmonized(
    this.dateIssuedTimestamp,
    this.expirationDateTimestamp,
    this.prescriptionType,
    this.rightEye,
    this.leftEye,
    this.brand,
    this.metadata,
  );

  /// Seconds since 1970
  final num dateIssuedTimestamp;

  /// Seconds since 1970
  final num? expirationDateTimestamp;
  final PrescriptionType prescriptionType;
  final LensSpecification? rightEye;
  final LensSpecification? leftEye;

  /// Contacts only
  final String? brand;
  final Metadata? metadata;

  DateTime get dateIssued => dateFromSeconds(dateIssuedTimestamp);

  DateTime? get expirationDate => expirationDateTimestamp == null
      ? null
      : dateFromSeconds(expirationDateTimestamp!);

  /// General map representation
  ///
  Map<String, dynamic> get map => {
        'dateIssuedTimestamp': dateIssuedTimestamp,
        'expirationDateTimestamp': expirationDateTimestamp,
        'prescriptionType': prescriptionType.map,
        'rightEye': rightEye?.map,
        'leftEye': leftEye?.map,
        'brand': brand,
        'metadata': metadata?.map,
      };

  /// General constructor from JSON payload
  ///
  VisionPrescriptionHarmonized.fromJson(Map<String, dynamic> json)
      : dateIssuedTimestamp = parseNum(json['dateIssuedTimestamp']),
        expirationDateTimestamp = tryParseNum(json['expirationDateTimestamp']),
        prescriptionType = PrescriptionType.fromJson(
            Map<String, dynamic>.from(json['prescriptionType'])),
        rightEye = LensSpecification.tryFromJson(json['rightEye']),
        leftEye = LensSpecification.tryFromJson(json['leftEye']),
        brand = json['brand'],
        metadata = Metadata.tryFromJson(json['metadata']);
}

/// Equivalent of [VisionPrescription.PrescriptionType]:
/// glasses (id 1) or contacts (id 2)
///
class PrescriptionType {
  const PrescriptionType(this.id, this.detail);

  static const glasses = PrescriptionType(1, 'Glasses');
  static const contacts = PrescriptionType(2, 'Contacts');

  final int id;
  final String detail;

  /// General map representation
  ///
  Map<String, dynamic> get map => {'id': id, 'detail': detail};

  /// General constructor from JSON payload
  ///
  PrescriptionType.fromJson(Map<String, dynamic> json)
      : id = json['id'],
        detail = json['detail'];
}

/// Equivalent of [VisionPrescription.LensSpecification]: the lens of one eye.
/// Glasses use the vertex distance, prism and pupillary distances;
/// contacts the base curve and diameter
///
class LensSpecification {
  const LensSpecification(
    this.sphere, {
    this.cylinder,
    this.axis,
    this.addPower,
    this.vertexDistance,
    this.prism,
    this.farPupillaryDistance,
    this.nearPupillaryDistance,
    this.baseCurve,
    this.diameter,
  });

  /// D
  final num sphere;

  /// D
  final num? cylinder;

  /// deg
  final num? axis;

  /// D
  final num? addPower;

  /// mm
  final num? vertexDistance;
  final Prism? prism;

  /// mm
  final num? farPupillaryDistance;

  /// mm
  final num? nearPupillaryDistance;

  /// mm
  final num? baseCurve;

  /// mm
  final num? diameter;

  /// General map representation
  ///
  Map<String, dynamic> get map => {
        'sphere': sphere,
        'cylinder': cylinder,
        'axis': axis,
        'addPower': addPower,
        'vertexDistance': vertexDistance,
        'prism': prism?.map,
        'farPupillaryDistance': farPupillaryDistance,
        'nearPupillaryDistance': nearPupillaryDistance,
        'baseCurve': baseCurve,
        'diameter': diameter,
      };

  /// General constructor from JSON payload
  ///
  LensSpecification.fromJson(Map<String, dynamic> json)
      : sphere = parseNum(json['sphere']),
        cylinder = tryParseNum(json['cylinder']),
        axis = tryParseNum(json['axis']),
        addPower = tryParseNum(json['addPower']),
        vertexDistance = tryParseNum(json['vertexDistance']),
        prism = json['prism'] == null
            ? null
            : Prism.fromJson(Map<String, dynamic>.from(json['prism'])),
        farPupillaryDistance = tryParseNum(json['farPupillaryDistance']),
        nearPupillaryDistance = tryParseNum(json['nearPupillaryDistance']),
        baseCurve = tryParseNum(json['baseCurve']),
        diameter = tryParseNum(json['diameter']);

  static LensSpecification? tryFromJson(dynamic json) => json == null
      ? null
      : LensSpecification.fromJson(Map<String, dynamic>.from(json));
}

/// Equivalent of [VisionPrescription.Prism], correcting double vision
///
class Prism {
  const Prism(this.amount, this.angle, this.eye);

  /// pD
  final num amount;

  /// deg
  final num angle;

  /// 1 left, 2 right
  final int eye;

  /// General map representation
  ///
  Map<String, dynamic> get map => {
        'amount': amount,
        'angle': angle,
        'eye': eye,
      };

  /// General constructor from JSON payload
  ///
  Prism.fromJson(Map<String, dynamic> json)
      : amount = parseNum(json['amount']),
        angle = parseNum(json['angle']),
        eye = json['eye'];
}
