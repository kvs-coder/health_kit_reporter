import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:health_kit_reporter/health_kit_reporter.dart';
import 'package:health_kit_reporter/model/payload/category.dart';
import 'package:health_kit_reporter/model/payload/date_components.dart';
import 'package:health_kit_reporter/model/payload/device.dart';
import 'package:health_kit_reporter/model/payload/preferred_unit.dart';
import 'package:health_kit_reporter/model/payload/quantity.dart';
import 'package:health_kit_reporter/model/payload/statistics.dart';
import 'package:health_kit_reporter/model/payload/workout.dart';
import 'package:health_kit_reporter/model/payload/workout_configuration.dart';
import 'package:health_kit_reporter/model/predicate.dart';
import 'package:health_kit_reporter/model/sample_query_option.dart';
import 'package:health_kit_reporter/model/type/category_type.dart';
import 'package:health_kit_reporter/model/type/clinical_type.dart';
import 'package:health_kit_reporter/model/type/correlation_type.dart';
import 'package:health_kit_reporter/model/type/quantity_type.dart';
import 'package:health_kit_reporter/model/type/vision_prescription_type.dart';
import 'package:health_kit_reporter/model/update_frequency.dart';

import 'fixtures.dart';

/// Every method sends the arguments the native dispatcher reads
/// and parses the reply it sends.
void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  const channel = MethodChannel('health_kit_reporter_method_channel');
  final messenger =
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger;
  final calls = <String, dynamic>{};
  final predicate = Predicate(DateTime.utc(2026), DateTime.utc(2026, 2));
  final steps = Quantity.fromJson(quantityJson());
  final workout = Workout.fromJson(workoutJson());

  String list(Map<String, dynamic> json) => jsonEncode([json]);

  final replies = <String, Object?>{
    'isAvailable': true,
    'supportsHealthRecords': true,
    'requestAuthorization': true,
    'requestPerObjectReadAuthorization': true,
    'preferredUnits': jsonEncode([
      {'identifier': QuantityType.stepCount.identifier, 'unit': 'count'}
    ]),
    'characteristicsQuery': jsonEncode({'biologicalSex': 'Female'}),
    'heartbeatSeriesQuery': list(heartbeatSeriesJson()),
    'workoutRouteQuery': list(workoutRouteJson()),
    'quantityQuery': list(quantityJson()),
    'categoryQuery': list(categoryJson()),
    'workoutQuery': list(workoutJson()),
    'electrocardiogramQuery': list(electrocardiogramJson()),
    'sampleQuery': [
      jsonEncode(quantityJson()),
      jsonEncode(heartbeatSeriesJson()),
    ],
    'statisticsQuery': jsonEncode(statisticsJson()),
    'queryActivitySummary': list(activitySummaryJson()),
    'clinicalRecordQuery': list(clinicalRecordJson()),
    'visionPrescriptionQuery': list(visionPrescriptionJson()),
    'enableBackgroundDelivery': true,
    'disableAllBackgroundDelivery': true,
    'disableBackgroundDelivery': true,
    'sourceQuery': jsonEncode([
      {'name': 'iPhone', 'bundleIdentifier': 'com.apple.health'}
    ]),
    'correlationQuery': list(correlationJson()),
    'startWatchApp': true,
    'isAuthorizedToWrite': true,
    'addCategory': true,
    'addQuantity': true,
    'relateWorkoutEffort': true,
    'deleteObjects': {'status': true, 'count': 3},
  };

  setUp(() {
    calls.clear();
    messenger.setMockMethodCallHandler(channel, (call) async {
      calls[call.method] = call.arguments;
      return replies[call.method];
    });
  });
  tearDown(() => messenger.setMockMethodCallHandler(channel, null));

  test('authorization', () async {
    expect(await HealthKitReporter.isAvailable(), isTrue);
    expect(await HealthKitReporter.supportsHealthRecords(), isTrue);
    expect(
        await HealthKitReporter.requestAuthorization(
            [QuantityType.stepCount.identifier], []),
        isTrue);
    expect(calls['requestAuthorization'], {
      'toRead': [QuantityType.stepCount.identifier],
      'toWrite': [],
    });
    await HealthKitReporter.requestClinicalRecordsAuthorization(
        [ClinicalType.immunizationRecord.identifier]);
    expect(calls['requestAuthorization']['toRead'],
        [ClinicalType.immunizationRecord.identifier]);
    await HealthKitReporter.requestPerObjectReadAuthorization(
        VisionPrescriptionType.visionPrescription.identifier,
        predicate: predicate);
    expect(calls['requestPerObjectReadAuthorization'], {
      'identifier': 'HKVisionPrescriptionTypeIdentifier',
      ...predicate.map,
    });
    expect(
        await HealthKitReporter.isAuthorizedToWrite(
            QuantityType.stepCount.identifier),
        isTrue);
  });

  test('reader', () async {
    final units =
        await HealthKitReporter.preferredUnits([QuantityType.stepCount]);
    expect(calls['preferredUnits'], {
      'identifiers': [QuantityType.stepCount.identifier]
    });
    expect(units.single.unit, 'count');
    expect((await HealthKitReporter.characteristicsQuery()).birthday, isNull);
    expect(
        (await HealthKitReporter.heartbeatSeriesQuery(predicate)).single.uuid,
        'HEARTBEAT-UUID');
    expect(
        (await HealthKitReporter.workoutRouteQuery(predicate))
            .single
            .harmonized
            .routes
            .single
            .locations
            .single
            .speed,
        double.infinity);
    expect(
        (await HealthKitReporter.quantityQuery(
                QuantityType.stepCount, 'count', predicate))
            .single
            .harmonized
            .value,
        298);
    expect(calls['quantityQuery'], {
      'identifier': QuantityType.stepCount.identifier,
      'unit': 'count',
      ...predicate.map,
    });
    expect(
        (await HealthKitReporter.categoryQuery(
                CategoryType.sleepAnalysis, predicate))
            .single
            .harmonized
            .detail,
        'Asleep');
    expect(
        (await HealthKitReporter.workoutQuery(predicate,
                queryOption: SampleQueryOption.strictEndDate))
            .single
            .uuid,
        workout.uuid);
    expect(calls['workoutQuery']['predicateOptions'], 'strictEndDate');
    expect(
        (await HealthKitReporter.electrocardiogramQuery(predicate,
                withVoltageMeasurements: true))
            .single
            .harmonized
            .classification,
        'Sinus rhythm');
    expect(calls['electrocardiogramQuery']['withVoltageMeasurements'], isTrue);
    // heartbeat series aren't returned as generic samples
    expect(
        (await HealthKitReporter.sampleQuery(
                QuantityType.stepCount.identifier, predicate))
            .single,
        isA<Quantity>());
    final statistics = await HealthKitReporter.statisticsQuery(
        QuantityType.stepCount, 'count', predicate,
        separateBySource: true);
    expect(statistics, isA<Statistics>());
    expect(calls['statisticsQuery']['separateBySource'], isTrue);
    expect((await HealthKitReporter.queryActivitySummary(predicate)).length, 1);
    expect(
        (await HealthKitReporter.clinicalRecordQuery(
                ClinicalType.immunizationRecord))
            .single
            .harmonized
            .displayName,
        'Tetanus');
    expect(calls['clinicalRecordQuery'],
        {'identifier': ClinicalType.immunizationRecord.identifier});
    expect(
        (await HealthKitReporter.visionPrescriptionQuery())
            .single
            .harmonized
            .brand,
        'Acuvue');
    expect(
        (await HealthKitReporter.sourceQuery(
                QuantityType.stepCount.identifier, predicate))
            .single
            .name,
        'iPhone');
    final correlations = await HealthKitReporter.correlationQuery(
        CorrelationType.bloodPressure.identifier, predicate, typePredicates: {
      QuantityType.bloodPressureSystolic.identifier: predicate
    });
    expect(correlations.single.harmonized.quantitySamples, hasLength(2));
    expect(calls['correlationQuery']['typePredicates'], {
      QuantityType.bloodPressureSystolic.identifier: predicate.map,
    });
  });

  test('observer', () async {
    expect(
        await HealthKitReporter.enableBackgroundDelivery(
            QuantityType.stepCount.identifier, UpdateFrequency.hourly),
        isTrue);
    expect(calls['enableBackgroundDelivery'],
        {'identifier': QuantityType.stepCount.identifier, 'frequency': 2});
    expect(await HealthKitReporter.disableAllBackgroundDelivery(), isTrue);
    expect(
        await HealthKitReporter.disableBackgroundDelivery(
            QuantityType.stepCount.identifier),
        isTrue);
  });

  test('writer', () async {
    const device = Device('d', null, null, null, null, null, null, null);
    expect(
        await HealthKitReporter.addQuantity([steps], workout, device: device),
        isTrue);
    expect(calls['addQuantity']['workout']['uuid'], workout.uuid);
    expect(calls['addQuantity']['device']['name'], 'd');
    final category = Category.fromJson(categoryJson());
    expect(await HealthKitReporter.addCategory([category], workout), isTrue);
    expect(calls['addCategory']['categories'].single['uuid'], 'C-UUID');
    expect(await HealthKitReporter.relateWorkoutEffort(steps, workout.uuid),
        isTrue);
    expect(calls['relateWorkoutEffort']['workoutUUID'], workout.uuid);
    expect(calls['relateWorkoutEffort'].containsKey('activityUUID'), isFalse);
    expect(
        await HealthKitReporter.deleteObjects(
            QuantityType.stepCount.identifier, predicate),
        {'status': true, 'count': 3});
    expect(
        await HealthKitReporter.startWatchApp(const WorkoutConfiguration(
            52, 2, 0, WorkoutConfigurationHarmonized(25, 'm'))),
        isTrue);
    expect(calls['startWatchApp']['activityValue'], 52);
  });

  group('streams', () {
    void stream(String name, List<Object?> events) {
      messenger.setMockStreamHandler(EventChannel(name),
          MockStreamHandler.inline(onListen: (arguments, sink) {
        calls[name] = arguments;
        for (final event in events) {
          event is PlatformException
              ? sink.error(code: event.code, message: event.message)
              : sink.success(event);
        }
      }));
    }

    test('observer_query_reports_identifiers_and_errors', () async {
      const name = 'health_kit_reporter_event_channel_observer_query';
      stream(name, [
        {'identifier': QuantityType.stepCount.identifier},
        PlatformException(code: 'ObserverQuery', message: 'not determined'),
      ]);
      final identifiers = <String>[];
      final errors = <Object>[];
      final subscription = HealthKitReporter.observerQuery(
          [QuantityType.stepCount.identifier], predicate,
          onUpdate: identifiers.add, onError: errors.add);
      await pumpEventQueue();
      expect(calls[name]['startTimestamp'], predicate.map['startTimestamp']);
      expect(identifiers, [QuantityType.stepCount.identifier]);
      expect((errors.single as PlatformException).message, 'not determined');
      await subscription.cancel();
    });

    test('activity_summary_updates', () async {
      const name = 'health_kit_reporter_event_channel_query_activity_summary';
      stream(name, [list(activitySummaryJson())]);
      final updates = <int>[];
      final subscription = HealthKitReporter.queryActivitySummaryUpdates(
          predicate,
          onUpdate: (summaries) => updates.add(summaries.length));
      await pumpEventQueue();
      expect(updates, [1]);
      await subscription.cancel();
    });

    test('statistics_collection_query', () async {
      const name =
          'health_kit_reporter_event_channel_statistics_collection_query';
      stream(name, [jsonEncode(statisticsJson())]);
      final updates = <Statistics>[];
      final subscription = HealthKitReporter.statisticsCollectionQuery(
        [const PreferredUnit('HKQuantityTypeIdentifierStepCount', 'count')],
        predicate,
        DateTime.utc(2026),
        DateTime.utc(2026),
        DateTime.utc(2026, 2),
        const DateComponents(day: 1),
        separateBySource: true,
        onUpdate: updates.add,
      );
      await pumpEventQueue();
      expect(calls[name]['separateBySource'], isTrue);
      expect(calls[name]['intervalComponents']['day'], 1);
      expect(updates.single.harmonized.summary, 1200);
      await subscription.cancel();
    });
  });
}
