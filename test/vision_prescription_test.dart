import 'package:flutter_test/flutter_test.dart';
import 'package:health_kit_reporter/model/payload/sample.dart';
import 'package:health_kit_reporter/model/payload/vision_prescription.dart';

import 'fixtures.dart';

void main() {
  final json = {
    'uuid': '6C1E2A10-0000-4000-8000-000000000001',
    'identifier': 'HKVisionPrescriptionTypeIdentifier',
    'startTimestamp': 1704067200.0,
    'endTimestamp': 1704067200.0,
    'sourceRevision': sourceRevisionJson(),
    'harmonized': {
      'dateIssuedTimestamp': 1704067200,
      'expirationDateTimestamp': 1767225600,
      'prescriptionType': {'id': 1, 'detail': 'Glasses'},
      'rightEye': {
        'sphere': -1.25,
        'cylinder': -0.5,
        'axis': 90,
        'addPower': null,
        'vertexDistance': 12,
        'prism': {'amount': 1, 'angle': 90, 'eye': 2},
        'farPupillaryDistance': 32,
        'nearPupillaryDistance': 30,
        'baseCurve': null,
        'diameter': null,
      },
      'leftEye': {'sphere': -1.0},
      'brand': null,
      'metadata': null,
    },
  };

  test('vision_prescription_dates_are_seconds', () {
    final sut = VisionPrescription.fromJson(json);
    expect(sut.harmonized.dateIssuedTimestamp, 1704067200);
    expect(sut.harmonized.dateIssued.toUtc(), DateTime.utc(2024, 1, 1));
    expect(sut.harmonized.expirationDate!.toUtc(), DateTime.utc(2026, 1, 1));
  });

  test('vision_prescription_parses_lenses', () {
    final sut = VisionPrescription.fromJson(json);
    expect(sut.harmonized.prescriptionType.id, PrescriptionType.glasses.id);
    expect(sut.harmonized.prescriptionType.detail, 'Glasses');
    final right = sut.harmonized.rightEye!;
    expect(right.sphere, -1.25);
    expect(right.cylinder, -0.5);
    expect(right.axis, 90);
    expect(right.prism!.amount, 1);
    expect(right.prism!.eye, 2);
    expect(right.farPupillaryDistance, 32);
    expect(sut.harmonized.leftEye!.sphere, -1.0);
    expect(sut.harmonized.leftEye!.prism, isNull);
  });

  test('vision_prescription_from_sample_factory', () {
    expect(Sample.factory(json), isA<VisionPrescription>());
  });

  test('vision_prescription_round_trips_seconds', () {
    final sut = VisionPrescription.fromJson(json);
    final sent = sut.parsed()['visionPrescription'];
    expect(sent['harmonized']['dateIssuedTimestamp'], 1704067200);
    expect(sent['uuid'], json['uuid']);
    expect(VisionPrescription.fromJson(sent).harmonized.rightEye!.prism!.angle,
        90);
  });
}
