import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:health_kit_reporter/model/payload/characteristic/characteristic.dart';
import 'package:health_kit_reporter/model/type/category_type.dart';
import 'package:health_kit_reporter/model/type/quantity_type.dart';

import 'model/payload/category.dart';
import 'model/payload/device.dart';
import 'model/payload/preferred_unit.dart';
import 'model/payload/quantity.dart';
import 'model/payload/sample.dart';
import 'model/payload/workout.dart';
import 'model/payload/workout_configuration.dart';
import 'model/predicate.dart';
import 'model/update_frequency.dart';

class HealthKitReporter {
  static const MethodChannel _channel = MethodChannel('health_kit_reporter');

  static Future<bool> requestAuthorization(
      List<String> toRead, List<String> toWrite) async {
    final arguments = {
      'toRead': toRead,
      'toWrite': toWrite,
    };
    return await _channel.invokeMethod('requestAuthorization', arguments);
  }

  static Future<List<PreferredUnit>> preferredUnits(
      List<QuantityType> types) async {
    final arguments = types.map((e) => e.identifier).toList();
    final result = await _channel.invokeMethod('preferredUnits', arguments);
    final List<dynamic> list = jsonDecode(result);
    final preferredUnits = <PreferredUnit>[];
    for (final Map<String, dynamic> map in list) {
      final preferredUnit = PreferredUnit.fromJson(map);
      preferredUnits.add(preferredUnit);
    }
    return preferredUnits;
  }

  static Future<Characteristic> characteristicsQuery() async {
    final result = await _channel.invokeMethod('characteristicsQuery');
    final Map<String, dynamic> map = jsonDecode(result);
    return Characteristic.fromJson(map);
  }

  static Future<List<Quantity>> quantityQuery(
      QuantityType type, String unit, Predicate predicate) async {
    final arguments = {
      'identifier': type.identifier,
      'unit': unit,
    };
    arguments.addAll(predicate.map);
    final result = await _channel.invokeMethod('quantityQuery', arguments);
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
    final arguments = {
      'identifier': type.identifier,
    };
    arguments.addAll(predicate.map);
    final result = await _channel.invokeMethod('categoryQuery', arguments);
    final List<dynamic> list = jsonDecode(result);
    final categories = <Category>[];
    for (final Map<String, dynamic> map in list) {
      final category = Category.fromJson(map);
      categories.add(category);
    }
    return categories;
  }

  static Future<List<Workout>> workoutQuery(Predicate predicate) async {
    final result = await _channel.invokeMethod('workoutQuery', predicate.map);
    final List<dynamic> list = jsonDecode(result);
    final workouts = <Workout>[];
    for (final Map<String, dynamic> map in list) {
      final workout = Workout.fromJson(map);
      workouts.add(workout);
    }
    return workouts;
  }

  static Future<String> electrocardiogramQuery(Predicate predicate) async {
    final result =
        await _channel.invokeMethod('electrocardiogramQuery', predicate.map);
  }

  static Future<List<Sample>> sampleQuery(
      String identifier, Predicate predicate) async {
    final arguments = {
      'identifier': identifier,
    };
    arguments.addAll(predicate.map);
    final result = await _channel.invokeMethod('sampleQuery', arguments);
    final List<dynamic> list = jsonDecode(result);
    final samples = <Sample>[];
    for (final Map<String, dynamic> map in list) {
      final sample = Sample.factory(map);
      samples.add(sample);
    }
    return samples;
  }

  static Future<String> statisticsQuery(
      String identifier, String unit, Predicate predicate) async {
    final arguments = {
      'identifier': identifier,
      'unit': unit,
    };
    arguments.addAll(predicate.map);
    return await _channel.invokeMethod('sampleQuery', arguments);
  }

  static Future<String> statisticsCollectionQuery(
      String identifier,
      String unit,
      Predicate predicate,
      DateTime anchorDate,
      DateTime enumerateFrom,
      DateTime enumerateTo) async {
    final arguments = {
      'identifier': identifier,
      'unit': unit,
      'anchorDate': anchorDate.toIso8601String(),
      'enumerateFrom': enumerateFrom.toIso8601String(),
      'enumerateTo': enumerateTo.toIso8601String()
    };
    arguments.addAll(predicate.map);
    return await _channel.invokeMethod('statisticsCollectionQuery', arguments);
  }

  static Future<String> heartbeatSeriesQuery(Predicate predicate) async =>
      await _channel.invokeMethod('heartbeatSeriesQuery', predicate.map);

  static Future<String> queryActivitySummary(Predicate predicate,
      {bool monitorUpdates = false}) async {
    final arguments = <String, dynamic>{};
    arguments.addAll(predicate.map);
    arguments['monitorUpdates'] = monitorUpdates;
    return await _channel.invokeMethod('queryActivitySummary', arguments);
  }

  static Future<List<String>> anchoredObjectQuery(
      String identifier, Predicate predicate,
      {bool monitorUpdates = false}) async {
    final arguments = {
      'identifier': identifier,
      'monitorUpdates': monitorUpdates
    };
    arguments.addAll(predicate.map);
    return await _channel.invokeMethod('anchoredObjectQuery', arguments);
  }

  static Future<String> sourceQuery(
      String identifier, Predicate predicate) async {
    final arguments = {
      'identifier': identifier,
    };
    arguments.addAll(predicate.map);
    return await _channel.invokeMethod('sourceQuery', arguments);
  }

  static Future<String> correlationQuery(String identifier, Predicate predicate,
      Map<String, Predicate> typePredicates) async {
    final arguments = {
      'identifier': identifier,
      'typePredicates': typePredicates,
    };
    arguments.addAll(predicate.map);
    return await _channel.invokeMethod('correlationQuery', arguments);
  }

  static Future<String> observerQuery(
      String identifier, Predicate predicate) async {
    final arguments = {
      'identifier': identifier,
    };
    arguments.addAll(predicate.map);
    return await _channel.invokeMethod('observerQuery', arguments);
  }

  static Future<bool> enableBackgroundDelivery(
      String identifier, UpdateFrequency frequency) async {
    final arguments = {
      'identifier': identifier,
      'frequency': frequency.value,
    };
    return await _channel.invokeMethod('enableBackgroundDelivery', arguments);
  }

  static Future<bool> disableAllBackgroundDelivery() async =>
      await _channel.invokeMethod('disableAllBackgroundDelivery');

  static Future<bool> disableBackgroundDelivery(String identifier) async {
    final arguments = {
      'identifier': identifier,
    };
    return await _channel.invokeMethod('disableBackgroundDelivery', arguments);
  }

  static Future<bool> startWatchApp(
          WorkoutConfiguration workoutConfiguration) async =>
      await _channel.invokeMethod(
          'disableBackgroundDelivery', workoutConfiguration.map);

  static Future<bool> isAuthorizedToWrite(String identifier) async {
    final arguments = {
      'identifier': identifier,
    };
    return await _channel.invokeMethod('isAuthorizedToWrite', arguments);
  }

  static Future<bool> addCategory(
      List<Category> categories, Device device, Workout workout) async {
    final arguments = {
      'categories': categories.map((e) => e.map),
      'device': device.map,
      'workout': workout.map,
    };
    return await _channel.invokeMethod('addCategory', arguments);
  }

  static Future<bool> addQuantity(
      List<Quantity> quantities, Device device, Workout workout) async {
    final arguments = {
      'categories': quantities.map((e) => e.map),
      'device': device.map,
      'workout': workout.map,
    };
    return await _channel.invokeMethod('addQuantity', arguments);
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
    return await _channel.invokeMethod('delete', arguments);
  }

  static Future<bool> deleteObjects(
      String identifier, Predicate predicate) async {
    final arguments = {
      'identifier': identifier,
    };
    arguments.addAll(predicate.map);
    return await _channel.invokeMethod('deleteObjects', arguments);
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
    return await _channel.invokeMethod('save', arguments);
  }
}
