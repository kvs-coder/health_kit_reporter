import 'package:flutter_test/flutter_test.dart';
import 'package:health_kit_reporter/model/payload/activity_summary.dart';
import 'package:health_kit_reporter/model/payload/electrocardiogram.dart';
import 'package:health_kit_reporter/model/payload/statistics.dart';
import 'package:health_kit_reporter/model/payload/workout.dart';
import 'package:health_kit_reporter/model/payload/workout_activity_type.dart';
import 'package:health_kit_reporter/model/payload/workout_event_type.dart';

import 'fixtures.dart';

void main() {
  group('statistics', () {
    test('older_json_without_new_fields_parses', () {
      final sut = Statistics.fromJson(statisticsJson());
      expect(sut.harmonized.duration, isNull);
      expect(sut.sourceStatistics, isNull);
      expect(sut.sources.single.name, 'iPhone');
    });

    test('duration_and_per_source_values', () {
      final json = statisticsJson(extra: {
        'sourceStatistics': [
          {
            'source': {'name': 'Watch', 'bundleIdentifier': 'com.apple.watch'},
            'harmonized': {'summary': 700, 'unit': 'count'},
          }
        ],
      });
      json['harmonized'] = {...json['harmonized'], 'duration': 3540};
      final sut = Statistics.fromJson(json);
      expect(sut.harmonized.duration, 3540);
      expect(sut.sourceStatistics!.single.source.name, 'Watch');
      expect(sut.sourceStatistics!.single.harmonized.summary, 700);
      expect(Statistics.fromJson(sut.map).sourceStatistics!.length, 1);
    });
  });

  group('activity summary', () {
    final json = {
      'identifier': 'HKActivitySummaryTypeIdentifier',
      'date': '2026-10-08T00:00:00.000+02:00',
      'harmonized': {
        'activeEnergyBurned': 400,
        'activeEnergyBurnedGoal': 500,
        'activeEnergyBurnedUnit': 'kcal',
        'appleExerciseTime': 20,
        'appleExerciseTimeGoal': 30,
        'appleExerciseTimeUnit': 'min',
        'appleStandHours': 8,
        'appleStandHoursGoal': 12,
        'appleStandHoursUnit': 'count',
      },
    };

    test('older_json_without_move_time_parses', () {
      final sut = ActivitySummary.fromJson(json);
      expect(sut.harmonized.appleMoveTime, isNull);
      expect(sut.harmonized.activityMoveMode, isNull);
      expect(sut.date, isNotNull);
    });

    test('move_time_fields', () {
      final sut = ActivitySummary.fromJson({
        ...json,
        'date': null,
        'harmonized': {
          ...json['harmonized'] as Map<String, dynamic>,
          'activityMoveMode': 'appleMoveTime',
          'appleMoveTime': 25,
          'appleMoveTimeGoal': 30,
          'appleMoveTimeUnit': 'min',
          'paused': false,
        },
      });
      expect(sut.date, isNull);
      expect(sut.harmonized.activityMoveMode, 'appleMoveTime');
      expect(sut.harmonized.appleMoveTime, 25);
      expect(sut.harmonized.appleMoveTimeGoal, 30);
      expect(sut.harmonized.appleMoveTimeUnit, 'min');
      expect(sut.harmonized.paused, isFalse);
    });
  });

  group('workout', () {
    test('older_json_without_statistics_and_activities_parses', () {
      final sut = Workout.fromJson(workoutJson());
      expect(sut.statistics, isNull);
      expect(sut.activities, isNull);
    });

    test('statistics_and_activities', () {
      final sut = Workout.fromJson(workoutJson(extra: {
        'statistics': [statisticsJson()],
        'activities': [
          {
            'uuid': 'ACTIVITY-UUID',
            'activityValue': 46,
            'activityDescription': 'Swimming',
            'locationValue': 0,
            'swimmingLocationValue': 1,
            'lapLength': 25,
            'startTimestamp': 1601065755.0,
            'endTimestamp': null,
            'duration': 1200,
            'workoutEvents': [],
            'statistics': [statisticsJson()],
            'metadata': null,
          }
        ],
      }));
      expect(sut.statistics!.single.harmonized.summary, 1200);
      final activity = sut.activities!.single;
      expect(activity.uuid, 'ACTIVITY-UUID');
      expect(activity.activityType, WorkoutActivityType.swimming);
      expect(activity.lapLength, 25);
      expect(activity.endTimestamp, isNull);
      expect(activity.statistics.single.identifier,
          'HKQuantityTypeIdentifierStepCount');
      final roundTrip = Workout.fromJson(sut.map);
      expect(roundTrip.activities!.single.uuid, 'ACTIVITY-UUID');
    });

    test('corrected_descriptions', () {
      final sut = Workout.fromJson(workoutJson());
      expect(sut.harmonized.type, WorkoutActivityType.pickleball);
      expect(sut.harmonized.type.description, 'Pickleball');
      expect(sut.harmonized.metadata!.map, {'HKIndoorWorkout': true});
      expect(WorkoutActivityType.handCycling.description, 'Hand Cycling');
      expect(WorkoutActivityType.preparationAndRecovery.description,
          'Preparation and Recovery');
      expect(sut.workoutEvents.single.harmonized.type,
          WorkoutEventType.pauseOrResumeRequest);
      expect(WorkoutEventType.pauseOrResumeRequest.description,
          'Pause or resume request');
    });
  });

  test('electrocardiogram_classification_and_optional_heart_rate', () {
    final sut = ElectrocardiogramHarmonized.fromJson({
      'averageHeartRate': null,
      'averageHeartRateUnit': 'count/min',
      'samplingFrequency': 512,
      'samplingFrequencyUnit': 'Hz',
      'classification': 'Sinus rhythm',
      'symptomsStatus': 'None',
      'count': 0,
      'voltageMeasurements': [],
      'metadata': null,
    });
    expect(sut.classification, 'Sinus rhythm');
    expect(sut.averageHeartRate, isNull);
  });
}
