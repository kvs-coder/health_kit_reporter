import 'package:flutter_test/flutter_test.dart';
import 'package:health_kit_reporter/model/decorator/extensions.dart';
import 'package:health_kit_reporter/model/payload/activity_summary.dart';

void main() {
  test('activity_summary_parse_from_json', () {
    final json = {
      'identifier': 'HKActivitySummaryTypeIdentifier',
      'date': '2021-06-28T20:56:55.000+02:00',
      'harmonized': {
        'activeEnergyBurned': 10.0,
        'activeEnergyBurnedGoal': 100.0,
        'activeEnergyBurnedUnit': 'kcal',
        'appleExerciseTime': 60,
        'appleExerciseTimeGoal': 100,
        'appleExerciseTimeUnit': 'min',
        'appleStandHours': 1,
        'appleStandHoursGoal': 2,
        'appleStandHoursUnit': 'h'
      }
    };
    final sut = ActivitySummary.fromJson(json);
    expect(sut.identifier, 'HKActivitySummaryTypeIdentifier');
    expect(sut.date, '2021-06-28T20:56:55.000+02:00'.toString().date);
    expect(sut.harmonized.activeEnergyBurned, 10.0);
    expect(sut.harmonized.activeEnergyBurnedGoal, 100.0);
    expect(sut.harmonized.activeEnergyBurnedUnit, 'kcal');
    expect(sut.harmonized.appleExerciseTime, 60);
    expect(sut.harmonized.appleExerciseTimeGoal, 100);
    expect(sut.harmonized.appleExerciseTimeUnit, 'min');
    expect(sut.harmonized.appleStandHours, 1);
    expect(sut.harmonized.appleStandHoursGoal, 2);
    expect(sut.harmonized.appleStandHoursUnit, 'h');
  });
}
