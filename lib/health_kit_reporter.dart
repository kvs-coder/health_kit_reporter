import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:health_kit_reporter/model/event_channel_method.dart';
import 'package:health_kit_reporter/model/payload/activity_summary.dart';
import 'package:health_kit_reporter/model/payload/characteristic/characteristic.dart';
import 'package:health_kit_reporter/model/payload/electrocardiogram.dart';
import 'package:health_kit_reporter/model/payload/heartbeat_serie.dart';
import 'package:health_kit_reporter/model/payload/statistics.dart';
import 'package:health_kit_reporter/model/type/activity_summary_type.dart';
import 'package:health_kit_reporter/model/type/category_type.dart';
import 'package:health_kit_reporter/model/type/characteristic_type.dart';
import 'package:health_kit_reporter/model/type/correlation_type.dart';
import 'package:health_kit_reporter/model/type/document_type.dart';
import 'package:health_kit_reporter/model/type/electrocardiogram_type.dart';
import 'package:health_kit_reporter/model/type/quantity_type.dart';
import 'package:health_kit_reporter/model/type/series_type.dart';
import 'package:health_kit_reporter/model/type/workout_type.dart';

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

/// [HealthKitReporter] class.
/// Invokes calls to native side. Channel: [health_kit_reporter_method_channel]
/// For reading data, all responses are provided as JSON based payloads.
///
/// The list of Platform methods:
/// - [requestAuthorization]
/// - [preferredUnits]
/// - [characteristicsQuery]
/// - [quantityQuery]
/// - [categoryQuery]
/// - [workoutQuery]
/// - [electrocardiogramQuery]
/// - [sampleQuery]
/// - [statisticsQuery]
/// - [heartbeatSeriesQuery]
/// - [queryActivitySummary]
/// - [enableBackgroundDelivery]
/// - [disableAllBackgroundDelivery]
/// - [disableBackgroundDelivery]
/// - [sourceQuery]
/// - [correlationQuery]
/// - [startWatchApp]
/// - [isAuthorizedToWrite]
/// - [addCategory]
/// - [addQuantity]
/// - [delete]
/// - [deleteObjects]
/// - [save]
///
/// Every call to [HealthKit] with a read request should be accompanies with [requestAuthorization]
/// method. Without permissions, [HealthKit] will not allow you to read or write the data.
/// Not all of the types are allowed to be written in [HealthKit].
/// Please see https://developer.apple.com/documentation/healthkit
/// The [Quantity] type is a type which will provide quantity values with an appropriate unit.
/// Call [preferredUnits] to see which [PreferredUnit] is used for the [Quantity]. With invalid unit
/// the [quantityQuery], [statisticsQuery] will fail to retrieve the data.
///
/// The method [electrocardiogramQuery] requires iOS 14.0 and higher.
/// The method [heartbeatSeriesQuery] requires iOS 13.0 and higher.
///
///
/// Receives events from native side. Channel: [health_kit_reporter_event_channel]
/// For all stream events, all responses are provided as JSON based payloads.
///
/// The list of Platform events:
/// - [observerQuery]
/// - [anchoredObjectQuery]
/// - [queryActivitySummaryUpdates]
/// - [statisticsCollectionQuery]
///
/// Call the listed methods above to maintain the stream events from the native side.
/// The workflow:
/// 1. Function is called in you Flutter app on the Flutter side with Dart.
/// 2. The registration callback [onListen] is triggered on iOS Side. See [HealthKitReporterStreamHandler.swift]
/// 3. When the appropriate event is detected, the [FlutterEventSink] will sink the event.
/// 4. The new event will be handled in [listen] callback of the received broadcast stream
/// 5. After handling, the mapped event will be transferred as a ready result in the function's callback [onUpdate]
///
/// This workflow allows you not to call methods on native side in [AppDelegate.swift]
///
/// Please do not keep active multiple event streams, only one at once.
///
class HealthKitReporter {
  /// [MethodChannel] link to [SwiftHealthKitReporterPlugin.swift]
  /// Will invoke a bridge function of the plugin.
  ///
  static const MethodChannel _methodChannel =
      MethodChannel('health_kit_reporter_method_channel');

  /// [EventChannel] link to [HealthKitReporterStreamHandler.swift]
  /// Will handle events coming from the native side.
  ///
  static const EventChannel _eventChannel =
      EventChannel('health_kit_reporter_event_channel');

  /// Sets subscription for data changes.
  /// Will call [onUpdate] callback, if
  /// there were changes regarding to the provided [identifier]
  /// inside [HealthKit].
  /// Provide the [predicate] to set the date interval.
  ///
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

  /// Will fetch the actual values as a first data snapshot
  /// and notify about data changes.
  /// Will call [onUpdate] callback, if
  /// there were changes regarding to the provided [identifier]
  /// inside [HealthKit].
  /// Provide the [predicate] to set the date interval.
  ///
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

  /// Will fetch the actual values as a first data snapshot
  /// and notify about data changes.
  /// Will call [onUpdate] callback, if activity summaries
  /// have been changed.
  /// inside [HealthKit]
  /// Provide the [predicate] to set the date interval.
  ///
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

  /// Will fetch the actual values as a first data snapshot
  /// and will provide a numerous enumerations as soon as they are ready.
  /// Will call [onUpdate] callback, if
  /// there were changes regarding to the provided [type]
  /// inside [HealthKit]
  /// Provide the [predicate] to set the date interval.
  /// Provide the [unit] for the type. See [preferredUnits].
  /// Provide the [anchorDate] as a starting point.
  /// Set the time interval with [enumerateFrom] and [enumerateTo] accordingly.
  /// Set the grouping by [intervalComponents]
  ///
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

  /// Request write/read access to various [HealthKit] types.
  /// Provide [toRead] and/or [toWrite].
  /// If you want only read data, please set [toWrite] as an empty array.
  /// Types you can work with are grouped as Enums:
  /// - [ActivitySummaryType]
  /// - [CategoryType]
  /// - [CharacteristicType]
  /// - [CorrelationType]
  /// - [DocumentType]
  /// - [ElectrocardiogramType]
  /// - [QuantityType]
  /// - [SeriesType]
  /// - [WorkoutType]
  ///
  static Future<bool> requestAuthorization(
      List<String> toRead, List<String> toWrite) async {
    final arguments = {
      'toRead': toRead,
      'toWrite': toWrite,
    };
    return await _methodChannel.invokeMethod('requestAuthorization', arguments);
  }

  /// Returns preferred units for provided [types].
  /// Usage is only for [QuantityType]
  ///
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

  /// Returns [Characteristic] info.
  ///
  /// Warning: The characteristics should be set manually by the user inside
  /// [Apple Health] app.
  /// Otherwise it will always return null.
  ///
  static Future<Characteristic> characteristicsQuery() async {
    final result = await _methodChannel.invokeMethod('characteristicsQuery');
    final Map<String, dynamic> map = jsonDecode(result);
    return Characteristic.fromJson(map);
  }

  /// Returns [Quantity] samples for provided [type],
  /// preferred [unit] and time interval predicate [predicate].
  ///
  /// Warning: The [unit] should be valid. See [preferredUnits].
  ///
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
