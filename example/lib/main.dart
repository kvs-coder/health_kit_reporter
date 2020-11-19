import 'dart:async';

import 'package:flutter/material.dart';
import 'package:health_kit_reporter/health_kit_reporter.dart';
import 'package:health_kit_reporter/model/predicate.dart';
import 'package:health_kit_reporter/model/type/characteristic_type.dart';
import 'package:health_kit_reporter/model/type/quantity_type.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
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

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> runHealthKitReporter() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      final readTypes = [
        QuantityType.stepCount.identifier,
        CharacteristicType.biologicalSex.identifier,
        CharacteristicType.dateOfBirth.identifier,
        CharacteristicType.bloodType.identifier,
        CharacteristicType.fitzpatrickSkinType.identifier,
      ];
      final writeTypes = [
        QuantityType.stepCount,
      ];
      final isRequested = await HealthKitReporter.requestAuthorization(
          readTypes, writeTypes.map((e) => e.identifier).toList());
      print('IsRequested: $isRequested');
      final preferredUnits = await HealthKitReporter.preferredUnits(writeTypes);
      preferredUnits.forEach((element) async {
        print('preferredUnit: ${element.identifier}');
        final predicate = Predicate(
          DateTime.utc(1990, 1, 1, 12, 30, 30),
          DateTime.utc(2020, 12, 31, 12, 30, 30),
        );
        try {
          final type = QuantityTypeFactory.from(element.identifier);
          final quantities = await HealthKitReporter.quantityQuery(
              type, element.unit, predicate);
          quantities.forEach((element) {
            print('quantity: ${element.map}');
          });
        } catch (exception) {
          print('quantityQuery exception: $exception');
        }
      });
      final characteristics = await HealthKitReporter.characteristicsQuery();
      print('characteristics: ${characteristics.map}');
    } catch (exception) {
      print('general exception: $exception');
    }
  }
}
