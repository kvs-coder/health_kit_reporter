import 'package:flutter_test/flutter_test.dart';
import 'package:health_kit_reporter/model/payload/heartbeat_series.dart';
import 'package:health_kit_reporter/model/payload/quantity.dart';
import 'package:health_kit_reporter/model/payload/source.dart';
import 'package:health_kit_reporter/model/payload/workout.dart';
import 'package:health_kit_reporter/model/payload/workout_route.dart';
import 'package:health_kit_reporter/model/predicate.dart';

import 'fixtures.dart';

void main() {
  test('samples_read_twice_are_equal_and_hash_alike', () {
    final sut = Workout.fromJson(workoutJson());
    final same = Workout.fromJson(workoutJson());
    expect(same, sut);
    expect(same.hashCode, sut.hashCode);
    expect({sut, same}, hasLength(1));
  });

  test('samples_differ_by_uuid_or_contents', () {
    final sut = Quantity.fromJson(quantityJson());
    expect(Quantity.fromJson(quantityJson(uuid: 'OTHER')), isNot(sut));
    expect(Quantity.fromJson(quantityJson(value: 299)), isNot(sut));
    expect(
        Quantity.fromJson(quantityJson(metadata: {'HKWasUserEntered': true})),
        isNot(sut));
  });

  test('payloads_of_other_types_with_the_same_map_differ', () {
    final json = heartbeatSeriesJson();
    expect(HeartbeatSeries.fromJson(json),
        isNot(Quantity.fromJson(quantityJson())));
    expect(const Source('a', 'b'), isNot(Predicate(DateTime(1), DateTime(1))));
  });

  test('non_finite_numbers_compare_equal', () {
    final sut = WorkoutRoute.fromJson(workoutRouteJson());
    final location = sut.harmonized.routes.single.locations.single;
    expect(location.speed, double.infinity);
    expect(WorkoutRoute.fromJson(workoutRouteJson()), sut);
    final nan =
        WorkoutRouteLocation(0, 0, 0, 0, null, null, 0, double.nan, null, 0, 0);
    expect(
        nan,
        WorkoutRouteLocation(
            0, 0, 0, 0, null, null, 0, double.nan, null, 0, 0));
    expect(nan.hashCode, nan.hashCode);
  });

  test('to_string_names_the_type_and_its_fields', () {
    expect(const Source('Health', 'com.apple.health').toString(),
        'Source({name: Health, bundleIdentifier: com.apple.health})');
    expect(Quantity.fromJson(quantityJson()).toString(),
        allOf(startsWith('Quantity({uuid: 8B1F9C1E'), contains('value: 298')));
  });

  test('arguments_compare_by_value', () {
    final start = DateTime.utc(2026);
    expect(Predicate(start, start), Predicate(start, start));
  });
}
