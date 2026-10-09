import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:health_kit_reporter/model/payload/category.dart';
import 'package:health_kit_reporter/model/payload/quantity.dart';
import 'package:health_kit_reporter/model/payload/sample.dart';
import 'package:health_kit_reporter/model/payload/workout.dart';
import 'package:health_kit_reporter/model/payload/workout_effort_relationship.dart';

import 'fixtures.dart';

void main() {
  test('uuid_survives_json_round_trip', () {
    final sut = Quantity.fromJson(quantityJson(uuid: 'A-UUID'));
    expect(sut.uuid, 'A-UUID');
    final decoded = Quantity.fromJson(jsonDecode(jsonEncode(sut.map)));
    expect(decoded.uuid, 'A-UUID');
  });

  test('uuid_is_sent_back_for_delete', () {
    final quantity = Quantity.fromJson(quantityJson(uuid: 'Q-UUID'));
    expect(quantity.parsed()['quantity']['uuid'], 'Q-UUID');
    final workout = Workout.fromJson(workoutJson());
    expect(workout.parsed()['workout']['uuid'], workout.uuid);
    final category = Category.fromJson({
      'uuid': 'C-UUID',
      'identifier': 'HKCategoryTypeIdentifierMindfulSession',
      'startTimestamp': 1601065755.0,
      'endTimestamp': 1601066055.0,
      'sourceRevision': sourceRevisionJson(),
      'harmonized': {
        'value': 0,
        'description': 'HKCategoryValue',
        'detail': 'Not Applicable',
        'metadata': null,
      },
    });
    expect(category.parsed()['category']['uuid'], 'C-UUID');
  });

  test('sample_factory_keeps_uuid', () {
    final sample = Sample.factory(quantityJson(uuid: 'F-UUID'));
    expect(sample.uuid, 'F-UUID');
  });

  test('workout_effort_relationship_keeps_uuids_for_unrelate', () {
    final sut = WorkoutEffortRelationship.fromJson({
      'workout': workoutJson(),
      'activityUUID': null,
      'samples': [
        quantityJson(
          uuid: 'EFFORT-UUID',
          identifier: 'HKQuantityTypeIdentifierWorkoutEffortScore',
          value: 7,
          unit: 'appleEffortScore',
        )
      ],
    });
    expect(sut.workout.uuid, 'F0F0AAAA-1111-2222-3333-444455556666');
    expect(sut.activityUUID, isNull);
    expect(sut.samples.single.uuid, 'EFFORT-UUID');
    expect(sut.samples.single.map['uuid'], 'EFFORT-UUID');
  });
}
