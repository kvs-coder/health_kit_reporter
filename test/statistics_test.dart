import 'package:flutter_test/flutter_test.dart';
import 'package:health_kit_reporter/model/payload/statistics.dart';

void main() {
  test('statistics_parse_from_json', () {
    final json = {
      'harmonized': {'summary': 546, 'unit': 'count'},
      'sources': [],
      'endTimestamp': 1630784433.837,
      'identifier': 'HKQuantityTypeIdentifierStepCount',
      'startTimestamp': 1621100009.541
    };
    final sut = Statistics.fromJson(json);
    expect(sut.identifier, 'HKQuantityTypeIdentifierStepCount');
    expect(sut.startTimestamp, 1621100009.541);
    expect(sut.endTimestamp, 1630784433.837);
    expect(sut.harmonized.summary, 546);
    expect(sut.harmonized.unit, 'count');
  });
}
