import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:health_kit_reporter/exceptions.dart';
import 'package:health_kit_reporter/model/authorization_request_status.dart';
import 'package:health_kit_reporter/model/decorator/extensions.dart';
import 'package:health_kit_reporter/model/payload/audiogram.dart';
import 'package:health_kit_reporter/model/payload/cda_document.dart';
import 'package:health_kit_reporter/model/payload/medication_dose_event.dart';
import 'package:health_kit_reporter/model/payload/scored_assessment.dart';
import 'package:health_kit_reporter/model/payload/state_of_mind.dart';
import 'package:health_kit_reporter/model/predicate.dart';
import 'package:health_kit_reporter/model/query_descriptor.dart';
import 'package:health_kit_reporter/model/type/audiogram_type.dart';
import 'package:health_kit_reporter/model/type/medication_type.dart';
import 'package:health_kit_reporter/model/type/scored_assessment_type.dart';
import 'package:health_kit_reporter/model/type/state_of_mind_type.dart';
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
  roundTrips('audiogram', audiogramJson(), Audiogram.fromJson, (e) => e.map);
  roundTrips(
      'state_of_mind', stateOfMindJson(), StateOfMind.fromJson, (e) => e.map);
  roundTrips('scored_assessment', scoredAssessmentJson(),
      ScoredAssessment.fromJson, (e) => e.map);
  roundTrips(
      'cda_document', cdaDocumentJson(), CDADocument.fromJson, (e) => e.map);
  roundTrips('medication_dose_event', medicationDoseEventJson(),
      MedicationDoseEvent.fromJson, (e) => e.map);
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
    expect(Sample.factory(quantityJson()), isA<Quantity>());
    expect(Sample.factory(visionPrescriptionJson()), isA<VisionPrescription>());
    expect(Sample.factory(heartbeatSeriesJson()), isA<HeartbeatSeries>());
    expect(Sample.factory(workoutRouteJson()), isA<WorkoutRoute>());
    expect(Sample.factory(audiogramJson()), isA<Audiogram>());
    expect(Sample.factory(cdaDocumentJson()), isA<CDADocument>());
    expect(Sample.factory(stateOfMindJson()), isA<StateOfMind>());
    expect(Sample.factory(scoredAssessmentJson()), isA<ScoredAssessment>());
    expect(
        Sample.factory(medicationDoseEventJson()), isA<MedicationDoseEvent>());
  });

  test('sample_factory_reports_an_unknown_identifier', () {
    expect(
        () =>
            Sample.factory(quantityJson(identifier: 'HKFutureTypeIdentifier')),
        throwsA(isA<InvalidValueException>().having(
            (e) => e.cause, 'cause', contains('HKFutureTypeIdentifier'))));
  });

  test('sample_collect_parses_json_strings', () {
    final sut = Sample.collect(
        [jsonEncode(quantityJson()), jsonEncode(workoutRouteJson())]);
    expect(sut.map((e) => e.uuid), [
      '8B1F9C1E-4E0A-4C38-9D57-1B2F4A6C7D10',
      'ROUTE-UUID',
    ]);
  });

  test('read_sample_is_sent_back_with_the_same_seconds', () {
    final sut = Quantity.fromJson(quantityJson());
    final sent = sut.parsed()['quantity'];
    expect(sent['startTimestamp'], 1601065755.8829093);
    expect(sent['endTimestamp'], 1601066077.5886581);
    final workout = Workout.fromJson(workoutJson()).parsed()['workout'];
    expect(workout['startTimestamp'], 1601065755.0);
    expect(workout['workoutEvents'].single['startTimestamp'], 1601066000.0);
  });

  test('samples_built_in_dart_hold_seconds', () {
    final date = DateTime.utc(2020, 9, 25, 20, 29, 15, 500);
    expect(date.secondsSinceEpoch, 1601065755.5);
    expect(dateFromSeconds(date.secondsSinceEpoch).toUtc(), date);
  });

  test('parsed_keys_by_kind', () {
    expect(Category.fromJson(categoryJson()).parsed().keys, ['category']);
    expect(
        Correlation.fromJson(correlationJson()).parsed().keys, ['correlation']);
    expect(Workout.fromJson(workoutJson()).parsed().keys, ['workout']);
    expect(Quantity.fromJson(quantityJson()).parsed().keys, ['quantity']);
    expect(VisionPrescription.fromJson(visionPrescriptionJson()).parsed().keys,
        ['visionPrescription']);
    expect(HeartbeatSeries.fromJson(heartbeatSeriesJson()).parsed(), isEmpty);
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
    expect(AuthorizationRequestStatus.values.map((e) => e.value), [0, 1, 2]);
    expect(AuthorizationRequestStatusFactory.from(2),
        AuthorizationRequestStatus.unnecessary);
    expect(() => AuthorizationRequestStatusFactory.from(9),
        throwsA(isA<InvalidValueException>()));
    final predicate = Predicate(DateTime.utc(2026), DateTime.utc(2026, 2));
    expect(QueryDescriptor('HKQuantityTypeIdentifierStepCount', predicate).map,
        {'identifier': 'HKQuantityTypeIdentifierStepCount', ...predicate.map});
    expect(const QueryDescriptor('HKQuantityTypeIdentifierStepCount').map,
        {'identifier': 'HKQuantityTypeIdentifierStepCount'});
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
    expect(AudiogramType.audiogram.identifier, 'HKDataTypeIdentifierAudiogram');
    expect(StateOfMindType.stateOfMind.identifier, 'HKDataTypeStateOfMind');
    expect(ScoredAssessmentType.values.map((e) => e.identifier), [
      'HKScoredAssessmentTypeIdentifierGAD7',
      'HKScoredAssessmentTypeIdentifierPHQ9'
    ]);
    expect(MedicationType.values.map((e) => e.identifier), [
      'HKMedicationDoseEventTypeIdentifierMedicationDoseEvent',
      'HKDataTypeUserAnnotatedMedicationConcept'
    ]);
  });

  test('type_factories', () {
    for (final type in AudiogramType.values) {
      expect(AudiogramTypeFactory.from(type.identifier), type);
    }
    for (final type in StateOfMindType.values) {
      expect(StateOfMindTypeFactory.from(type.identifier), type);
    }
    for (final type in ScoredAssessmentType.values) {
      expect(ScoredAssessmentTypeFactory.from(type.identifier), type);
    }
    for (final type in MedicationType.values) {
      expect(MedicationTypeFactory.from(type.identifier), type);
    }
    for (final type in DocumentType.values) {
      expect(DocumentTypeFactory.from(type.identifier), type);
    }
    for (final type in SeriesType.values) {
      expect(SeriesTypeFactory.from(type.identifier), type);
    }
    expect(MedicationTypeFactory.tryFrom('unknown'), isNull);
    expect(() => AudiogramTypeFactory.from('unknown'),
        throwsA(isA<InvalidValueException>()));
  });
}
