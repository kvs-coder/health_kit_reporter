import 'package:flutter_test/flutter_test.dart';
import 'package:health_kit_reporter/model/payload/state_of_mind.dart';

import 'fixtures.dart';

void main() {
  test('state_of_mind_parse_from_json', () {
    final sut = StateOfMind.fromJson(stateOfMindJson());
    expect(sut.uuid, 'MIND-UUID');
    expect(sut.identifier, 'HKDataTypeStateOfMind');
    expect(sut.harmonized.kind, 1);
    expect(sut.harmonized.valence, 0.5);
    expect(sut.harmonized.valenceClassification, 6);
    expect(sut.harmonized.labels, [1, 14]);
    expect(sut.harmonized.associations, [3]);
  });

  test('state_of_mind_without_read_only_fields_parses', () {
    final json = stateOfMindJson();
    (json['harmonized'] as Map).remove('valenceClassification');
    final sut = StateOfMind.fromJson(json);
    expect(sut.harmonized.valenceClassification, isNull);
    expect(sut.parsed().keys, ['stateOfMind']);
  });
}
