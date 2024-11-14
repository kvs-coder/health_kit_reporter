import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:health_kit_reporter/health_kit_reporter.dart';
import 'package:health_kit_reporter/model/payload/category.dart';
import 'package:health_kit_reporter/model/payload/correlation.dart';
import 'package:health_kit_reporter/model/payload/date_components.dart';
import 'package:health_kit_reporter/model/payload/device.dart';
import 'package:health_kit_reporter/model/payload/preferred_unit.dart';
import 'package:health_kit_reporter/model/payload/quantity.dart';
import 'package:health_kit_reporter/model/payload/source.dart';
import 'package:health_kit_reporter/model/payload/source_revision.dart';
import 'package:health_kit_reporter/model/payload/workout.dart';
import 'package:health_kit_reporter/model/payload/workout_activity_type.dart';
import 'package:health_kit_reporter/model/payload/workout_event.dart';
import 'package:health_kit_reporter/model/payload/workout_event_type.dart';
import 'package:health_kit_reporter/model/predicate.dart';
import 'package:health_kit_reporter/model/type/activity_summary_type.dart';
import 'package:health_kit_reporter/model/type/category_type.dart';
import 'package:health_kit_reporter/model/type/characteristic_type.dart';
import 'package:health_kit_reporter/model/type/clinical_type.dart';
import 'package:health_kit_reporter/model/type/correlation_type.dart';
import 'package:health_kit_reporter/model/type/electrocardiogram_type.dart';
import 'package:health_kit_reporter/model/type/quantity_type.dart';
import 'package:health_kit_reporter/model/type/series_type.dart';
import 'package:health_kit_reporter/model/type/workout_type.dart';
import 'package:health_kit_reporter/model/update_frequency.dart';

void main() {
  runApp(MyApp());
}

mixin HealthKitReporterMixin {
  Predicate get predicate => Predicate(
        DateTime.now().add(Duration(days: -365)),
        DateTime.now(),
      );

  Device get device => Device(
        'FlutterTracker',
        'kvs',
        'T-800',
        '3',
        '3.0',
        '1.1.1',
        'kvs.sample.app',
        '444-888-555',
      );

  Source get source => Source(
        'myApp',
        'com.kvs.health_kit_reporter_example',
      );

  OperatingSystem get operatingSystem => OperatingSystem(
        1,
        2,
        3,
      );

  SourceRevision get sourceRevision => SourceRevision(
        source,
        '5',
        'fit',
        '4',
        operatingSystem,
      );
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    final initializationSettingsIOs = IOSInitializationSettings();
    final initSettings = InitializationSettings(iOS: initializationSettingsIOs);
    _flutterLocalNotificationsPlugin.initialize(initSettings,
        onSelectNotification: (string) {
      print(string);
      return Future.value(string);
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: DefaultTabController(
        length: 4,
        child: Scaffold(
          appBar: AppBar(
            title: Text('Health Kit Reporter'),
            actions: [
              IconButton(
                onPressed: () => _authorize(),
                icon: Icon(Icons.login),
                tooltip: 'Authorizes HealthKit',
              ),
              IconButton(
                onPressed: () => _authorizeClinicalRecords(),
                icon: Icon(Icons.login),
                tooltip: 'Authorizes clinical records',
                color: Colors.blue,
              ),
            ],
            bottom: TabBar(
              tabs: [
                Tab(
                  icon: Icon(Icons.book),
                  text: 'Read',
                ),
                Tab(
                  icon: Icon(Icons.edit),
                  text: 'Write',
                ),
                Tab(
                  icon: Icon(Icons.monitor),
                  text: 'Observe',
                ),
                Tab(
                  icon: Icon(Icons.delete),
                  text: 'Delete',
                ),
              ],
            ),
          ),
          body: TabBarView(
            children: [
              _ReadView(),
              _WriteView(),
              _ObserveView(
                flutterLocalNotificationsPlugin:
                    _flutterLocalNotificationsPlugin,
              ),
              _DeleteView(),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _authorize() async {
    try {
      final readTypes = <String>[];
      readTypes.addAll(ActivitySummaryType.values.map((e) => e.identifier));
      readTypes.addAll(CategoryType.values.map((e) => e.identifier));
      readTypes.addAll(CharacteristicType.values.map((e) => e.identifier));
      readTypes.addAll(QuantityType.values.map((e) => e.identifier));
      readTypes.addAll(WorkoutType.values.map((e) => e.identifier));
      readTypes.addAll(SeriesType.values.map((e) => e.identifier));
      readTypes.addAll(ElectrocardiogramType.values.map((e) => e.identifier));
      final writeTypes = <String>[
        QuantityType.stepCount.identifier,
        WorkoutType.workoutType.identifier,
        CategoryType.sleepAnalysis.identifier,
        CategoryType.mindfulSession.identifier,
        QuantityType.bloodPressureDiastolic.identifier,
        QuantityType.bloodPressureSystolic.identifier,
        //CorrelationType.bloodPressure.identifier,
      ];
      final isRequested =
          await HealthKitReporter.requestAuthorization(readTypes, writeTypes);
      print('isRequested auth: $isRequested');
    } catch (e) {
      print(e);
    }
  }

  Future<void> _authorizeClinicalRecords() async {
    try {
      final readTypes =
          ClinicalType.values.map((type) => type.identifier).toList();
      final isRequested =
          await HealthKitReporter.requestAuthorization(readTypes, []);
      print('isRequested auth: $isRequested');
    } catch (e) {
      print(e);
    }
  }
}

class _ReadView extends StatelessWidget with HealthKitReporterMixin {
  const _ReadView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        TextButton(
            onPressed: () {
              handleQuantitySamples();
            },
            child: Text('preferredUnit:quantity:statistics')),
        TextButton(
            onPressed: () {
              queryCharacteristics();
            },
            child: Text('characteristics')),
        TextButton(
            onPressed: () {
              queryClinicalRecords();
            },
            child: Text('Clinical Records')),
        TextButton(
            onPressed: () {
              queryCategory();
            },
            child: Text('categories')),
        TextButton(
            onPressed: () {
              queryWorkout();
            },
            child: Text('workouts')),
        TextButton(
            onPressed: () {
              querySamples();
            },
            child: Text('samples')),
        TextButton(
            onPressed: () {
              queryHeartbeatSeries();
            },
            child: Text('heartbeatSeriesQuery')),
        TextButton(
            onPressed: () {
              workoutRouteQuery();
            },
            child: Text('workoutRouteQuery')),
        TextButton(
            onPressed: () {
              workoutRouteForUUIDQuery();
            },
            child: Text('workoutRouteForUUIDQuery')),
        TextButton(
            onPressed: () {
              querySources();
            },
            child: Text('sources')),
        TextButton(
            onPressed: () {
              queryCorrelations();
            },
            child: Text('correlations')),
        TextButton(
            onPressed: () {
              queryElectrocardiograms();
            },
            child: Text('electrocardiograms')),
        TextButton(
            onPressed: () {
              queryActivitySummary();
            },
            child: Text('activitySummary')),
        TextButton(
            onPressed: () {
              multipleQuery();
            },
            child: Text('multipleQuery')),
      ],
    );
  }

  void multipleQuery() async {
    final prefUnits =
        await HealthKitReporter.preferredUnits([QuantityType.heartRate]);
    final hrUnits = prefUnits.first.unit;

    final now = DateTime.now();

    for (int _ in List.generate(10, (index) => index + 1)) {
      final hbQuery = await HealthKitReporter.quantityQuery(
          QuantityType.heartRate,
          hrUnits,
          Predicate(now.subtract(Duration(seconds: 120 * 60 * 24)), now));
      print(hbQuery.map((e) => e.harmonized.value));
    }
  }

  void querySamples() async {
    try {
      final samples = await HealthKitReporter.sampleQuery(
          QuantityType.stepCount.identifier, predicate);
      print('samples: ${samples.map((e) => e.map).toList()}');
    } catch (e) {
      print(e);
    }
  }

  void queryClinicalRecords() async {
    try {
      final samples = await HealthKitReporter.sampleQuery(
        ClinicalType.allergyRecord.identifier,
        Predicate(
          DateTime.now().add(Duration(days: -7000)),
          DateTime.now(),
        ),
      );
      print('clinicalRecords: ${samples.map((e) => e.map).toList()}');
    } catch (e, stackTrace) {
      print("$e\n$stackTrace");
    }
  }

  void queryCategory() async {
    try {
      final categories = await HealthKitReporter.categoryQuery(
          CategoryType.sleepAnalysis, predicate);
      print('categories: ${categories.map((e) => e.map).toList()}');
    } catch (e) {
      print(e);
    }
  }

  void queryWorkout() async {
    try {
      final workouts = await HealthKitReporter.workoutQuery(predicate);
      print('workouts: ${workouts.map((e) => e.map).toList()}');
      for (final q in workouts) {
        print('q: ${json.encode(q.map)}');
      }
    } catch (e) {
      print(e);
    }
  }

  void queryHeartbeatSeries() async {
    try {
      final series = await HealthKitReporter.heartbeatSeriesQuery(predicate);
      print('heartbeatSeries: ${series.map((e) => e.map).toList()}');
    } catch (e) {
      print(e);
    }
  }

  void workoutRouteQuery() async {
    try {
      final series = await HealthKitReporter.workoutRouteQuery(predicate);
      print('workoutRoutes: ${series.map((e) => e.map).toList()}');
    } catch (e) {
      print(e);
    }
  }

  void workoutRouteForUUIDQuery() async {
    try {
      final series = await HealthKitReporter.workoutRouteForUUIDQuery(
        const UUIDPredicate('D3A3D3A3-4D3A-4A3A-8A3A-3A3A3A3A3A3A'),
      );
      print('workoutRoutes: ${series.map((e) => e.map).toList()}');
    } catch (e) {
      print(e);
    }
  }

  void queryCharacteristics() async {
    try {
      final characteristics = await HealthKitReporter.characteristicsQuery();
      print('characteristics: ${characteristics.map}');
    } catch (e) {
      print(e);
    }
  }

  void handleQuantitySamples() async {
    try {
      final preferredUnits = await HealthKitReporter.preferredUnits([
        QuantityType.stepCount,
      ]);
      preferredUnits.forEach((preferredUnit) async {
        final identifier = preferredUnit.identifier;
        final unit = preferredUnit.unit;
        print('preferredUnit: ${preferredUnit.map}');
        final type = QuantityTypeFactory.from(identifier);
        try {
          final quantities =
              await HealthKitReporter.quantityQuery(type, unit, predicate);
          print('quantity: ${quantities.map((e) => e.map).toList()}');
          final statistics =
              await HealthKitReporter.statisticsQuery(type, unit, predicate);
          print('statistics: ${statistics.map}');
        } catch (e) {
          print(e);
        }
      });
    } catch (e) {
      print(e);
    }
  }

  void queryActivitySummary() async {
    try {
      final activitySummary =
          await HealthKitReporter.queryActivitySummary(predicate);
      print('activitySummary: ${activitySummary.map((e) => e.map).toList()}');
    } catch (e) {
      print(e);
    }
  }

  void queryElectrocardiograms() async {
    try {
      final electrocardiograms = await HealthKitReporter.electrocardiogramQuery(
          predicate,
          withVoltageMeasurements: true);
      print(
          'electrocardiograms: ${electrocardiograms.map((e) => e.map).toList()}');
    } catch (e) {
      print(e);
    }
  }

  void queryCorrelations() async {
    try {
      final correlations = await HealthKitReporter.correlationQuery(
          CorrelationType.bloodPressure.identifier, predicate);
      print('correlations: ${correlations.map((e) => e.map).toList()}');
    } catch (e) {
      print(e);
    }
  }

  void querySources() async {
    try {
      final sources = await HealthKitReporter.sourceQuery(
          QuantityType.stepCount.identifier, predicate);
      print('sources: ${sources.map((e) => e.map).toList()}');
    } catch (e) {
      print(e);
    }
  }
}

class _WriteView extends StatelessWidget with HealthKitReporterMixin {
  const _WriteView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        TextButton(
          onPressed: () {
            saveWorkout();
          },
          child: Text('saveWorkout'),
        ),
        TextButton(
          onPressed: () {
            saveSteps();
          },
          child: Text('saveSteps'),
        ),
        TextButton(
          onPressed: () {
            saveMindfulMinutes();
          },
          child: Text('saveMindfulMinutes'),
        ),
        TextButton(
          onPressed: () {
            saveBloodPressureCorrelation();
          },
          child: Text('saveBloodPressureCorrelation'),
        ),
      ],
    );
  }

  void saveSteps() async {
    try {
      final canWrite = await HealthKitReporter.isAuthorizedToWrite(
          QuantityType.stepCount.identifier);
      if (canWrite) {
        final now = DateTime.now();
        final minuteAgo = now.add(Duration(minutes: -1));
        final harmonized = QuantityHarmonized(100, 'count', null);
        final steps = Quantity(
            'testStepsUUID',
            QuantityType.stepCount.identifier,
            minuteAgo.millisecondsSinceEpoch,
            now.millisecondsSinceEpoch,
            device,
            sourceRevision,
            harmonized);
        print('try to save: ${steps.map}');
        final saved = await HealthKitReporter.save(steps);
        print('stepsSaved: $saved');
      } else {
        print('error canWrite steps: $canWrite');
      }
    } catch (e) {
      print(e);
    }
  }

  void saveWorkout() async {
    try {
      final canWrite = await HealthKitReporter.isAuthorizedToWrite(
          WorkoutType.workoutType.identifier);
      if (canWrite) {
        final harmonized = WorkoutHarmonized(
          WorkoutActivityType.badminton,
          1.2,
          'kcal',
          123,
          'm',
          0,
          'count',
          0,
          'count',
          null,
        );
        final now = DateTime.now();
        final duration = 60;
        final eventHarmonized = WorkoutEventHarmonized(WorkoutEventType.pause);
        final events = [
          WorkoutEvent(
            now.millisecondsSinceEpoch,
            now.millisecondsSinceEpoch,
            duration,
            eventHarmonized,
          )
        ];
        final minuteAgo = now.add(Duration(seconds: -duration));
        final workout = Workout(
          'testWorkoutUUID',
          'basketball',
          minuteAgo.millisecondsSinceEpoch,
          now.millisecondsSinceEpoch,
          device,
          sourceRevision,
          harmonized,
          duration,
          events,
        );
        print('try to save: ${workout.map}');
        final saved = await HealthKitReporter.save(workout);
        print('workoutSaved: $saved');
      } else {
        print('error canWrite workout: $canWrite');
      }
    } catch (e) {
      print(e);
    }
  }

  void saveMindfulMinutes() async {
    try {
      final canWrite = await HealthKitReporter.isAuthorizedToWrite(
          CategoryType.mindfulSession.identifier);
      if (canWrite) {
        final now = DateTime.now();
        final minuteAgo = now.add(Duration(minutes: -1));
        final harmonized = CategoryHarmonized(
          0,
          'HKCategoryValue',
          'Not Aplicable',
          {},
        );
        final mindfulMinutes = Category(
          'testMindfulMinutesUUID',
          CategoryType.mindfulSession.identifier,
          minuteAgo.millisecondsSinceEpoch,
          now.millisecondsSinceEpoch,
          device,
          sourceRevision,
          harmonized,
        );
        print('try to save: ${mindfulMinutes.map}');
        final saved = await HealthKitReporter.save(mindfulMinutes);
        print('mindfulMinutesSaved: $saved');
      } else {
        print('error canWrite mindfulMinutes: $canWrite');
      }
    } catch (e) {
      print(e);
    }
  }

  void saveBloodPressureCorrelation() async {
    try {
      final now = DateTime.now();
      final minuteAgo = now.add(Duration(minutes: -1));
      final sys = Quantity(
          'testSysUUID234',
          QuantityType.bloodPressureSystolic.identifier,
          minuteAgo.millisecondsSinceEpoch,
          now.millisecondsSinceEpoch,
          device,
          sourceRevision,
          QuantityHarmonized(123, 'mmHg', null));
      final dia = Quantity(
          'testDiaUUID456',
          QuantityType.bloodPressureDiastolic.identifier,
          minuteAgo.millisecondsSinceEpoch,
          now.millisecondsSinceEpoch,
          device,
          sourceRevision,
          QuantityHarmonized(89, 'mmHg', null));
      final correlationJarmonized = CorrelationHarmonized([sys, dia], [], null);
      final correlation = Correlation(
          'test',
          CorrelationType.bloodPressure.identifier,
          minuteAgo.millisecondsSinceEpoch,
          now.millisecondsSinceEpoch,
          device,
          sourceRevision,
          correlationJarmonized);
      final saved = await HealthKitReporter.save(correlation);
      print('BloodPressureCorrelationSaved: $saved');
    } catch (e) {
      print(e);
    }
  }
}

class _ObserveView extends StatelessWidget with HealthKitReporterMixin {
  const _ObserveView({
    Key? key,
    required this.flutterLocalNotificationsPlugin,
  }) : super(key: key);

  final FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin;

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        TextButton(
            onPressed: () {
              observerQuery([
                QuantityType.stepCount.identifier,
                QuantityType.heartRate.identifier,
              ]);
            },
            child: Text('observerQuery - STEPS and HR')),
        TextButton(
            onPressed: () {
              anchoredObjectQuery([
                QuantityType.stepCount.identifier,
                QuantityType.heartRate.identifier,
              ]);
            },
            child: Text('anchoredObjectQuery - STEPS and HR')),
        TextButton(
            onPressed: () {
              queryActivitySummaryUpdates();
            },
            child: Text('queryActivitySummaryUpdates')),
        TextButton(
            onPressed: () {
              statisticsCollectionQuery();
            },
            child: Text('statisticsCollectionQuery')),
      ],
    );
  }

  void observerQuery(List<String> identifiers) async {
    try {
      final sub = HealthKitReporter.observerQuery(identifiers, null,
          onUpdate: (identifier) async {
        print('Updates for observerQuerySub - $identifier');
        print(identifier);
        final iOSDetails = IOSNotificationDetails();
        final details = NotificationDetails(iOS: iOSDetails);
        await flutterLocalNotificationsPlugin.show(
            0, 'Observer', identifier, details);
      });
      print('$identifiers observerQuerySub: $sub');
      for (final identifier in identifiers) {
        final isSet = await HealthKitReporter.enableBackgroundDelivery(
            identifier, UpdateFrequency.immediate);
        print('$identifier enableBackgroundDelivery: $isSet');
      }
    } catch (e) {
      print(e);
    }
  }

  void anchoredObjectQuery(List<String> identifiers) {
    try {
      final sub = HealthKitReporter.anchoredObjectQuery(identifiers, predicate,
          onUpdate: (samples, deletedObjects) {
        print('Updates for anchoredObjectQuerySub');
        print(samples.map((e) => e.map).toList());
        print(deletedObjects.map((e) => e.map).toList());
      });
      print('$identifiers anchoredObjectQuerySub: $sub');
    } catch (e) {
      print(e);
    }
  }

  void queryActivitySummaryUpdates() {
    try {
      final sub = HealthKitReporter.queryActivitySummaryUpdates(predicate,
          onUpdate: (samples) {
        print('Updates for activitySummaryUpdatesSub');
        print(samples.map((e) => e.map).toList());
      });
      print('activitySummaryUpdatesSub: $sub');
    } catch (e) {
      print(e);
    }
  }

  void statisticsCollectionQuery() {
    try {
      final anchorDate = DateTime.utc(2020, 2, 1, 12, 30, 30);
      final enumerateFrom = DateTime.utc(2020, 3, 1, 12, 30, 30);
      final enumerateTo = DateTime.utc(2020, 12, 31, 12, 30, 30);
      final intervalComponents = DateComponents(month: 1);
      final sub = HealthKitReporter.statisticsCollectionQuery(
        [
          PreferredUnit(
            QuantityType.stepCount.identifier,
            'count',
          ),
        ],
        predicate,
        anchorDate,
        enumerateFrom,
        enumerateTo,
        intervalComponents,
        onUpdate: (statistics) {
          print('Updates for statisticsCollectionQuerySub');
          print(statistics.map);
        },
      );
      print('statisticsCollectionQuery: $sub');
    } catch (e) {
      print(e);
    }
  }
}

class _DeleteView extends StatelessWidget with HealthKitReporterMixin {
  const _DeleteView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView(
      children: [
        TextButton(
            onPressed: () {
              deleteSteps();
            },
            child: Text('deleteSteps')),
      ],
    );
  }

  void deleteSteps() async {
    try {
      final map = await HealthKitReporter.deleteObjects(
          QuantityType.stepCount.identifier,
          Predicate(
            DateTime.now().add(Duration(days: -1)),
            DateTime.now(),
          ));
      print(map);
    } catch (e) {
      print(e);
    }
  }
}
