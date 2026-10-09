import 'package:flutter_test/flutter_test.dart';
import 'package:health_kit_reporter/model/payload/cda_document.dart';

import 'fixtures.dart';

void main() {
  test('cda_document_parse_from_json', () {
    final sut = CDADocument.fromJson(cdaDocumentJson());
    expect(sut.uuid, 'CDA-UUID');
    expect(sut.identifier, 'HKDocumentTypeIdentifierCDA');
    expect(sut.harmonized.title, 'Summary');
    expect(sut.harmonized.patientName, 'Jane Doe');
    expect(sut.harmonized.authorName, 'Dr. Who');
    expect(sut.harmonized.custodianName, 'Clinic');
    expect(sut.harmonized.documentData, 'PENsaW5pY2FsRG9jdW1lbnQvPg==');
    expect(sut.parsed().keys, ['cdaDocument']);
  });

  test('cda_document_without_document_data_parses', () {
    final sut = CDADocument.fromJson({
      ...cdaDocumentJson(),
      'harmonized': <String, dynamic>{'metadata': null},
    });
    expect(sut.harmonized.title, isNull);
    expect(sut.harmonized.documentData, isNull);
  });
}
