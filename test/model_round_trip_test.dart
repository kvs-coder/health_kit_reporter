import 'package:flutter_test/flutter_test.dart';
import 'package:health_kit_reporter/model/payload/activity_summary.dart';
import 'package:health_kit_reporter/model/payload/category.dart';
import 'package:health_kit_reporter/model/payload/characteristic/characteristic.dart';
import 'package:health_kit_reporter/model/payload/clinical_record.dart';
import 'package:health_kit_reporter/model/payload/correlation.dart';
import 'package:health_kit_reporter/model/payload/date_components.dart';
import 'package:health_kit_reporter/model/payload/deleted_object.dart';
import 'package:health_kit_reporter/model/payload/electrocardiogram.dart';
import 'package:health_kit_reporter/model/payload/heartbeat_series.dart';
import 'package:health_kit_reporter/model/payload/preferred_unit.dart';
import 'package:health_kit_reporter/model/payload/quantity.dart';
import 'package:health_kit_reporter/model/payload/sample.dart';
import 'package:health_kit_reporter/model/payload/statistics.dart';
import 'package:health_kit_reporter/model/payload/vision_prescription.dart';
import 'package:health_kit_reporter/model/payload/workout.dart';
import 'package:health_kit_reporter/model/payload/workout_configuration.dart';
import 'package:health_kit_reporter/model/payload/workout_effort_relationship.dart';
import 'package:health_kit_reporter/model/payload/workout_route.dart';
import 'package:health_kit_reporter/model/sample_query_option.dart';
import 'package:health_kit_reporter/model/type/activity_summary_type.dart';
import 'package:health_kit_reporter/model/type/characteristic_type.dart';
import 'package:health_kit_reporter/model/type/document_type.dart';
import 'package:health_kit_reporter/model/type/series_type.dart';
import 'package:health_kit_reporter/model/update_frequency.dart';

import 'fixtures.dart';

/// Every payload's map parses back into the same payload, as the native side
/// reads it when the payload is sent back.
void main() {
  void roundTrips<T>(
      String name,
      Map<String, dynamic> json,
      T Function(Map<String, dynamic>) fromJson,
      Map<String, dynamic> Function(T) map) {
    test('${name}_map_round_trip', () {
      final first = map(fromJson(json));
      expect(map(fromJson(first)), first);
    });
  }

  roundTrips('quantity', quantityJson(metadata: {'HKWasUserEntered': true}),
      Quantity.fromJson, (e) => e.map);
  roundTrips('category', categoryJson(), Category.fromJson, (e) => e.map);
  roundTrips(
      'correlation', correlationJson(), Correlation.fromJson, (e) => e.map);
  roundTrips('electrocardiogram', electrocardiogramJson(),
      Electrocardiogram.fromJson, (e) => e.map);
  roundTrips('heartbeat_series', heartbeatSeriesJson(),
      HeartbeatSeries.fromJson, (e) => e.map);
  roundTrips(
      'workout_route', workoutRouteJson(), WorkoutRoute.fromJson, (e) => e.map);
  roundTrips('clinical_record', clinicalRecordJson(), ClinicalRecord.fromJson,
      (e) => e.map);
  roundTrips('activity_summary', activitySummaryJson(),
      ActivitySummary.fromJson, (e) => e.map);
  roundTrips('vision_prescription', visionPrescriptionJson(),
      VisionPrescription.fromJson, (e) => e.map);
  roundTrips('workout', workoutJson(), Workout.fromJson, (e) => e.map);
  roundTrips('statistics', statisticsJson(), Statistics.fromJson, (e) => e.map);
  roundTrips(
      'workout_effort_relationship',
      {
        'workout': workoutJson(),
        'activityUUID': 'A',
        'samples': [quantityJson()]
      },
      WorkoutEffortRelationship.fromJson,
      (e) => e.map);
  roundTrips(
      'deleted_object',
      {
        'uuid': 'D',
        'metadata': {'HKSyncVersion': 1}
      },
      DeletedObject.fromJson,
      (e) => e.map);
  roundTrips(
      'preferred_unit',
      {'identifier': 'HKQuantityTypeIdentifierStepCount', 'unit': 'count'},
      PreferredUnit.fromJson,
      (e) => e.map);

  test('sample_factory_covers_every_sample_kind', () {
    expect(Sample.factory(categoryJson()), isA<Category>());
    expect(Sample.factory(correlationJson()), isA<Correlation>());
    expect(Sample.factory(electrocardiogramJson()), isA<Electrocardiogram>());
    expect(Sample.factory(clinicalRecordJson()), isA<ClinicalRecord>());
    expect(Sample.factory(workoutJson()), isA<Workout>());
    expect(Sample.factory(heartbeatSeriesJson()), isNull);
  });

  test('parsed_keys_by_kind', () {
    expect(Category.fromJson(categoryJson()).parsed().keys, ['category']);
    expect(
        Correlation.fromJson(correlationJson()).parsed().keys, ['correlation']);
    expect(Workout.fromJson(workoutJson()).parsed().keys, ['workout']);
  });

  test('characteristic_round_trip', () {
    final json = {
      'biologicalSex': 'Female',
      'birthday': '1990-01-01T00:00:00.000+01:00',
      'bloodType': 'O-',
      'fitzpatrickSkinType': 'IV',
      'wheelchairUse': 'No',
      'activityMoveMode': 'Apple Move Time',
    };
    final sut = Characteristic.fromJson(json);
    expect(Characteristic.fromJson(sut.map).map, sut.map);
  });

  test('arguments_sent_to_the_native_side', () {
    expect(const DateComponents(day: 1, hour: 2).map, containsPair('day', 1));
    expect(
        const WorkoutConfiguration(
                52, 2, 0, WorkoutConfigurationHarmonized(25, 'm'))
            .map,
        {
          'activityValue': 52,
          'locationValue': 2,
          'swimmingValue': 0,
          'harmonized': {'value': 25, 'unit': 'm'},
        });
    expect(SampleQueryOption.values.map((e) => e.value),
        ['strictStartDate', 'strictEndDate', 'notStrict']);
    expect(UpdateFrequency.values.map((e) => e.value), [1, 2, 3, 4]);
  });

  test('type_identifiers', () {
    expect(ActivitySummaryType.activitySummaryType.identifier,
        'HKActivitySummaryTypeIdentifier');
    expect(
        DocumentType.values.single.identifier, 'HKDocumentTypeIdentifierCDA');
    expect(SeriesType.values.map((e) => e.identifier), [
      'HKDataTypeIdentifierHeartbeatSeries',
      'HKWorkoutRouteTypeIdentifier'
    ]);
    expect(CharacteristicType.values.map((e) => e.identifier),
        everyElement(startsWith('HKCharacteristicTypeIdentifier')));
  });
}
