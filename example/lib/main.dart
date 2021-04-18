import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:health_kit_reporter/health_kit_reporter.dart';
import 'package:health_kit_reporter/model/payload/category.dart';
import 'package:health_kit_reporter/model/payload/date_components.dart';
import 'package:health_kit_reporter/model/payload/device.dart';
import 'package:health_kit_reporter/model/payload/quantity.dart';
import 'package:health_kit_reporter/model/payload/source.dart';
import 'package:health_kit_reporter/model/payload/source_revision.dart';
import 'package:health_kit_reporter/model/payload/workout.dart';
import 'package:health_kit_reporter/model/payload/workout_event.dart';
import 'package:health_kit_reporter/model/predicate.dart';
import 'package:health_kit_reporter/model/type/activity_summary_type.dart';
import 'package:health_kit_reporter/model/type/category_type.dart';
import 'package:health_kit_reporter/model/type/characteristic_type.dart';
import 'package:health_kit_reporter/model/type/correlation_type.dart';
import 'package:health_kit_reporter/model/type/electrocardiogram_type.dart';
import 'package:health_kit_reporter/model/type/quantity_type.dart';
import 'package:health_kit_reporter/model/type/series_type.dart';
import 'package:health_kit_reporter/model/type/workout_type.dart';
import 'package:health_kit_reporter/model/update_frequency.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final _flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
  final _predicate = Predicate(
    DateTime.now().add(Duration(days: -365)),
    DateTime.now(),
  );
  final _device = Device(
    'FlutterTracker',
    'kvs',
    'T-800',
    '3',
    '3.0',
    '1.1.1',
    'kvs.sample.app',
    '444-888-555',
  );
  final _source = Source(
    'myApp',
    'com.kvs.health_kit_reporter_example',
  );
  final _operatingSystem = OperatingSystem(
    1,
    2,
    3,
  );

  SourceRevision get _sourceRevision => SourceRevision(
        _source,
        '5',
        'fit',
        '4',
        _operatingSystem,
      );

  bool _isAuthorizationRequested = false;

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
      home: Scaffold(
        appBar: AppBar(
          title: Text('Health Kit Reporter'),
          actions: [
            IconButton(
              onPressed: () async {
                try {
                  final readTypes = <String>[];
                  readTypes.addAll(
                      ActivitySummaryType.values.map((e) => e.identifier));
                  readTypes
                      .addAll(CategoryType.values.map((e) => e.identifier));
                  readTypes.addAll(
                      CharacteristicType.values.map((e) => e.identifier));
                  readTypes
                      .addAll(QuantityType.values.map((e) => e.identifier));
                  readTypes.addAll(WorkoutType.values.map((e) => e.identifier));
                  readTypes.addAll(SeriesType.values.map((e) => e.identifier));
                  readTypes.addAll(
                      ElectrocardiogramType.values.map((e) => e.identifier));
                  final writeTypes = <String>[
                    QuantityType.stepCount.identifier,
                    WorkoutType.workoutType.identifier,
                    CategoryType.sleepAnalysis.identifier,
                    CategoryType.mindfulSession.identifier,
                  ];
                  final isRequested =
                      await HealthKitReporter.requestAuthorization(
                          readTypes, writeTypes);
                  setState(() => _isAuthorizationRequested = isRequested);
                } catch (e) {
                  print(e);
                }
              },
              icon: Icon(Icons.login),
            )
          ],
        ),
        body: SingleChildScrollView(
          child: _isAuthorizationRequested
              ? Center(
                  child: Column(
                    children: [
                      Column(
                        children: [
                          Text('READ'),
                          ElevatedButton(
                              onPressed: () {
                                handleQuantitiySamples();
                              },
                              child: Text('preferredUnit:quantity:statistics')),
                          ElevatedButton(
                              onPressed: () {
                                queryCharacteristics();
                              },
                              child: Text('characteristics')),
                          ElevatedButton(
                              onPressed: () {
                                queryCategory();
                              },
                              child: Text('categories')),
                          ElevatedButton(
                              onPressed: () {
                                queryWorkout();
                              },
                              child: Text('workouts')),
                          ElevatedButton(
                              onPressed: () {
                                querySamples();
                              },
                              child: Text('samples')),
                          ElevatedButton(
                              onPressed: () {
                                querySources();
                              },
                              child: Text('sources')),
                          ElevatedButton(
                              onPressed: () {
                                queryCorrelations();
                              },
                              child: Text('correlations')),
                          ElevatedButton(
                              onPressed: () {
                                queryElectrocardiograms();
                              },
                              child: Text('electrocardiograms')),
                          ElevatedButton(
                              onPressed: () {
                                queryActivitySummary();
                              },
                              child: Text('activitySummary')),
                        ],
                      ),
                      Column(
                        children: [
                          Text('WRITE'),
                          ElevatedButton(
                            onPressed: () {
                              saveWorkout();
                            },
                            child: Text('saveWorkout'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              saveSteps();
                            },
                            child: Text('saveSteps'),
                          ),
                          ElevatedButton(
                            onPressed: () {
                              saveMindfulMinutes();
                            },
                            child: Text('saveMindfulMinutes'),
                          ),
                        ],
                      ),
                      Column(
                        children: [
                          Text('OBSERVE'),
                          ElevatedButton(
                              onPressed: () {
                                observerQuery(
                                    QuantityType.stepCount.identifier);
                              },
                              child: Text('observerQuery - STEPS')),
                          ElevatedButton(
                              onPressed: () {
                                observerQuery(
                                    QuantityType.heartRate.identifier);
                              },
                              child: Text('observerQuery - HR')),
                          ElevatedButton(
                              onPressed: () {
                                anchoredObjectQuery(
                                    QuantityType.stepCount.identifier);
                              },
                              child: Text('anchoredObjectQuery - STEPS')),
                          ElevatedButton(
                              onPressed: () {
                                anchoredObjectQuery(
                                    QuantityType.heartRate.identifier);
                              },
                              child: Text('anchoredObjectQuery - HR')),
                          ElevatedButton(
                              onPressed: () {
                                queryActivitySummaryUpdates();
                              },
                              child: Text('queryActivitySummaryUpdates')),
                          ElevatedButton(
                              onPressed: () {
                                statisticsCollectionQuery();
                              },
                              child: Text('statisticsCollectionQuery')),
                          ElevatedButton(
                              onPressed: () {
                                heartbeatSeriesQuery();
                              },
                              child: Text('heartbeatSeriesQuery')),
                          ElevatedButton(
                              onPressed: () {
                                workoutRouteQuery();
                              },
                              child: Text('workoutRouteQuery')),
                        ],
                      ),
                    ],
                  ),
                )
              : Container(),
        ),
      ),
    );
  }

  void queryActivitySummary() async {
    try {
      final activitySummary =
          await HealthKitReporter.queryActivitySummary(_predicate);
      print('activitySummary: ${activitySummary.map((e) => e.map).toList()}');
    } catch (e) {
      print(e);
    }
  }

  void queryElectrocardiograms() async {
    try {
      final electrocardiograms =
          await HealthKitReporter.electrocardiogramQuery(_predicate);
      print(
          'electrocardiograms: ${electrocardiograms.map((e) => e.map).toList()}');
    } catch (e) {
      print(e);
    }
  }

  void queryCorrelations() async {
    try {
      final correlations = await HealthKitReporter.correlationQuery(
          CorrelationType.bloodPressure.identifier, _predicate);
      print('correlations: ${correlations.map((e) => e.map).toList()}');
    } catch (e) {
      print(e);
    }
  }

  void querySources() async {
    try {
      final sources = await HealthKitReporter.sourceQuery(
          QuantityType.stepCount.identifier, _predicate);
      print('sources: ${sources.map((e) => e.map).toList()}');
    } catch (e) {
      print(e);
    }
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
            _device,
            _sourceRevision,
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
          6,
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
        final eventHarmonized = WorkoutEventHarmonized(
          6,
          null,
        );
        final events = [
          WorkoutEvent(
            'basketball',
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
          _device,
          _sourceRevision,
          harmonized,
          'testWorkoutName',
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
          'Breath Meditation',
          {},
        );
        final mindfulMinutes = Category(
          'testMindfulMinutesUUID',
          CategoryType.mindfulSession.identifier,
          minuteAgo.millisecondsSinceEpoch,
          now.millisecondsSinceEpoch,
          _device,
          _sourceRevision,
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

  void querySamples() async {
    try {
      final samples = await HealthKitReporter.sampleQuery(
          QuantityType.stepCount.identifier, _predicate);
      print('samples: ${samples.map((e) => e.map).toList()}');
    } catch (e) {
      print(e);
    }
  }

  void queryCategory() async {
    try {
      final categories = await HealthKitReporter.categoryQuery(
          CategoryType.sleepAnalysis, _predicate);
      print('categories: ${categories.map((e) => e.map).toList()}');
    } catch (e) {
      print(e);
    }
  }

  void queryWorkout() async {
    try {
      final workouts = await HealthKitReporter.workoutQuery(_predicate);
      print('workouts: ${workouts.map((e) => e.map).toList()}');
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

  void handleQuantitiySamples() async {
    try {
      final preferredUnits = await HealthKitReporter.preferredUnits([
        QuantityType.stepCount,
      ]);
      preferredUnits.forEach((preferredUnit) async {
        final identifier = preferredUnit.identifier;
        final unit = preferredUnit.unit;
        print('preferredUnit: ${preferredUnit.map}');
        final type = QuantityTypeFactory.from(identifier);
        final quantities =
            await HealthKitReporter.quantityQuery(type, unit, _predicate);
        print('quantity: ${quantities.map((e) => e.map).toList()}');
        final statistics =
            await HealthKitReporter.statisticsQuery(type, unit, _predicate);
        print('statistics: ${statistics.map}');
      });
    } catch (e) {
      print(e);
    }
  }

  void observerQuery(String identifier) async {
    final sub = HealthKitReporter.observerQuery(identifier, _predicate,
        onUpdate: (identifier) async {
      print('Updates for observerQuerySub - $identifier');
      print(identifier);
      final iOSDetails = IOSNotificationDetails();
      final details = NotificationDetails(iOS: iOSDetails);
      await _flutterLocalNotificationsPlugin.show(
          0, 'Observer', identifier, details);
    });
    print('$identifier observerQuerySub: $sub');
    final isSet = await HealthKitReporter.enableBackgroundDelivery(
        identifier, UpdateFrequency.immediate);
    print('$identifier enableBackgroundDelivery: $isSet');
  }

  void heartbeatSeriesQuery() {
    final sub =
        HealthKitReporter.heartbeatSeriesQuery(_predicate, onUpdate: (serie) {
      print('Updates for heartbeatSeriesQuery');
      print(serie.map);
    });
    print('heartbeatSeriesQuery: $sub');
  }

  void workoutRouteQuery() {
    final sub =
        HealthKitReporter.workoutRouteQuery(_predicate, onUpdate: (serie) {
      print('Updates for workoutRouteQuery');
      print(serie.map);
    });
    print('workoutRouteQuery: $sub');
  }

  void anchoredObjectQuery(String identifier) {
    final sub = HealthKitReporter.anchoredObjectQuery(identifier, _predicate,
        onUpdate: (samples, deletedObjects) {
      print('Updates for anchoredObjectQuerySub - $identifier');
      print(samples.map((e) => e.map).toList());
      print(deletedObjects.map((e) => e.map).toList());
    });
    print('$identifier anchoredObjectQuerySub: $sub');
  }

  void queryActivitySummaryUpdates() {
    final sub = HealthKitReporter.queryActivitySummaryUpdates(_predicate,
        onUpdate: (samples) {
      print('Updates for activitySummaryUpdatesSub');
      print(samples.map((e) => e.map).toList());
    });
    print('activitySummaryUpdatesSub: $sub');
  }

  void statisticsCollectionQuery() {
    final anchorDate = DateTime.utc(2020, 2, 1, 12, 30, 30);
    final enumerateFrom = DateTime.utc(2020, 3, 1, 12, 30, 30);
    final enumerateTo = DateTime.utc(2020, 12, 31, 12, 30, 30);
    final intervalComponents = DateComponents(month: 1);
    final sub = HealthKitReporter.statisticsCollectionQuery(
        QuantityType.stepCount,
        'count',
        _predicate,
        anchorDate,
        enumerateFrom,
        enumerateTo,
        intervalComponents, onUpdate: (statistics) {
      print('Updates for statisticsCollectionQuerySub');
      print(statistics.map);
    });
    print('statisticsCollectionQuery: $sub');
  }
}
