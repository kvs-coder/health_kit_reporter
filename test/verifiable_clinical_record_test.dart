import 'package:flutter_test/flutter_test.dart';
import 'package:health_kit_reporter/model/payload/verifiable_clinical_record.dart';

import 'fixtures.dart';

void main() {
  test('verifiable_clinical_record_parse_from_json', () {
    final sut =
        VerifiableClinicalRecord.fromJson(verifiableClinicalRecordJson());
    expect(sut.uuid, 'SHC-UUID');
    final harmonized = sut.harmonized;
    expect(harmonized.recordTypes, ['https://smarthealth.cards#immunization']);
    expect(harmonized.issuerIdentifier, 'https://issuer.example');
    expect(harmonized.subject.fullName, 'Jane Doe');
    expect(harmonized.subject.dateOfBirth, '1990-01-01T00:00:00.000+01:00');
    expect(harmonized.issuedTimestamp, 1601065755.0);
    expect(harmonized.relevantTimestamp, 1601065755.0);
    expect(harmonized.expirationTimestamp, isNull);
    expect(harmonized.itemNames, ['COVID-19']);
    expect(harmonized.sourceType, 'https://smarthealth.cards');
    expect(harmonized.dataRepresentation, 'ZXlK');
    expect(VerifiableClinicalRecord.fromJson(sut.map).map, sut.map);
  });
}
