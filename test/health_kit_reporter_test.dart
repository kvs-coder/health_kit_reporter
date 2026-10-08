import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:health_kit_reporter/health_kit_reporter.dart';
import 'package:health_kit_reporter/model/payload/quantity.dart';
import 'package:health_kit_reporter/model/payload/sample.dart';
import 'package:health_kit_reporter/model/predicate.dart';
import 'package:health_kit_reporter/model/type/quantity_type.dart';

import 'fixtures.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const methodChannel = MethodChannel('health_kit_reporter_method_channel');
  const anchoredChannel =
      EventChannel('health_kit_reporter_event_channel_anchored_object_query');
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
  final calls = <MethodCall>[];

  void reply(Object? Function(MethodCall call) handler) {
    messenger.setMockMethodCallHandler(methodChannel, (call) async {
      calls.add(call);
      return handler(call);
    });
  }

  setUp(calls.clear);
  tearDown(() => messenger.setMockMethodCallHandler(methodChannel, null));

  final steps = Quantity.fromJson(quantityJson(uuid: 'STORED-UUID'));

  test('save_returns_the_uuid_of_the_stored_sample', () async {
    reply((_) => {'status': true, 'uuid': 'NEW-UUID'});
    expect(await HealthKitReporter.save(steps), 'NEW-UUID');
    expect(calls.single.method, 'save');
    expect(calls.single.arguments['quantity']['identifier'],
        'HKQuantityTypeIdentifierStepCount');
  });

  test('save_samples_returns_uuids_in_order', () async {
    reply((_) => {
          'status': true,
          'uuids': ['FIRST', 'SECOND']
        });
    expect(await HealthKitReporter.saveSamples([steps, steps]),
        ['FIRST', 'SECOND']);
    expect(calls.single.arguments['samples'], hasLength(2));
  });

  test('delete_sends_the_stored_uuid', () async {
    reply((_) => true);
    expect(await HealthKitReporter.delete(steps), isTrue);
    expect(calls.single.method, 'delete');
    expect(calls.single.arguments['quantity']['uuid'], 'STORED-UUID');
  });

  test('delete_samples_sends_every_uuid', () async {
    reply((_) => true);
    final other = Quantity.fromJson(quantityJson(uuid: 'OTHER-UUID'));
    expect(await HealthKitReporter.deleteSamples([steps, other]), isTrue);
    final sent = List<Map>.from(calls.single.arguments['samples']);
    expect(
        sent.map((e) => e['quantity']['uuid']), ['STORED-UUID', 'OTHER-UUID']);
  });

  test('is_writable_asks_the_native_side', () async {
    reply((call) =>
        call.arguments['identifier'] !=
        QuantityType.appleExerciseTime.identifier);
    expect(
        await HealthKitReporter.isWritable(QuantityType.stepCount.identifier),
        isTrue);
    expect(
        await HealthKitReporter.isWritable(
            QuantityType.appleExerciseTime.identifier),
        isFalse);
  });

  test('native_errors_surface_as_platform_exceptions', () async {
    messenger.setMockMethodCallHandler(methodChannel, (call) async {
      throw PlatformException(
          code: 'requestAuthorization',
          message:
              "HealthKit doesn't let apps write HKQuantityTypeIdentifierAppleExerciseTime");
    });
    expect(
        HealthKitReporter.requestAuthorization(
            [], [QuantityType.appleExerciseTime.identifier]),
        throwsA(isA<PlatformException>().having(
            (e) => e.message, 'message', contains("doesn't let apps write"))));
  });

  test('workout_effort_relationship_query_returns_the_anchor', () async {
    reply((call) => {
          'relationships': jsonEncode([
            {'workout': workoutJson(), 'activityUUID': null, 'samples': []}
          ]),
          'anchor': 'QU5DSE9S',
        });
    final result = await HealthKitReporter.workoutEffortRelationshipQuery(
        anchor: 'UFJFVklPVVM=');
    expect(calls.single.arguments['anchor'], 'UFJFVklPVVM=');
    expect(result.anchor, 'QU5DSE9S');
    expect(result.relationships.single.workout.uuid,
        'F0F0AAAA-1111-2222-3333-444455556666');
  });

  test('unrelate_workout_effort_sends_the_stored_sample', () async {
    reply((_) => true);
    await HealthKitReporter.unrelateWorkoutEffort(steps, 'WORKOUT-UUID',
        activityUUID: 'ACTIVITY-UUID');
    expect(calls.single.arguments['sample']['uuid'], 'STORED-UUID');
    expect(calls.single.arguments['workoutUUID'], 'WORKOUT-UUID');
    expect(calls.single.arguments['activityUUID'], 'ACTIVITY-UUID');
  });

  test('anchored_object_query_round_trips_the_anchor', () async {
    Object? listenArguments;
    messenger.setMockStreamHandler(anchoredChannel,
        MockStreamHandler.inline(onListen: (arguments, events) {
      listenArguments = arguments;
      events.success({
        'samples': [jsonEncode(quantityJson())],
        'deletedObjects': [
          jsonEncode({'uuid': 'DELETED-UUID', 'metadata': null})
        ],
        'anchor': 'TkVYVA==',
      });
    }));
    final updates = <(List<Sample>, List<String>, String?)>[];
    final subscription = HealthKitReporter.anchoredObjectQuery(
      [QuantityType.stepCount.identifier],
      Predicate(DateTime(2026), DateTime(2027)),
      anchor: 'U0FWRUQ=',
      onUpdate: (samples, deletedObjects, anchor) => updates
          .add((samples, deletedObjects.map((e) => e.uuid).toList(), anchor)),
    );
    await pumpEventQueue();
    expect((listenArguments as Map)['anchor'], 'U0FWRUQ=');
    expect(updates.single.$1.single, isA<Quantity>());
    expect(updates.single.$2, ['DELETED-UUID']);
    expect(updates.single.$3, 'TkVYVA==');
    await subscription.cancel();
    messenger.setMockStreamHandler(anchoredChannel, null);
  });
}
