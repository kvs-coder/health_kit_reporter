import 'package:flutter_test/flutter_test.dart';
import 'package:health_kit_reporter/model/payload/scored_assessment.dart';

import 'fixtures.dart';

void main() {
  test('scored_assessment_parse_from_json', () {
    final sut = ScoredAssessment.fromJson(scoredAssessmentJson());
    expect(sut.uuid, 'GAD7-UUID');
    expect(sut.identifier, 'HKScoredAssessmentTypeIdentifierGAD7');
    expect(sut.harmonized.answers, [0, 1, 2, 3, 0, 1, 2]);
    expect(sut.harmonized.score, 9);
    expect(sut.harmonized.risk, 2);
  });

  test('scored_assessment_built_in_dart_has_no_score', () {
    final json = scoredAssessmentJson();
    (json['harmonized'] as Map)
      ..remove('score')
      ..remove('risk');
    final sut = ScoredAssessment.fromJson(json);
    expect(sut.harmonized.score, isNull);
    expect(sut.harmonized.risk, isNull);
    expect(sut.parsed().keys, ['scoredAssessment']);
  });
}
