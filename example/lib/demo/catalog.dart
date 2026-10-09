import 'dart:convert';

import 'package:health_kit_reporter/health_kit_reporter.dart';
import 'package:health_kit_reporter/model/payload/date_components.dart';
import 'package:health_kit_reporter/model/payload/preferred_unit.dart';
import 'package:health_kit_reporter/model/payload/sample.dart';
import 'package:health_kit_reporter/model/payload/workout.dart';
import 'package:health_kit_reporter/model/payload/workout_activity_type.dart';
import 'package:health_kit_reporter/model/payload/workout_configuration.dart';
import 'package:health_kit_reporter/model/predicate.dart';
import 'package:health_kit_reporter/model/sample_query_option.dart';
import 'package:health_kit_reporter/model/type/category_type.dart';
import 'package:health_kit_reporter/model/type/clinical_type.dart';
import 'package:health_kit_reporter/model/type/correlation_type.dart';
import 'package:health_kit_reporter/model/type/quantity_type.dart';
import 'package:health_kit_reporter/model/type/vision_prescription_type.dart';
import 'package:health_kit_reporter/model/update_frequency.dart';

import 'demo_row.dart';
import 'health_types.dart';
import 'samples.dart';
import 'seeding.dart';

/// Every public method of the plugin, grouped by area.
/// Tap a row to run it; its result, live updates or error appear in the row.
class Catalog {
  Catalog();

  /// Samples written by the demo rows (not by seeding)
  static const _demo = DemoSamples('hkr-demo-');

  /// Anchors the anchored queries handed back. A real app persists these strings,
  /// e.g. in shared preferences, to receive only the changes on the next launch.
  final _anchors = <String, String?>{};

  static const _steps = QuantityType.stepCount;

  static DateTime get _now => DateTime.now();

  static DateTime get _startOfToday =>
      DateTime(_now.year, _now.month, _now.day);

  static Predicate get _today => Predicate(_startOfToday, _now);

  static Predicate get _lastWeek =>
      Predicate(_now.subtract(const Duration(days: 7)), _now);

  late final List<DemoSection> sections = [
    DemoSection('Authorization', [
      DemoRow('isAvailable', 'Whether Apple Health is available on the device',
          run: () async => '${await HealthKitReporter.isAvailable()}'),
      DemoRow('requestAuthorization',
          'Read every sample type, characteristic and activity summary; write every type whose isWritable is true',
          run: () async {
        final types = await HealthTypes.load();
        final shown = await HealthKitReporter.requestAuthorization(
            types.read, types.write);
        return [
          'Authorization sheet handled: $shown',
          '${types.read.length} types to read, ${types.write.length} to write',
          if (types.unavailable.isNotEmpty)
            '${types.unavailable.length} types unknown to this iOS version',
        ].join('\n');
      }),
      DemoRow('isWritable',
          'Step count can be requested for writing, Apple exercise time cannot',
          run: () async {
        final steps = await HealthKitReporter.isWritable(_steps.identifier);
        final exercise = await HealthKitReporter.isWritable(
            QuantityType.appleExerciseTime.identifier);
        return 'stepCount: $steps\nappleExerciseTime: $exercise';
      }),
      DemoRow('requestAuthorization with a read-only type',
          'HealthKit would crash; the plugin reports invalidType instead',
          run: () async => '${await HealthKitReporter.requestAuthorization([], [
                    QuantityType.appleExerciseTime.identifier
                  ])}'),
      DemoRow('isAuthorizedToWrite', 'Write status of step count',
          run: () async =>
              '${await HealthKitReporter.isAuthorizedToWrite(_steps.identifier)}'),
      DemoRow('supportsHealthRecords',
          'Whether the device can read clinical health records',
          run: () async =>
              '${await HealthKitReporter.supportsHealthRecords()}'),
      DemoRow('requestClinicalRecordsAuthorization',
          'A separate call: it starts Health\'s records flow, which needs an Apple Account',
          run: () async =>
              '${await HealthKitReporter.requestClinicalRecordsAuthorization(ClinicalType.values.map((e) => e.identifier).toList())}'),
      DemoRow('requestPerObjectReadAuthorization',
          'Pick the vision prescriptions the app may read (iOS 16)',
          run: () async =>
              '${await HealthKitReporter.requestPerObjectReadAuthorization(VisionPrescriptionType.visionPrescription.identifier)}'),
    ]),
    DemoSection(
      'Steps: save, read, delete',
      [
        DemoRow('Save, read and delete a step sample',
            'Authorizes steps, saves 42 steps, reads them back by the uuid save reported, then deletes the stored sample by that uuid',
            run: _stepsRoundTrip),
      ],
      footer:
          'save returns the uuid HealthKit gave the stored sample; delete looks the stored sample up by it.',
    ),
    DemoSection('Reader', [
      DemoRow('preferredUnits',
          'Units of the current locale for steps, distance and heart rate',
          run: () async {
        final units = await HealthKitReporter.preferredUnits([
          _steps,
          QuantityType.distanceWalkingRunning,
          QuantityType.heartRate,
        ]);
        return units
            .map((e) => '${_short(e.identifier)}: ${e.unit}')
            .join('\n');
      }),
      DemoRow('characteristicsQuery',
          'Set them in the Health app profile; empty otherwise',
          run: () async =>
              _json((await HealthKitReporter.characteristicsQuery()).map)),
      DemoRow('quantityQuery', 'Steps of the last 7 days', run: () async {
        final quantities =
            await HealthKitReporter.quantityQuery(_steps, 'count', _lastWeek);
        final total =
            quantities.fold<num>(0, (sum, e) => sum + e.harmonized.value);
        return '${quantities.length} samples, $total steps${_first(quantities)}';
      }),
      DemoRow('categoryQuery', 'Sleep analysis of the last 7 days',
          run: () async => _describe(await HealthKitReporter.categoryQuery(
              CategoryType.sleepAnalysis, _lastWeek))),
      DemoRow('sampleQuery', 'Heart rate samples of the last 7 days',
          run: () async => _describe(await HealthKitReporter.sampleQuery(
              QuantityType.heartRate.identifier, _lastWeek))),
      DemoRow('workoutQuery',
          'Workouts that started in the last 7 days, with statistics and activities',
          run: () async {
        final workouts = await HealthKitReporter.workoutQuery(_lastWeek,
            queryOption: SampleQueryOption.strictStartDate);
        return [
          '${workouts.length} workouts',
          for (final workout in workouts.take(3))
            '${workout.harmonized.type.description}: ${workout.duration.round()} s, '
                '${workout.statistics?.length ?? 0} statistics, '
                '${workout.activities?.length ?? 0} activities',
        ].join('\n');
      }),
      DemoRow(
          'statisticsQuery', 'Steps of the last 7 days, separated by source',
          run: () async {
        final statistics = await HealthKitReporter.statisticsQuery(
            _steps, 'count', _lastWeek,
            separateBySource: true);
        return [
          'sum: ${statistics.harmonized.summary}, duration: ${statistics.harmonized.duration}',
          for (final source in statistics.sourceStatistics ?? [])
            '${source.source.name}: ${source.harmonized.summary}',
        ].join('\n');
      }),
      DemoRow('correlationQuery', 'Blood pressure of the last 7 days',
          run: () async => _describe(await HealthKitReporter.correlationQuery(
              CorrelationType.bloodPressure.identifier, _lastWeek))),
      DemoRow('sourceQuery', 'Apps and devices that wrote steps',
          run: () async {
        final sources =
            await HealthKitReporter.sourceQuery(_steps.identifier, _lastWeek);
        return sources.map((e) => e.name).join('\n');
      }),
      DemoRow('queryActivitySummary', 'Activity rings of the last 7 days',
          run: () async {
        final summaries =
            await HealthKitReporter.queryActivitySummary(_lastWeek);
        return [
          '${summaries.length} summaries',
          for (final summary in summaries.take(3))
            '${summary.date?.toIso8601String().substring(0, 10)}: '
                '${summary.harmonized.activeEnergyBurned} ${summary.harmonized.activeEnergyBurnedUnit}'
                '${summary.harmonized.appleMoveTime != null ? ', move ${summary.harmonized.appleMoveTime} ${summary.harmonized.appleMoveTimeUnit}' : ''}',
        ].join('\n');
      }),
      DemoRow('electrocardiogramQuery',
          'Recorded with Apple Watch; empty in the simulator',
          run: () async => _describe(
              await HealthKitReporter.electrocardiogramQuery(_lastWeek))),
      DemoRow('heartbeatSeriesQuery', 'Beat-to-beat series of the last 7 days',
          run: () async => _describe(
              await HealthKitReporter.heartbeatSeriesQuery(_lastWeek))),
      DemoRow('workoutRouteQuery', 'Routes of the last 7 days',
          run: () async =>
              _describe(await HealthKitReporter.workoutRouteQuery(_lastWeek))),
    ]),
    DemoSection('Health records', [
      DemoRow('clinicalRecordQuery',
          'Immunizations; add sample records under Health › Browse › Health Records',
          run: () async {
        final records = await HealthKitReporter.clinicalRecordQuery(
            ClinicalType.immunizationRecord);
        return [
          '${records.length} records',
          ...records.take(3).map((e) => e.harmonized.displayName),
        ].join('\n');
      }),
      DemoRow('visionPrescriptionQuery',
          'Prescriptions the user picked; dates are seconds since 1970',
          run: () async {
        final prescriptions = await HealthKitReporter.visionPrescriptionQuery();
        return [
          '${prescriptions.length} prescriptions',
          for (final prescription in prescriptions.take(3))
            '${prescription.harmonized.prescriptionType.detail} issued '
                '${prescription.harmonized.dateIssued.toIso8601String().substring(0, 10)}, '
                'right sphere ${prescription.harmonized.rightEye?.sphere}',
        ].join('\n');
      }),
    ]),
    DemoSection('Writer', [
      DemoRow('save', 'Saves 120 steps and returns the stored sample\'s uuid',
          run: () async {
        final uuid = await HealthKitReporter.save(_demo.quantity(
            _steps.identifier,
            120,
            'count',
            _now.subtract(const Duration(minutes: 5)),
            end: _now));
        return 'uuid: $uuid';
      }),
      DemoRow('saveSamples / deleteSamples',
          'Saves three samples at once, then deletes exactly those by their uuids',
          run: () async {
        final start = _now.subtract(const Duration(minutes: 30));
        final samples = [
          for (var i = 0; i < 3; i++)
            _demo.quantity(_steps.identifier, 10 + i, 'count',
                start.add(Duration(minutes: i * 5)),
                end: start.add(Duration(minutes: i * 5 + 1))),
        ];
        final uuids = await HealthKitReporter.saveSamples(samples);
        final stored = (await HealthKitReporter.quantityQuery(
                _steps, 'count', Predicate(start, _now)))
            .where((e) => uuids.contains(e.uuid))
            .toList();
        final deleted = await HealthKitReporter.deleteSamples(stored);
        return 'saved uuids:\n${uuids.join('\n')}\nfound ${stored.length}, deleted: $deleted';
      }),
      DemoRow('save category', 'A 10 minute mindful session', run: () async {
        final uuid = await HealthKitReporter.save(_demo.category(
            CategoryType.mindfulSession.identifier,
            0,
            _now.subtract(const Duration(minutes: 10)),
            _now));
        return 'uuid: $uuid';
      }),
      DemoRow('save workout + addQuantity / addCategory',
          'Saves a walk, reads it back by its uuid and adds samples to the stored workout',
          run: () async {
        final workout = await _saveWalk();
        final added = await HealthKitReporter.addQuantity([
          _demo.quantity(QuantityType.activeEnergyBurned.identifier, 25, 'kcal',
              _now.subtract(const Duration(minutes: 20)),
              end: _now.subtract(const Duration(minutes: 10))),
        ], workout);
        final addedCategory = await HealthKitReporter.addCategory([
          _demo.category(CategoryType.mindfulSession.identifier, 0,
              _now.subtract(const Duration(minutes: 5)), _now),
        ], workout);
        return 'workout ${workout.uuid}\naddQuantity: $added, addCategory: $addedCategory';
      }),
      DemoRow('relateWorkoutEffort / unrelateWorkoutEffort',
          'iOS 18: relates an effort score to a stored walk, reads the relationship, unrelates the stored effort sample by its uuid',
          run: () async {
        final workout = await _saveWalk();
        final effort = _demo.quantity(
            QuantityType.workoutEffortScore.identifier,
            6,
            'appleEffortScore',
            _now.subtract(const Duration(minutes: 30)),
            end: _now);
        await HealthKitReporter.relateWorkoutEffort(effort, workout.uuid);
        final result = await HealthKitReporter.workoutEffortRelationshipQuery(
            predicate:
                Predicate(_now.subtract(const Duration(hours: 1)), _now));
        final related = result.relationships
            .where((e) => e.workout.uuid == workout.uuid)
            .expand((e) => e.samples)
            .toList();
        for (final sample in related) {
          await HealthKitReporter.unrelateWorkoutEffort(sample, workout.uuid);
        }
        return 'related ${related.length} effort samples to ${workout.uuid}, then unrelated them\nanchor: ${result.anchor}';
      }),
      DemoRow('workoutEffortRelationshipQuery',
          'iOS 18: relationships changed since the anchor of the last run',
          run: () async {
        const key = 'workoutEffort';
        final result = await HealthKitReporter.workoutEffortRelationshipQuery(
            anchor: _anchors[key]);
        final previous = _anchors[key];
        _anchors[key] = result.anchor;
        return '${result.relationships.length} relationships '
            '${previous == null ? 'from the beginning' : 'since the last anchor'}\nanchor: ${result.anchor}';
      }),
      DemoRow('deleteObjects', 'Deletes the steps this app wrote today',
          run: () async =>
              '${await HealthKitReporter.deleteObjects(_steps.identifier, _today)}'),
      DemoRow('startWatchApp',
          'Launches the app\'s watch companion; fails without one',
          run: () async =>
              '${await HealthKitReporter.startWatchApp(const WorkoutConfiguration(52, 2, 0, WorkoutConfigurationHarmonized(25, 'm')))}'),
    ]),
    DemoSection(
      'Observer and live queries',
      [
        DemoRow('observerQuery', 'Notifies when steps or sleep change',
            listen: (report) => HealthKitReporter.observerQuery(
                [_steps.identifier, CategoryType.sleepAnalysis.identifier],
                null,
                onUpdate: (identifier) =>
                    report('${_time()} update for ${_short(identifier)}'),
                onError: (error) => report('$error'))),
        DemoRow('anchoredObjectQuery',
            'Steps added or deleted since the last anchor; the anchor string survives stopping',
            listen: (report) {
          const key = 'anchoredSteps';
          return HealthKitReporter.anchoredObjectQuery(
            [_steps.identifier],
            null,
            anchor: _anchors[key],
            onUpdate: (samples, deletedObjects, anchor) {
              _anchors[key] = anchor;
              report('${_time()} +${samples.length} samples, '
                  '-${deletedObjects.length} deleted\nanchor: ${anchor?.substring(0, 16)}…');
            },
            onError: (error) => report('$error'),
          );
        }),
        DemoRow('statisticsCollectionQuery',
            'Daily step sums of the last 7 days, live', listen: (report) {
          final start = _startOfToday.subtract(const Duration(days: 6));
          return HealthKitReporter.statisticsCollectionQuery(
            [PreferredUnit(_steps.identifier, 'count')],
            Predicate(start, _now),
            start,
            start,
            _now,
            const DateComponents(day: 1),
            onUpdate: (statistics) => report(
                '${DateTime.fromMillisecondsSinceEpoch((statistics.startTimestamp * 1000).round()).toIso8601String().substring(0, 10)}: '
                '${statistics.harmonized.summary ?? 0} steps'),
            onError: (error) => report('$error'),
          );
        }),
        DemoRow('queryActivitySummaryUpdates', 'Activity rings of today, live',
            listen: (report) => HealthKitReporter.queryActivitySummaryUpdates(
                _today,
                onUpdate: (summaries) =>
                    report('${_time()} ${summaries.length} summaries'),
                onError: (error) => report('$error'))),
        DemoRow('enableBackgroundDelivery', 'Hourly step updates in background',
            run: () async =>
                '${await HealthKitReporter.enableBackgroundDelivery(_steps.identifier, UpdateFrequency.hourly)}'),
        DemoRow('disableBackgroundDelivery', 'Stops background step updates',
            run: () async =>
                '${await HealthKitReporter.disableBackgroundDelivery(_steps.identifier)}'),
        DemoRow('disableAllBackgroundDelivery', 'Stops every background update',
            run: () async =>
                '${await HealthKitReporter.disableAllBackgroundDelivery()}'),
      ],
      footer: 'Live queries keep updating until Stop live queries.',
    ),
    DemoSection(
      'Simulator data',
      [
        DemoRow('Seed 7 days of data',
            'Plausible samples for every writable type, once per day and type',
            run: Seeding.seed),
        DemoRow('Delete seeded data',
            'Deletes, by uuid, only the samples seeding wrote',
            run: Seeding.deleteSeeded),
      ],
      footer:
          'Read-only data (ECGs, characteristics, activity summaries, clinical records) comes from Apple Watch or the Health app.',
    ),
  ];

  Future<String> _stepsRoundTrip() async {
    final log = <String>[];
    final authorized = await HealthKitReporter.requestAuthorization(
        [_steps.identifier], [_steps.identifier]);
    log.add('authorized: $authorized');
    final start = _now.subtract(const Duration(minutes: 2));
    final uuid = await HealthKitReporter.save(
        _demo.quantity(_steps.identifier, 42, 'count', start, end: _now));
    log.add('saved, uuid: $uuid');
    final today =
        await HealthKitReporter.quantityQuery(_steps, 'count', _today);
    final stored = today.where((e) => e.uuid == uuid).toList();
    log.add('read ${today.length} step samples today, '
        '${stored.length} with that uuid (${stored.firstOrNull?.harmonized.value} steps)');
    if (stored.isEmpty) return log.join('\n');
    final deleted = await HealthKitReporter.delete(stored.single);
    log.add('deleted by uuid: $deleted');
    final after =
        await HealthKitReporter.quantityQuery(_steps, 'count', _today);
    log.add('still stored: ${after.any((e) => e.uuid == uuid)}');
    return log.join('\n');
  }

  /// Saves a 30 minute walk and reads the stored workout back by its uuid
  Future<Workout> _saveWalk() async {
    final start = _now.subtract(const Duration(minutes: 30));
    final uuid = await HealthKitReporter.save(_demo.workout(
        WorkoutActivityType.walking, start, const Duration(minutes: 30)));
    final workouts = await HealthKitReporter.workoutQuery(
        Predicate(start.subtract(const Duration(minutes: 1)), _now));
    return workouts.firstWhere((e) => e.uuid == uuid);
  }

  static String _describe(List<Sample> samples) =>
      '${samples.length} samples${_first(samples)}';

  static String _first(List<Sample> samples) =>
      samples.isEmpty ? '' : '\nfirst: ${_json(samples.first.map)}';

  static String _json(Object? value) =>
      const JsonEncoder.withIndent(' ').convert(value);

  static String _time() => _now.toIso8601String().substring(11, 19);

  static String _short(String identifier) =>
      identifier.replaceFirst(RegExp(r'^HK\w+TypeIdentifier'), '');
}
