import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:health_kit_reporter/exceptions.dart';
import 'package:health_kit_reporter/health_kit_reporter.dart';
import 'package:health_kit_reporter/model/authorization_request_status.dart';
import 'package:health_kit_reporter/model/payload/audiogram.dart';
import 'package:health_kit_reporter/model/payload/cda_document.dart';
import 'package:health_kit_reporter/model/payload/heartbeat_series.dart';
import 'package:health_kit_reporter/model/payload/metadata.dart';
import 'package:health_kit_reporter/model/payload/quantity_series_value.dart';
import 'package:health_kit_reporter/model/payload/sample.dart';
import 'package:health_kit_reporter/model/payload/scored_assessment.dart';
import 'package:health_kit_reporter/model/payload/state_of_mind.dart';
import 'package:health_kit_reporter/model/payload/workout_route.dart';
import 'package:health_kit_reporter/model/query_descriptor.dart';
import 'package:health_kit_reporter/model/type/scored_assessment_type.dart';
import 'package:health_kit_reporter/model/type/series_type.dart';
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
    'workoutRouteQueryForWorkout': list(workoutRouteJson()),
    'quantityQuery': list(quantityJson()),
    'categoryQuery': list(categoryJson()),
    'workoutQuery': list(workoutJson()),
    'electrocardiogramQuery': list(electrocardiogramJson()),
    'sampleQuery': [
      jsonEncode(quantityJson()),
      jsonEncode(heartbeatSeriesJson()),
    ],
    'sampleQueryWithDescriptors': [
      jsonEncode(quantityJson()),
      jsonEncode(heartbeatSeriesJson()),
    ],
    'quantitySeriesQuery': list(quantitySeriesValueJson()),
    'verifiableClinicalRecordQuery': list(verifiableClinicalRecordJson()),
    'cdaDocumentQuery': list(cdaDocumentJson()),
    'audiogramQuery': list(audiogramJson()),
    'stateOfMindQuery': list(stateOfMindJson()),
    'scoredAssessmentQuery': list(scoredAssessmentJson()),
    'medicationDoseEventQuery': list(medicationDoseEventJson()),
    'userAnnotatedMedicationQuery': list(userAnnotatedMedicationJson()),
    'authorizationRequestStatus': 1,
    'earliestPermittedSampleDate': 1601065755.5,
    'recalibrateEstimates': true,
    'attachments': list(attachmentJson()),
    'attachmentData': Uint8List.fromList([1, 2, 3]),
    'addAttachment': jsonEncode(attachmentJson()),
    'removeAttachment': true,
    'saveWorkout': jsonEncode(workoutJson()),
    'saveQuantitySeries': true,
    'saveHeartbeatSeries': true,
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
    expect(
        await HealthKitReporter.authorizationRequestStatus(
            [QuantityType.stepCount.identifier], []),
        AuthorizationRequestStatus.shouldRequest);
    expect(calls['authorizationRequestStatus'], {
      'toRead': [QuantityType.stepCount.identifier],
      'toWrite': [],
    });
  });

  test('queries_send_limit_and_query_option_only_when_given', () async {
    await HealthKitReporter.quantityQuery(
        QuantityType.stepCount, 'count', predicate,
        limit: 5, queryOption: SampleQueryOption.notStrict);
    expect(calls['quantityQuery'], {
      'identifier': QuantityType.stepCount.identifier,
      'unit': 'count',
      ...predicate.map,
      'limit': 5,
      'predicateOptions': 'notStrict',
    });
    await HealthKitReporter.categoryQuery(CategoryType.sleepAnalysis, predicate,
        queryOption: SampleQueryOption.notStrict);
    expect(calls['categoryQuery']['predicateOptions'], 'notStrict');
    expect(calls['categoryQuery'].containsKey('limit'), isFalse);
    await HealthKitReporter.sampleQuery(
        QuantityType.stepCount.identifier, predicate,
        limit: 1, queryOption: SampleQueryOption.strictStartDate);
    expect(calls['sampleQuery']['limit'], 1);
    expect(calls['sampleQuery']['predicateOptions'], 'strictStartDate');
    await HealthKitReporter.workoutQuery(predicate, limit: 2);
    await HealthKitReporter.electrocardiogramQuery(predicate, limit: 3);
    await HealthKitReporter.heartbeatSeriesQuery(predicate, limit: 4);
    await HealthKitReporter.workoutRouteQuery(predicate, limit: 5);
    await HealthKitReporter.sampleQueryWithDescriptors(
        [QueryDescriptor(QuantityType.stepCount.identifier)],
        limit: 6);
    await HealthKitReporter.clinicalRecordQuery(ClinicalType.immunizationRecord,
        limit: 7);
    await HealthKitReporter.visionPrescriptionQuery(limit: 8);
    await HealthKitReporter.cdaDocumentQuery(limit: 9);
    await HealthKitReporter.audiogramQuery(limit: 10);
    await HealthKitReporter.stateOfMindQuery(limit: 11);
    await HealthKitReporter.scoredAssessmentQuery(ScoredAssessmentType.phq9,
        limit: 12);
    await HealthKitReporter.medicationDoseEventQuery(limit: 13);
    await HealthKitReporter.userAnnotatedMedicationQuery(limit: 14);
    expect(
        [
          'workoutQuery',
          'electrocardiogramQuery',
          'heartbeatSeriesQuery',
          'workoutRouteQuery',
          'sampleQueryWithDescriptors',
          'clinicalRecordQuery',
          'visionPrescriptionQuery',
          'cdaDocumentQuery',
          'audiogramQuery',
          'stateOfMindQuery',
          'scoredAssessmentQuery',
          'medicationDoseEventQuery',
          'userAnnotatedMedicationQuery',
        ].map((method) => calls[method]['limit']),
        [2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12, 13, 14]);
  });

  test('workout_route_query_for_workout_sends_the_workout_uuid', () async {
    final routes = await HealthKitReporter.workoutRouteQueryForWorkout(
        workout.uuid,
        limit: 2);
    expect(routes.single.uuid, 'ROUTE-UUID');
    expect(calls['workoutRouteQueryForWorkout'],
        {'workoutUUID': workout.uuid, 'limit': 2});
    await HealthKitReporter.workoutRouteQueryForWorkout(workout.uuid);
    expect(calls['workoutRouteQueryForWorkout'], {'workoutUUID': workout.uuid});
  });

  test('manager', () async {
    expect((await HealthKitReporter.earliestPermittedSampleDate()).toUtc(),
        DateTime.utc(2020, 9, 25, 20, 29, 15, 500));
    final date = DateTime.utc(2026);
    expect(
        await HealthKitReporter.recalibrateEstimates(
            QuantityType.vo2Max.identifier, date),
        isTrue);
    expect(calls['recalibrateEstimates'], {
      'identifier': QuantityType.vo2Max.identifier,
      'timestamp': date.millisecondsSinceEpoch,
    });
  });

  test('attachments', () async {
    const identifier = 'HKVisionPrescriptionTypeIdentifier';
    expect(
        (await HealthKitReporter.attachments(identifier, 'VISION-UUID'))
            .single
            .name,
        'scan.jpg');
    expect(calls['attachments'],
        {'identifier': identifier, 'uuid': 'VISION-UUID'});
    expect(
        await HealthKitReporter.attachmentData(
            identifier, 'VISION-UUID', 'ATTACHMENT-UUID'),
        [1, 2, 3]);
    expect(calls['attachmentData']['attachmentIdentifier'], 'ATTACHMENT-UUID');
    final added = await HealthKitReporter.addAttachment(
        identifier, 'VISION-UUID', 'scan.jpg', 'public.jpeg', '/tmp/scan.jpg',
        metadata: const Metadata({'source': MetadataString('camera')}));
    expect(added.identifier, 'ATTACHMENT-UUID');
    expect(calls['addAttachment'], {
      'identifier': identifier,
      'uuid': 'VISION-UUID',
      'name': 'scan.jpg',
      'contentType': 'public.jpeg',
      'filePath': '/tmp/scan.jpg',
      'metadata': {'source': 'camera'},
    });
    expect(
        await HealthKitReporter.removeAttachment(
            identifier, 'VISION-UUID', 'ATTACHMENT-UUID'),
        isTrue);
    expect(calls['removeAttachment']['uuid'], 'VISION-UUID');
  });

  test('records_wellbeing_and_medications', () async {
    final records = await HealthKitReporter.verifiableClinicalRecordQuery(
        ['https://smarthealth.cards#immunization'],
        sourceTypes: ['https://smarthealth.cards'], predicate: predicate);
    expect(
        records.single.harmonized.issuerIdentifier, 'https://issuer.example');
    expect(calls['verifiableClinicalRecordQuery'], {
      'recordTypes': ['https://smarthealth.cards#immunization'],
      'sourceTypes': ['https://smarthealth.cards'],
      ...predicate.map,
    });
    expect(
        (await HealthKitReporter.cdaDocumentQuery(includeDocumentData: false))
            .single
            .harmonized
            .title,
        'Summary');
    expect(calls['cdaDocumentQuery'], {'includeDocumentData': false});
    expect(
        (await HealthKitReporter.audiogramQuery(predicate: predicate))
            .single
            .harmonized
            .sensitivityPoints,
        hasLength(2));
    expect(calls['audiogramQuery'], predicate.map);
    expect(
        (await HealthKitReporter.stateOfMindQuery()).single.harmonized.kind, 1);
    expect(calls['stateOfMindQuery'], <String, dynamic>{});
    expect(
        (await HealthKitReporter.scoredAssessmentQuery(
                ScoredAssessmentType.gad7))
            .single
            .harmonized
            .score,
        9);
    expect(calls['scoredAssessmentQuery'],
        {'identifier': 'HKScoredAssessmentTypeIdentifierGAD7'});
    expect(
        (await HealthKitReporter.medicationDoseEventQuery(
                medicationConceptIdentifier: 'Q09OQ0VQVA==',
                predicate: predicate))
            .single
            .harmonized
            .logStatus,
        4);
    expect(calls['medicationDoseEventQuery'], {
      'medicationConceptIdentifier': 'Q09OQ0VQVA==',
      ...predicate.map,
    });
    expect(
        (await HealthKitReporter.userAnnotatedMedicationQuery())
            .single
            .medication
            .displayText,
        'Ibuprofen 200 mg');
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
    // every sample kind, also heartbeat series, is returned
    expect(
        await HealthKitReporter.sampleQuery(
            QuantityType.stepCount.identifier, predicate),
        [isA<Quantity>(), isA<HeartbeatSeries>()]);
    expect(
        await HealthKitReporter.sampleQueryWithDescriptors([
          QueryDescriptor(QuantityType.stepCount.identifier, predicate),
          QueryDescriptor(SeriesType.heartbeatSeries.identifier),
        ]),
        hasLength(2));
    expect(calls['sampleQueryWithDescriptors'], {
      'descriptors': [
        {'identifier': QuantityType.stepCount.identifier, ...predicate.map},
        {'identifier': SeriesType.heartbeatSeries.identifier},
      ]
    });
    final values = await HealthKitReporter.quantitySeriesQuery(
        QuantityType.stepCount, 'count',
        predicate: predicate);
    expect(values.single.sampleUUID, 'SERIES-UUID');
    expect(calls['quantitySeriesQuery'], {
      'identifier': QuantityType.stepCount.identifier,
      'unit': 'count',
      ...predicate.map,
    });
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
    final route = WorkoutRoute.fromJson(workoutRouteJson())
        .harmonized
        .routes
        .single
        .locations;
    final saved = await HealthKitReporter.saveWorkout(workout,
        samples: [steps], route: route);
    expect(saved.uuid, workout.uuid);
    expect(calls['saveWorkout']['workout']['startTimestamp'], 1601065755.0);
    expect(calls['saveWorkout']['samples'].single['uuid'], steps.uuid);
    expect(calls['saveWorkout']['route'].single['latitude'], 52.5);
    const values = [QuantitySeriesValue(12, 'count', 1601065755, 1601065815)];
    expect(
        await HealthKitReporter.saveQuantitySeries(
            QuantityType.stepCount, values,
            device: device,
            metadata: const Metadata({'HKWasUserEntered': MetadataBool(true)})),
        isTrue);
    expect(calls['saveQuantitySeries'], {
      'identifier': QuantityType.stepCount.identifier,
      'values': [values.single.map],
      'device': device.map,
      'metadata': {'HKWasUserEntered': true},
    });
    final series = HeartbeatSeries.fromJson(heartbeatSeriesJson());
    expect(await HealthKitReporter.saveHeartbeatSeries(series), isTrue);
    expect(calls['saveHeartbeatSeries'], {'series': series.map});
  });

  test('new_sample_kinds_are_saved_by_their_kind', () async {
    for (final (sample, kind) in <(Sample, String)>[
      (Audiogram.fromJson(audiogramJson()), 'audiogram'),
      (StateOfMind.fromJson(stateOfMindJson()), 'stateOfMind'),
      (ScoredAssessment.fromJson(scoredAssessmentJson()), 'scoredAssessment'),
      (CDADocument.fromJson(cdaDocumentJson()), 'cdaDocument'),
    ]) {
      messenger.setMockMethodCallHandler(channel, (call) async {
        calls[call.method] = call.arguments;
        return {'status': true, 'uuid': 'NEW'};
      });
      expect(await HealthKitReporter.save(sample), 'NEW');
      expect(calls['save'], {kind: sample.map});
    }
  });

  group('streams', () {
    /// The native side replies with a channel of the subscription's own,
    /// which sends [events] once Dart listens
    void stream(String method, String name, List<Object?> events,
        {List<String>? cancelled}) {
      replies[method] = name;
      messenger.setMockStreamHandler(
          EventChannel(name),
          MockStreamHandler.inline(
              onListen: (arguments, sink) {
                for (final event in events) {
                  event is PlatformException
                      ? sink.error(code: event.code, message: event.message)
                      : sink.success(event);
                }
              },
              onCancel: (_) => cancelled?.add(name)));
    }

    test('observer_query_reports_identifiers_and_errors', () async {
      stream('observerQuery', 'observer', [
        {'identifier': QuantityType.stepCount.identifier},
        PlatformException(code: 'observerQuery', message: 'not determined'),
      ]);
      final identifiers = <String>[];
      final errors = <Object>[];
      final subscription = HealthKitReporter.observerQuery(
          [QuantityType.stepCount.identifier], predicate,
          onUpdate: identifiers.add, onError: errors.add);
      await pumpEventQueue();
      expect(calls['observerQuery']['startTimestamp'],
          predicate.map['startTimestamp']);
      expect(identifiers, [QuantityType.stepCount.identifier]);
      expect(
          errors.single,
          isA<PlatformException>()
              .having((e) => e.code, 'code', 'observerQuery'));
      await subscription.cancel();
    });

    test('subscriptions_of_one_method_run_independently', () async {
      final cancelled = <String>[];
      final identifiers = <String>[];
      var opened = 0;
      for (final name in ['first', 'second']) {
        stream(
            'observerQuery',
            name,
            [
              {'identifier': name}
            ],
            cancelled: cancelled);
      }
      messenger.setMockMethodCallHandler(
          channel, (call) async => ['first', 'second'][opened++]);
      final first = HealthKitReporter.observerQuery(['A'], null,
          onUpdate: identifiers.add);
      await pumpEventQueue();
      final second = HealthKitReporter.observerQuery(['B'], null,
          onUpdate: identifiers.add);
      await pumpEventQueue();
      await first.cancel();
      await pumpEventQueue();
      expect(cancelled, ['first']);
      expect(identifiers, ['first', 'second']);
      await second.cancel();
      expect(cancelled, ['first', 'second']);
    });

    test('planning_failures_reach_on_error_with_the_method_code', () async {
      messenger.setMockMethodCallHandler(channel, (call) async {
        throw PlatformException(
            code: call.method, message: 'HealthKit data is not available');
      });
      final errors = <Object>[];
      final subscription = HealthKitReporter.queryActivitySummaryUpdates(
          predicate,
          onUpdate: (_) {},
          onError: errors.add);
      await pumpEventQueue();
      expect(
          errors.single,
          isA<PlatformException>()
              .having((e) => e.code, 'code', 'queryActivitySummaryUpdates')
              .having((e) => e.message, 'message',
                  'HealthKit data is not available'));
      await subscription.cancel();
    });

    test('cancelling_while_planning_releases_the_native_queries', () async {
      final cancelled = <String>[];
      stream('observerQuery', 'late', [], cancelled: cancelled);
      final subscription =
          HealthKitReporter.observerQuery(['A'], null, onUpdate: (_) {});
      await subscription.cancel();
      await pumpEventQueue();
      expect(cancelled, ['late']);
    });

    test('anchored_object_query_reports_unknown_samples', () async {
      stream('anchoredObjectQuery', 'anchored', [
        {
          'samples': [
            jsonEncode(quantityJson(identifier: 'HKFutureTypeIdentifier'))
          ],
          'deletedObjects': [],
          'anchor': 'TkVYVA==',
        }
      ]);
      final updates = <String?>[];
      final errors = <Object>[];
      final subscription = HealthKitReporter.anchoredObjectQuery(['A'], null,
          onUpdate: (_, __, anchor) => updates.add(anchor),
          onError: errors.add);
      await pumpEventQueue();
      expect(updates, isEmpty);
      expect(errors.single, isA<InvalidValueException>());
      await subscription.cancel();
    });

    test('activity_summary_updates', () async {
      stream('queryActivitySummaryUpdates', 'summaries',
          [list(activitySummaryJson())]);
      final updates = <int>[];
      final subscription = HealthKitReporter.queryActivitySummaryUpdates(
          predicate,
          onUpdate: (summaries) => updates.add(summaries.length));
      await pumpEventQueue();
      expect(calls['queryActivitySummaryUpdates'], predicate.map);
      expect(updates, [1]);
      await subscription.cancel();
    });

    test('statistics_collection_query', () async {
      stream('statisticsCollectionQuery', 'statistics',
          [jsonEncode(statisticsJson())]);
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
      expect(calls['statisticsCollectionQuery']['separateBySource'], isTrue);
      expect(
          calls['statisticsCollectionQuery']['intervalComponents']['day'], 1);
      expect(updates.single.harmonized.summary, 1200);
      await subscription.cancel();
    });
  });
}
