import 'dart:async';

import 'package:flutter/material.dart';
import 'package:health_kit_reporter/health_kit_reporter.dart';
import 'package:health_kit_reporter/model/payload/date_components.dart';
import 'package:health_kit_reporter/model/payload/device.dart';
import 'package:health_kit_reporter/model/payload/preferred_unit.dart';
import 'package:health_kit_reporter/model/payload/quantity.dart';
import 'package:health_kit_reporter/model/payload/source.dart';
import 'package:health_kit_reporter/model/payload/source_revision.dart';
import 'package:health_kit_reporter/model/predicate.dart';
import 'package:health_kit_reporter/model/type/activity_summary_type.dart';
import 'package:health_kit_reporter/model/type/category_type.dart';
import 'package:health_kit_reporter/model/type/characteristic_type.dart';
import 'package:health_kit_reporter/model/type/quantity_type.dart';
import 'package:health_kit_reporter/model/type/workout_type.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  final _predicate = Predicate(
    DateTime.utc(2020, 1, 1, 12, 30, 30),
    DateTime.utc(2020, 12, 31, 12, 30, 30),
  );

  @override
  Widget build(BuildContext context) {
    observerQuery();
    //anchoredObjectQuery();
    //queryActivitySummaryUpdates();
    //statisticsCollectionQuery();
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('HK'),
        ),
        floatingActionButton: FloatingActionButton(
          child: Icon(Icons.add),
          onPressed: () {
            runHealthKitReporter();
          },
        ),
      ),
    );
  }

  Future<void> runHealthKitReporter() async {
    try {
      final readTypes = <String>[];
      readTypes.addAll(ActivitySummaryType.values.map((e) => e.identifier));
      readTypes.addAll(CategoryType.values.map((e) => e.identifier));
      readTypes.addAll(CharacteristicType.values.map((e) => e.identifier));
      readTypes.addAll(QuantityType.values.map((e) => e.identifier));
      readTypes.addAll(WorkoutType.values.map((e) => e.identifier));
      final writeTypes = <String>[QuantityType.stepCount.identifier];
      final isRequested =
          await HealthKitReporter.requestAuthorization(readTypes, writeTypes);
      print('IsRequested: $isRequested');
      final preferredUnits =
          await HealthKitReporter.preferredUnits([QuantityType.stepCount]);
      preferredUnits.forEach((preferredUnit) async {
        print('preferredUnit: ${preferredUnit.identifier}');
        final type = QuantityTypeFactory.from(preferredUnit.identifier);
        final quantities = await HealthKitReporter.quantityQuery(
            type, preferredUnit, _predicate);
        print('quantity: ${quantities.map((e) => e.map)}');
        final statistics = await HealthKitReporter.statisticsQuery(
            type, preferredUnit, _predicate);
        print('statistics: ${statistics.map}');
      });
      final characteristics = await HealthKitReporter.characteristicsQuery();
      print('characteristics: ${characteristics.map}');
      final categories = await HealthKitReporter.categoryQuery(
          CategoryType.sleepAnalysis, _predicate);
      print('categories: ${categories.map((e) => e.map)}');
      final samples = await HealthKitReporter.sampleQuery(
          QuantityType.stepCount.identifier, _predicate);
      print('samples: ${samples.map((e) => e.map)}');
      final stepsSaved = await saveSteps();
      print('stepsSaved: $stepsSaved');
    } catch (exception) {
      print('general exception: $exception');
    } finally {}
  }

  void observerQuery() {
    final identifier = QuantityType.stepCount.identifier;
    final sub = HealthKitReporter.observerQuery(identifier, _predicate,
        onUpdate: (identifier) {
      print('Updates for observerQuerySub');
      print(identifier);
    });
    print('observerQuerySub: $sub');
  }

  void anchoredObjectQuery() {
    final identifier = QuantityType.stepCount.identifier;
    final sub = HealthKitReporter.anchoredObjectQuery(identifier, _predicate,
        onUpdate: (samples) {
      print('Updates for anchoredObjectQuerySub');
      print(samples.map((e) => e.map));
    });
    print('anchoredObjectQuerySub: $sub');
  }

  void queryActivitySummaryUpdates() {
    final sub = HealthKitReporter.queryActivitySummaryUpdates(_predicate,
        onUpdate: (samples) {
      print('Updates for activitySummaryUpdatesSub');
      print(samples.map((e) => e.map));
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
        PreferredUnit(QuantityType.stepCount.identifier, 'count'),
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

  Future<bool> saveSteps() {
    final now = DateTime.now();
    final minuteAgo = now.add(Duration(minutes: -1));
    final device = Device('FlutterTracker', 'kvs', 'T-800', '3', '3.0', '1.1.1',
        'kvs.f.t', '444-888-555');
    final source = Source('maApp', 'com.kvs.health_kit_reporter_example');
    final operatingSystem = OperatingSystem(1, 2, 3);
    final sourceRevision =
        SourceRevision(source, '5', 'fit', '4', operatingSystem);
    final harmonized = Harmonized(100, 'count', null);
    final steps = Quantity(
        QuantityType.stepCount.identifier,
        minuteAgo.millisecondsSinceEpoch,
        now.millisecondsSinceEpoch,
        device,
        sourceRevision,
        harmonized);
    print(steps.map);
    return HealthKitReporter.save(steps);
  }
}
