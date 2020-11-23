import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:health_kit_reporter/model/event_channel_method.dart';
import 'package:health_kit_reporter/model/payload/activity_summary.dart';
import 'package:health_kit_reporter/model/payload/characteristic/characteristic.dart';
import 'package:health_kit_reporter/model/payload/electrocardiogram.dart';
import 'package:health_kit_reporter/model/payload/heartbeat_serie.dart';
import 'package:health_kit_reporter/model/payload/statistics.dart';
import 'package:health_kit_reporter/model/type/category_type.dart';
import 'package:health_kit_reporter/model/type/quantity_type.dart';

import 'model/payload/category.dart';
import 'model/payload/date_components.dart';
import 'model/payload/device.dart';
import 'model/payload/preferred_unit.dart';
import 'model/payload/quantity.dart';
import 'model/payload/sample.dart';
import 'model/payload/workout.dart';
import 'model/payload/workout_configuration.dart';
import 'model/predicate.dart';
import 'model/update_frequency.dart';

class HealthKitReporter {
  static const MethodChannel _methodChannel =
      MethodChannel('health_kit_reporter_method_channel');
  static const EventChannel _eventChannel =
      EventChannel('health_kit_reporter_event_channel');

  static StreamSubscription<dynamic> observerQuery(
      String identifier, Predicate predicate,
      {Function(String) onUpdate}) {
    final eventMethod = EventChannelMethod.observerQuery.name;
    final arguments = <String, dynamic>{
      'identifier': identifier,
      'eventMethod': eventMethod,
    };
    arguments.addAll(predicate.map);
    return _eventChannel.receiveBroadcastStream(arguments).listen((event) {
      final map = Map<String, dynamic>.from(event);
      if (map['event'] == eventMethod) {
        final result = map['result'];
        final identifier = result['observingTypeIdentifier'];
        onUpdate(identifier);
      }
    });
  }

  static StreamSubscription<dynamic> anchoredObjectQuery(
      String identifier, Predicate predicate,
      {Function(List<Sample>) onUpdate}) {
    final eventMethod = EventChannelMethod.anchoredObjectQuery.name;
    final arguments = <String, dynamic>{
      'identifier': identifier,
      'eventMethod': eventMethod,
    };
    arguments.addAll(predicate.map);
    return _eventChannel.receiveBroadcastStream(arguments).listen((event) {
      final map = Map<String, dynamic>.from(event);
      if (map['event'] == eventMethod) {
        final list = List.from(map['result']);
        final samples = <Sample>[];
        for (final String element in list) {
          final json = jsonDecode(element);
          final sample = Sample.factory(json);
          samples.add(sample);
        }
        onUpdate(samples);
      }
    });
  }

  static StreamSubscription<dynamic> queryActivitySummaryUpdates(
      Predicate predicate,
      {Function(List<ActivitySummary>) onUpdate}) {
    final eventMethod = EventChannelMethod.queryActivitySummary.name;
    final arguments = <String, dynamic>{
      'eventMethod': eventMethod,
    };
    arguments.addAll(predicate.map);
    return _eventChannel.receiveBroadcastStream(arguments).listen((event) {
      final map = Map<String, dynamic>.from(event);
      if (map['event'] == eventMethod) {
        final List<dynamic> list = jsonDecode(map['result']);
        final activitySummaries = <ActivitySummary>[];
        for (final Map<String, dynamic> map in list) {
          final activitySummary = ActivitySummary.fromJson(map);
          activitySummaries.add(activitySummary);
        }
        onUpdate(activitySummaries);
      }
    });
  }

  static StreamSubscription<dynamic> statisticsCollectionQuery(
      QuantityType type,
      PreferredUnit unit,
      Predicate predicate,
      DateTime anchorDate,
      DateTime enumerateFrom,
      DateTime enumerateTo,
      DateComponents intervalComponents,
      {Function(Statistics) onUpdate}) {
    final eventMethod = EventChannelMethod.statisticsCollectionQuery.name;
    final arguments = {
      'identifier': type.identifier,
      'unit': unit.unit,
      'anchorTimestamp': anchorDate.millisecondsSinceEpoch,
      'enumerateFrom': enumerateFrom.millisecondsSinceEpoch,
      'enumerateTo': enumerateTo.millisecondsSinceEpoch,
      'eventMethod': eventMethod,
      'intervalComponents': intervalComponents.map,
    };
    arguments.addAll(predicate.map);
    return _eventChannel.receiveBroadcastStream(arguments).listen((event) {
      final map = Map<String, dynamic>.from(event);
      if (map['event'] == eventMethod) {
        final result = map['result'];
        final json = jsonDecode(result);
        final statistics = Statistics.fromJson(json);
        onUpdate(statistics);
      }
    });
  }

  static Future<bool> requestAuthorization(
      List<String> toRead, List<String> toWrite) async {
    final arguments = {
      'toRead': toRead,
      'toWrite': toWrite,
    };
    return await _methodChannel.invokeMethod('requestAuthorization', arguments);
  }

  static Future<List<PreferredUnit>> preferredUnits(
      List<QuantityType> types) async {
    final arguments = types.map((e) => e.identifier).toList();
    final result =
        await _methodChannel.invokeMethod('preferredUnits', arguments);
    final List<dynamic> list = jsonDecode(result);
    final preferredUnits = <PreferredUnit>[];
    for (final Map<String, dynamic> map in list) {
      final preferredUnit = PreferredUnit.fromJson(map);
      preferredUnits.add(preferredUnit);
    }
    return preferredUnits;
  }

  static Future<Characteristic> characteristicsQuery() async {
    final result = await _methodChannel.invokeMethod('characteristicsQuery');
    final Map<String, dynamic> map = jsonDecode(result);
    return Characteristic.fromJson(map);
  }

  static Future<List<Quantity>> quantityQuery(
      QuantityType type, PreferredUnit unit, Predicate predicate) async {
    final arguments = <String, dynamic>{
      'identifier': type.identifier,
      'unit': unit.unit,
    };
    arguments.addAll(predicate.map);
    final result =
        await _methodChannel.invokeMethod('quantityQuery', arguments);
    final List<dynamic> list = jsonDecode(result);
    final quantities = <Quantity>[];
    for (final Map<String, dynamic> map in list) {
      final quantity = Quantity.fromJson(map);
      quantities.add(quantity);
    }
    return quantities;
  }

  static Future<List<Category>> categoryQuery(
      CategoryType type, Predicate predicate) async {
    final arguments = <String, dynamic>{
      'identifier': type.identifier,
    };
    arguments.addAll(predicate.map);
    final result =
        await _methodChannel.invokeMethod('categoryQuery', arguments);
    final List<dynamic> list = jsonDecode(result);
    final categories = <Category>[];
    for (final Map<String, dynamic> map in list) {
      final category = Category.fromJson(map);
      categories.add(category);
    }
    return categories;
  }

  static Future<List<Workout>> workoutQuery(Predicate predicate) async {
    final result =
        await _methodChannel.invokeMethod('workoutQuery', predicate.map);
    final List<dynamic> list = jsonDecode(result);
    final workouts = <Workout>[];
    for (final Map<String, dynamic> map in list) {
      final workout = Workout.fromJson(map);
      workouts.add(workout);
    }
    return workouts;
  }

  static Future<List<Electrocardiogram>> electrocardiogramQuery(
      Predicate predicate) async {
    final result = await _methodChannel.invokeMethod(
        'electrocardiogramQuery', predicate.map);
    final List<dynamic> list = jsonDecode(result);
    final electrocardiograms = <Electrocardiogram>[];
    for (final Map<String, dynamic> map in list) {
      final electrocardiogram = Electrocardiogram.fromJson(map);
      electrocardiograms.add(electrocardiogram);
    }
    return electrocardiograms;
  }

  static Future<List<Sample>> sampleQuery(
      String identifier, Predicate predicate) async {
    final arguments = <String, dynamic>{
      'identifier': identifier,
    };
    arguments.addAll(predicate.map);
    final result = await _methodChannel.invokeMethod('sampleQuery', arguments);
    final list = List.from(result);
    final samples = <Sample>[];
    for (final String element in list) {
      final json = jsonDecode(element);
      final sample = Sample.factory(json);
      samples.add(sample);
    }
    return samples;
  }

  static Future<Statistics> statisticsQuery(
      QuantityType type, PreferredUnit unit, Predicate predicate) async {
    final arguments = <String, dynamic>{
      'identifier': type.identifier,
      'unit': unit.unit,
    };
    arguments.addAll(predicate.map);
    final result =
        await _methodChannel.invokeMethod('statisticsQuery', arguments);
    final Map<String, dynamic> map = jsonDecode(result);
    final statistics = Statistics.fromJson(map);
    return statistics;
  }

  static Future<HeartbeatSerie> heartbeatSeriesQuery(
      Predicate predicate) async {
    final result = await _methodChannel.invokeMethod(
        'heartbeatSeriesQuery', predicate.map);
    final Map<String, dynamic> map = jsonDecode(result);
    final heartbeatSerie = HeartbeatSerie.fromJson(map);
    return heartbeatSerie;
  }

  static Future<List<ActivitySummary>> queryActivitySummary(
      Predicate predicate) async {
    final arguments = <String, dynamic>{};
    arguments.addAll(predicate.map);
    final result =
        await _methodChannel.invokeMethod('queryActivitySummary', arguments);
    final List<dynamic> list = jsonDecode(result);
    final activitySummaries = <ActivitySummary>[];
    for (final Map<String, dynamic> map in list) {
      final activitySummary = ActivitySummary.fromJson(map);
      activitySummaries.add(activitySummary);
    }
    return activitySummaries;
  }

  static Future<bool> enableBackgroundDelivery(
      String identifier, UpdateFrequency frequency) async {
    final arguments = {
      'identifier': identifier,
      'frequency': frequency.value,
    };
    return await _methodChannel.invokeMethod(
        'enableBackgroundDelivery', arguments);
  }

  static Future<bool> disableAllBackgroundDelivery() async =>
      await _methodChannel.invokeMethod('disableAllBackgroundDelivery');

  static Future<bool> disableBackgroundDelivery(String identifier) async {
    final arguments = {
      'identifier': identifier,
    };
    return await _methodChannel.invokeMethod(
        'disableBackgroundDelivery', arguments);
  }

  static Future<String> sourceQuery(
      String identifier, Predicate predicate) async {
    final arguments = <String, dynamic>{
      'identifier': identifier,
    };
    arguments.addAll(predicate.map);
    return await _methodChannel.invokeMethod('sourceQuery', arguments);
  }

  static Future<String> correlationQuery(String identifier, Predicate predicate,
      Map<String, Predicate> typePredicates) async {
    final arguments = {
      'identifier': identifier,
      'typePredicates': typePredicates,
    };
    arguments.addAll(predicate.map);
    return await _methodChannel.invokeMethod('correlationQuery', arguments);
  }

  static Future<bool> startWatchApp(
          WorkoutConfiguration workoutConfiguration) async =>
      await _methodChannel.invokeMethod(
          'disableBackgroundDelivery', workoutConfiguration.map);

  static Future<bool> isAuthorizedToWrite(String identifier) async {
    final arguments = {
      'identifier': identifier,
    };
    return await _methodChannel.invokeMethod('isAuthorizedToWrite', arguments);
  }

  static Future<bool> addCategory(
      List<Category> categories, Device device, Workout workout) async {
    final arguments = {
      'categories': categories.map((e) => e.map),
      'device': device.map,
      'workout': workout.map,
    };
    return await _methodChannel.invokeMethod('addCategory', arguments);
  }

  static Future<bool> addQuantity(
      List<Quantity> quantities, Device device, Workout workout) async {
    final arguments = {
      'categories': quantities.map((e) => e.map),
      'device': device.map,
      'workout': workout.map,
    };
    return await _methodChannel.invokeMethod('addQuantity', arguments);
  }

  static Future<bool> delete(Sample sample) async {
    final arguments = {};
    if (sample is Quantity) {
      arguments['quantity'] = sample.map;
    }
    if (sample is Quantity) {
      arguments['category'] = sample.map;
    }
    if (sample is Quantity) {
      arguments['workout'] = sample.map;
    }
    return await _methodChannel.invokeMethod('delete', arguments);
  }

  static Future<bool> deleteObjects(
      String identifier, Predicate predicate) async {
    final arguments = <String, dynamic>{
      'identifier': identifier,
    };
    arguments.addAll(predicate.map);
    return await _methodChannel.invokeMethod('deleteObjects', arguments);
  }

  static Future<bool> save(Sample sample) async {
    final arguments = {};
    if (sample is Quantity) {
      arguments['quantity'] = sample.map;
    }
    if (sample is Quantity) {
      arguments['category'] = sample.map;
    }
    if (sample is Quantity) {
      arguments['workout'] = sample.map;
    }
    return await _methodChannel.invokeMethod('save', arguments);
  }
}
