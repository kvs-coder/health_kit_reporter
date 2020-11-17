import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:health_kit_reporter/health_kit_reporter.dart';
import 'package:health_kit_reporter/model/predicate.dart';
import 'package:health_kit_reporter/model/type/quantity_type.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  String _platformVersion = 'Unknown';

  @override
  void initState() {
    super.initState();
    initPlatformState();
  }

  // Platform messages are asynchronous, so we initialize in an async method.
  Future<void> initPlatformState() async {
    String platformVersion;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      final types = [QuantityType.stepCount];
      final isRequested =
          await HealthKitReporter.requestAuthorization(types, types);
      print('IsRequested: $isRequested');
      final preferredUnits = await HealthKitReporter.preferredUnits(types);
      preferredUnits.forEach((element) async {
        final predicate = Predicate(
          DateTime.utc(1990, 1, 1, 12, 30, 30),
          DateTime.utc(2020, 12, 31, 12, 30, 30),
        );
        try {
          final type = QuantityTypeFactory.from(element.identifier);
          final quantityResponse = await HealthKitReporter.quantityQuery(
              type, element.unit, predicate);
          print(quantityResponse);
        } catch (exception) {
          print(exception);
        }
      });
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    setState(() {
      _platformVersion = platformVersion;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: const Text('Plugin example app'),
        ),
        body: Center(
          child: Text('Running on: $_platformVersion\n'),
        ),
      ),
    );
  }
}
