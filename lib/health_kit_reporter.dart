import 'dart:async';
import 'dart:collection';
import 'dart:convert';

import 'package:flutter/services.dart';

import 'model/SampleQueryOptions.dart';
import 'model/payload/activity_summary.dart';
import 'model/payload/category.dart';
import 'model/payload/characteristic/characteristic.dart';
import 'model/payload/correlation.dart';
import 'model/payload/date_components.dart';
import 'model/payload/deleted_object.dart';
import 'model/payload/device.dart';
import 'model/payload/electrocardiogram.dart';
import 'model/payload/heartbeat_series.dart';
import 'model/payload/preferred_unit.dart';
import 'model/payload/quantity.dart';
import 'model/payload/sample.dart';
import 'model/payload/source.dart';
import 'model/payload/statistics.dart';
import 'model/payload/workout.dart';
import 'model/payload/workout_configuration.dart';
import 'model/payload/workout_route.dart';
import 'model/predicate.dart';
import 'model/type/activity_summary_type.dart';
import 'model/type/category_type.dart';
import 'model/type/characteristic_type.dart';
import 'model/type/correlation_type.dart';
import 'model/type/document_type.dart';
import 'model/type/electrocardiogram_type.dart';
import 'model/type/quantity_type.dart';
import 'model/type/series_type.dart';
import 'model/type/workout_type.dart';
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
/// Functions [enableBackgroundDelivery], [disableAllBackgroundDelivery], [disableBackgroundDelivery]
/// are preferred to use with [observerQuery] set up, since they allow
/// background notifications when data in [HealthKit] changes. This combination
/// will wake up your App in background and perform actions you specify when any data changes
/// in [HealthKit] depending on the provided [UpdateFrequency]. See [enableBackgroundDelivery].
///
/// See more about observer queries in https://developer.apple.com/documentation/healthkit/hkobserverquery
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

  /// [EventChannel] link to [SwiftHealthKitReporterPlugin.swift]
  /// Will invoke a bridge function of the plugin.
  ///
  static const EventChannel _observerQueryChannel =
      EventChannel('health_kit_reporter_event_channel_observer_query');

  /// [EventChannel] link to [SwiftHealthKitReporterPlugin.swift]
  /// Will handle event exchanges of the plugin.
  ///
  static const EventChannel _statisticsCollectionQueryChannel = EventChannel(
      'health_kit_reporter_event_channel_statistics_collection_query');

  /// [EventChannel] link to [SwiftHealthKitReporterPlugin.swift]
  /// Will handle event exchanges of the plugin.
  ///
  static const EventChannel _queryActivitySummaryChannel =
      EventChannel('health_kit_reporter_event_channel_query_activity_summary');

  /// [EventChannel] link to [SwiftHealthKitReporterPlugin.swift]
  /// Will handle event exchanges of the plugin.
  ///
  static const EventChannel _anchoredObjectQueryChannel =
      EventChannel('health_kit_reporter_event_channel_anchored_object_query');

  /// Sets subscription for data changes.
  /// Will call [onUpdate] callback, if
  /// there were changes regarding to the provided [identifier]
  /// inside [HealthKit].
  /// Provide the [predicate] to set the date interval.
  ///
  static StreamSubscription<dynamic> observerQuery(
      List<String> identifiers, Predicate? predicate,
      {required Function(String) onUpdate}) {
    final arguments = <String, dynamic>{
      'identifiers': identifiers,
    };
    if (predicate != null) {
      arguments.addAll(predicate.map);
    }
    return _observerQueryChannel
        .receiveBroadcastStream(arguments)
        .listen((event) {
      final map = Map<String, dynamic>.from(event);
      final identifier = map['identifier'];
      onUpdate(identifier);
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
      List<String> identifiers, Predicate predicate,
      {required Function(List<Sample>, List<DeletedObject>) onUpdate}) {
    final arguments = <String, dynamic>{
      'identifiers': identifiers,
    };
    arguments.addAll(predicate.map);
    return _anchoredObjectQueryChannel
        .receiveBroadcastStream(arguments)
        .listen((event) {
      final map = LinkedHashMap<String, dynamic>.from(event);
      final samplesList = List.from(map['samples']);
      final samples = <Sample>[];
      for (final String element in samplesList) {
        final json = jsonDecode(element);
        final sample = Sample.factory(json);
        if (sample != null) {
          samples.add(sample);
        }
      }
      final deletedObjectsList = List.from(map['deletedObjects']);
      final deletedObjects = <DeletedObject>[];
      for (final String element in deletedObjectsList) {
        final json = jsonDecode(element);
        final deletedObject = DeletedObject.fromJson(json);
        deletedObjects.add(deletedObject);
      }
      onUpdate(samples, deletedObjects);
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
      {required Function(List<ActivitySummary>) onUpdate}) {
    final arguments = predicate.map;
    return _queryActivitySummaryChannel
        .receiveBroadcastStream(arguments)
        .listen((event) {
      final List<dynamic> list = jsonDecode(event);
      final activitySummaries = <ActivitySummary>[];
      for (final Map<String, dynamic> map in list) {
        final activitySummary = ActivitySummary.fromJson(map);
        activitySummaries.add(activitySummary);
      }
      onUpdate(activitySummaries);
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
      List<PreferredUnit> preferredUnits,
      Predicate predicate,
      DateTime anchorDate,
      DateTime enumerateFrom,
      DateTime enumerateTo,
      DateComponents intervalComponents,
      {required Function(Statistics) onUpdate}) {
    final arguments = {
      'preferredUnits': preferredUnits.map((e) => e.map).toList(),
      'anchorTimestamp': anchorDate.millisecondsSinceEpoch,
      'enumerateFrom': enumerateFrom.millisecondsSinceEpoch,
      'enumerateTo': enumerateTo.millisecondsSinceEpoch,
      'intervalComponents': intervalComponents.map,
    };
    arguments.addAll(predicate.map);
    return _statisticsCollectionQueryChannel
        .receiveBroadcastStream(arguments)
        .listen((event) {
      final json = jsonDecode(event);
      final statistics = Statistics.fromJson(json);
      onUpdate(statistics);
    });
  }

  /// Verify whether HealthKit is available.
  static Future<bool> isAvailable() async {
    return await _methodChannel.invokeMethod('isAvailable');
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

  static Future<bool> requestClinicalRecordsAuthorization(
      List<String> toRead) async {
    final arguments = {
      'toRead': toRead,
      'toWrite': [],
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
  /// [Apple Health] app. Otherwise it will always return null.
  ///
  static Future<Characteristic> characteristicsQuery() async {
    final result = await _methodChannel.invokeMethod('characteristicsQuery');
    final Map<String, dynamic> map = jsonDecode(result);
    return Characteristic.fromJson(map);
  }

  /// Returns [HeartbeatSeries] sample for the provided time interval predicate [predicate].
  ///
  static Future<List<HeartbeatSeries>> heartbeatSeriesQuery(
      Predicate predicate) async {
    final arguments = predicate.map;
    final result =
        await _methodChannel.invokeMethod('heartbeatSeriesQuery', arguments);
    final List<dynamic> list = jsonDecode(result);
    final series = <HeartbeatSeries>[];
    for (final Map<String, dynamic> map in list) {
      final sample = HeartbeatSeries.fromJson(map);
      series.add(sample);
    }
    return series;
  }

  /// Returns [WorkoutRoute] sample for the provided time interval predicate [predicate].
  ///
  static Future<List<WorkoutRoute>> workoutRouteQuery(
      Predicate predicate) async {
    final arguments = predicate.map;
    final result =
        await _methodChannel.invokeMethod('workoutRouteQuery', arguments);
    final List<dynamic> list = jsonDecode(result);
    final routes = <WorkoutRoute>[];
    for (final Map<String, dynamic> map in list) {
      final sample = WorkoutRoute.fromJson(map);
      routes.add(sample);
    }
    return routes;
  }

  /// Returns [WorkoutRoute] sample for the provided UUID [predicate].
  ///
  /// Available only for iOS 13.0 and higher.
  ///
  static Future<List<WorkoutRoute>> workoutRouteForUUIDQuery(
    UUIDPredicate predicate,
  ) async {
    final arguments = predicate.map;
    final result = await _methodChannel.invokeMethod(
      'workoutRouteForUUIDQuery',
      arguments,
    );
    final List<dynamic> list = jsonDecode(result);
    final routes = <WorkoutRoute>[];
    for (final Map<String, dynamic> map in list) {
      final sample = WorkoutRoute.fromJson(map);
      routes.add(sample);
    }
    return routes;
  }

  /// Returns [Quantity] samples for the provided [type],
  /// the preferred [unit] and the time interval predicate [predicate].
  ///
  /// Warning: The [unit] should be valid. See [preferredUnits].
  ///
  static Future<List<Quantity>> quantityQuery(
      QuantityType type, String unit, Predicate predicate) async {
    final arguments = <String, dynamic>{
      'identifier': type.identifier,
      'unit': unit,
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

  /// Returns [Category] samples for the provided [type]
  /// and the time interval predicate [predicate].
  ///
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

  /// Returns [Workout] samples for the provided
  /// time interval predicate [predicate].
  /// [queryOption] parameter represents the options passable to the native HealthKit sample query
  static Future<List<Workout>> workoutQuery(Predicate predicate,
      {SampleQueryOption? queryOption}) async {
    var arguments = <String, dynamic>{};
    arguments.addAll(predicate.map);
    if (queryOption != null) {
      arguments["singleQueryOption"] = queryOption.value;
    }
    final result = await _methodChannel.invokeMethod('workoutQuery', arguments);
    final List<dynamic> list = jsonDecode(result);
    final workouts = <Workout>[];
    for (final Map<String, dynamic> map in list) {
      final workout = Workout.fromJson(map);
      workouts.add(workout);
    }
    return workouts;
  }

  /// Returns [Electrocardiogram] samples for the provided
  /// time interval predicate [predicate].
  ///
  static Future<List<Electrocardiogram>> electrocardiogramQuery(
      Predicate predicate,
      {bool withVoltageMeasurements = false}) async {
    final arguments = <String, dynamic>{
      'withVoltageMeasurements': withVoltageMeasurements,
    };
    arguments.addAll(predicate.map);
    final result =
        await _methodChannel.invokeMethod('electrocardiogramQuery', arguments);
    final List<dynamic> list = jsonDecode(result);
    final electrocardiograms = <Electrocardiogram>[];
    for (final Map<String, dynamic> map in list) {
      final electrocardiogram = Electrocardiogram.fromJson(map);
      electrocardiograms.add(electrocardiogram);
    }
    return electrocardiograms;
  }

  /// Returns [Sample] samples for the provided [identifier] and the
  /// time interval predicate [predicate].
  ///
  /// If [identifier] was recognized as one of [QuantityType], the
  /// units will be set automatically by original
  /// library [HealthKitReporter] according to SI.
  /// See https://cocoapods.org/pods/HealthKitReporter
  /// file [Extensions+HKQuantityType.swift]
  ///
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
      if (sample != null) {
        samples.add(sample);
      }
    }
    return samples;
  }

  /// Returns [Statistics] for the provided [type] and the,
  /// the preferred [unit] and the time interval predicate [predicate].
  ///
  /// Warning: The [unit] should be valid. See [preferredUnits].
  ///
  static Future<Statistics> statisticsQuery(
      QuantityType type, String unit, Predicate predicate) async {
    final arguments = <String, dynamic>{
      'identifier': type.identifier,
      'unit': unit,
    };
    arguments.addAll(predicate.map);
    final result =
        await _methodChannel.invokeMethod('statisticsQuery', arguments);
    final Map<String, dynamic> map = jsonDecode(result);
    final statistics = Statistics.fromJson(map);
    return statistics;
  }

  /// Returns [HeartbeatSerie] samples for the provided
  /// time interval predicate [predicate].
  ///
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

  /// Returns a status of calling native method for
  /// enabling background notifications about the data changing for the type
  /// with the [identifier].
  /// Set the [frequency] to get updates on specified time interval.
  ///
  /// Warning: not all the notifications can be provided
  /// by [HealthKit] on time you specify. For instance, if you provide
  /// [UpdateFrequency.immediate] for [QuantityType.stepCount] the
  /// notifications will happen hourly.
  /// Please see more here:
  /// https://developer.apple.com/documentation/healthkit/hkhealthstore/1614175-enablebackgrounddelivery
  ///
  static Future<bool> enableBackgroundDelivery(
      String identifier, UpdateFrequency frequency) async {
    final arguments = {
      'identifier': identifier,
      'frequency': frequency.value,
    };
    return await _methodChannel.invokeMethod(
        'enableBackgroundDelivery', arguments);
  }

  /// Disables all previous background notifications.
  ///
  static Future<bool> disableAllBackgroundDelivery() async =>
      await _methodChannel.invokeMethod('disableAllBackgroundDelivery');

  /// Disables specific background notifications for type with [identifier].
  ///
  static Future<bool> disableBackgroundDelivery(String identifier) async {
    final arguments = {
      'identifier': identifier,
    };
    return await _methodChannel.invokeMethod(
        'disableBackgroundDelivery', arguments);
  }

  /// Returns [Source] samples for the provided [identifier] and the
  /// time interval predicate [predicate].
  ///
  static Future<List<Source>> sourceQuery(
      String identifier, Predicate predicate) async {
    final arguments = <String, dynamic>{
      'identifier': identifier,
    };
    arguments.addAll(predicate.map);
    final result = await _methodChannel.invokeMethod('sourceQuery', arguments);
    final List<dynamic> list = jsonDecode(result);
    final sources = <Source>[];
    for (final Map<String, dynamic> map in list) {
      final source = Source.fromJson(map);
      sources.add(source);
    }
    return sources;
  }

  /// Returns [Correlation] samples for the provided [identifier], the
  /// time interval predicate [predicate] and optional [typePredicates] for
  /// [Category] and/or [Quantity] values.
  ///
  /// Warning: In order to use the correlations, you must be sure, that you have
  /// provided reading permissions for relevant [QuantityType].
  ///
  /// For instance, if you want to get the data for [CorrelationType.bloodPressure],
  /// you need to ask user to give read permissions for [QuantityType.bloodPressureDiastolic] and
  /// [QuantityType.bloodPressureSystolic]. Otherwise [HealthKit] will throw fatal error with
  /// message: "Authorization to read the following types is disallowed:
  /// HKCorrelationTypeIdentifierBloodPressure".
  ///
  static Future<List<Correlation>> correlationQuery(
      String identifier, Predicate predicate,
      {Map<String, Predicate>? typePredicates}) async {
    final arguments = {
      'identifier': identifier,
      'typePredicates': typePredicates,
    };
    arguments.addAll(predicate.map);
    final result =
        await _methodChannel.invokeMethod('correlationQuery', arguments);
    final List<dynamic> list = jsonDecode(result);
    final correlations = <Correlation>[];
    for (final Map<String, dynamic> map in list) {
      final correlation = Correlation.fromJson(map);
      correlations.add(correlation);
    }
    return correlations;
  }

  /// Returns status of the App on WatchOS device.
  /// Expects [workoutConfiguration] as the main parameter.
  ///
  static Future<bool> startWatchApp(
          WorkoutConfiguration workoutConfiguration) async =>
      await _methodChannel.invokeMethod(
          'startWatchApp', workoutConfiguration.map);

  /// Checks if the provided type with [identifier] is
  /// allowed for writing in [HealthKit].
  ///
  static Future<bool> isAuthorizedToWrite(String identifier) async {
    final arguments = {
      'identifier': identifier,
    };
    return await _methodChannel.invokeMethod('isAuthorizedToWrite', arguments);
  }

  /// Adds [Category] samples to your [workout].
  /// [device] is optional.
  ///
  static Future<bool> addCategory(List<Category> categories, Workout workout,
      {Device? device}) async {
    final arguments = {
      'categories': categories.map((e) => e.map).toList(),
      'workout': workout.map,
    };
    if (device != null) arguments['device'] = device.map;
    return await _methodChannel.invokeMethod('addCategory', arguments);
  }

  /// Adds [Quantity] samples to your [workout].
  /// [device] is optional.
  ///
  static Future<bool> addQuantity(List<Quantity> quantities, Workout workout,
      {Device? device}) async {
    final arguments = {
      'quantities': quantities.map((e) => e.map).toList(),
      'workout': workout.map,
    };
    if (device != null) arguments['device'] = device.map;
    return await _methodChannel.invokeMethod('addQuantity', arguments);
  }

  /// Deletes [Sample] from [HealthKit].
  ///
  static Future<bool> delete(Sample sample) async {
    final arguments = sample.parsed();
    return await _methodChannel.invokeMethod('delete', arguments);
  }

  /// Deletes all objects related to [identifier] with [predicate].
  ///
  static Future<dynamic> deleteObjects(
      String identifier, Predicate predicate) async {
    final arguments = <String, dynamic>{
      'identifier': identifier,
    };
    arguments.addAll(predicate.map);
    return await _methodChannel.invokeMethod('deleteObjects', arguments);
  }

  /// Saves [Sample] in [HealthKit].
  ///
  static Future<bool> save(Sample sample) async {
    final arguments = sample.parsed();
    return await _methodChannel.invokeMethod('save', arguments);
  }
}
