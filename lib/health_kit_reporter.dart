import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';

import 'model/sample_query_option.dart';
import 'model/payload/activity_summary.dart';
import 'model/payload/category.dart';
import 'model/payload/clinical_record.dart';
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
import 'model/payload/vision_prescription.dart';
import 'model/payload/workout_effort_relationship.dart';
import 'model/payload/workout_route.dart';
import 'model/predicate.dart';
import 'model/type/activity_summary_type.dart';
import 'model/type/category_type.dart';
import 'model/type/characteristic_type.dart';
import 'model/type/clinical_type.dart';
import 'model/type/correlation_type.dart';
import 'model/type/document_type.dart';
import 'model/type/electrocardiogram_type.dart';
import 'model/type/quantity_type.dart';
import 'model/type/series_type.dart';
import 'model/type/vision_prescription_type.dart';
import 'model/type/workout_type.dart';
import 'model/update_frequency.dart';

/// [HealthKitReporter] class.
/// Invokes calls to native side. Channel: [health_kit_reporter_method_channel]
/// For reading data, all responses are provided as JSON based payloads.
///
/// The list of Platform methods:
/// - [requestAuthorization]
/// - [requestClinicalRecordsAuthorization]
/// - [requestPerObjectReadAuthorization]
/// - [supportsHealthRecords]
/// - [isWritable]
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
/// - [clinicalRecordQuery]
/// - [visionPrescriptionQuery]
/// - [workoutEffortRelationshipQuery]
/// - [startWatchApp]
/// - [isAuthorizedToWrite]
/// - [addCategory]
/// - [addQuantity]
/// - [relateWorkoutEffort]
/// - [unrelateWorkoutEffort]
/// - [delete]
/// - [deleteSamples]
/// - [deleteObjects]
/// - [save]
/// - [saveSamples]
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
/// The plugin requires iOS 15.0 and higher.
/// [visionPrescriptionQuery] and [requestPerObjectReadAuthorization] require iOS 16.0,
/// [workoutEffortRelationshipQuery], [relateWorkoutEffort] and [unrelateWorkoutEffort] iOS 18.0.
///
/// Errors arrive as [PlatformException]s whose message is the native error's
/// localized description.
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
      {required Function(String) onUpdate, Function? onError}) {
    final arguments = <String, dynamic>{
      'identifiers': identifiers,
    };
    if (predicate != null) {
      arguments.addAll(predicate.map);
    }
    return _observerQueryChannel.receiveBroadcastStream(arguments).listen(
        (event) {
      final map = Map<String, dynamic>.from(event);
      final identifier = map['identifier'];
      onUpdate(identifier);
    }, onError: onError);
  }

  /// Will fetch the actual values as a first data snapshot
  /// and notify about data changes.
  /// Will call [onUpdate] callback, if
  /// there were changes regarding to the provided [identifiers]
  /// inside [HealthKit].
  /// Provide the [predicate] to set the date interval.
  ///
  /// [onUpdate] receives the new [anchor] as a base64 string with every update.
  /// Persist it and pass it as [anchor] to the next query to receive only
  /// the changes since; without [anchor] the query starts from the beginning.
  /// Deleted objects carry only their uuid, so match it against the samples you keep.
  ///
  static StreamSubscription<dynamic> anchoredObjectQuery(
      List<String> identifiers, Predicate? predicate,
      {String? anchor,
      required Function(List<Sample> samples,
              List<DeletedObject> deletedObjects, String? anchor)
          onUpdate,
      Function? onError}) {
    final arguments = <String, dynamic>{
      'identifiers': identifiers,
    };
    if (predicate != null) {
      arguments.addAll(predicate.map);
    }
    if (anchor != null) {
      arguments['anchor'] = anchor;
    }
    return _anchoredObjectQueryChannel.receiveBroadcastStream(arguments).listen(
        (event) {
      final map = Map<String, dynamic>.from(event);
      final samples = <Sample>[];
      for (final String element in List.from(map['samples'])) {
        final sample = Sample.factory(jsonDecode(element));
        if (sample != null) {
          samples.add(sample);
        }
      }
      final deletedObjects = <DeletedObject>[
        for (final String element in List.from(map['deletedObjects']))
          DeletedObject.fromJson(jsonDecode(element))
      ];
      onUpdate(samples, deletedObjects, map['anchor']);
    }, onError: onError);
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
      {required Function(List<ActivitySummary>) onUpdate,
      Function? onError}) {
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
    }, onError: onError);
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
      {required Function(Statistics) onUpdate,
      bool separateBySource = false,
      Function? onError}) {
    final arguments = {
      'preferredUnits': preferredUnits.map((e) => e.map).toList(),
      'anchorTimestamp': anchorDate.millisecondsSinceEpoch,
      'enumerateFrom': enumerateFrom.millisecondsSinceEpoch,
      'enumerateTo': enumerateTo.millisecondsSinceEpoch,
      'intervalComponents': intervalComponents.map,
      'separateBySource': separateBySource,
    };
    arguments.addAll(predicate.map);
    return _statisticsCollectionQueryChannel
        .receiveBroadcastStream(arguments)
        .listen((event) {
      final json = jsonDecode(event);
      final statistics = Statistics.fromJson(json);
      onUpdate(statistics);
    }, onError: onError);
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
  /// - [DocumentType]
  /// - [ElectrocardiogramType]
  /// - [QuantityType]
  /// - [SeriesType]
  /// - [WorkoutType]
  ///
  /// Only types whose [isWritable] is true can be requested for writing.
  /// Correlations ([CorrelationType]) and per-object types
  /// ([VisionPrescriptionType], see [requestPerObjectReadAuthorization])
  /// can't be requested at all. For all of these the call fails with
  /// a [PlatformException] instead of [HealthKit] crashing the app.
  /// Request clinical records with [requestClinicalRecordsAuthorization].
  ///
  static Future<bool> requestAuthorization(
      List<String> toRead, List<String> toWrite) async {
    final arguments = {
      'toRead': toRead,
      'toWrite': toWrite,
    };
    return await _methodChannel.invokeMethod('requestAuthorization', arguments);
  }

  /// Request read access to clinical records ([ClinicalType] identifiers).
  ///
  /// Call it apart from [requestAuthorization]: it starts Health's records flow,
  /// which needs an Apple Account and the Clinical Health Records entitlement.
  /// Check [supportsHealthRecords] first.
  ///
  static Future<bool> requestClinicalRecordsAuthorization(
      List<String> toRead) async {
    final arguments = {
      'toRead': toRead,
      'toWrite': <String>[],
    };
    return await _methodChannel.invokeMethod('requestAuthorization', arguments);
  }

  /// Asks the user which objects of a per-object authorization type the app may read,
  /// e.g. [VisionPrescriptionType.visionPrescription]. Requires iOS 16.
  /// [predicate] narrows the objects offered.
  ///
  static Future<bool> requestPerObjectReadAuthorization(String identifier,
      {Predicate? predicate}) async {
    final arguments = <String, dynamic>{
      'identifier': identifier,
    };
    if (predicate != null) arguments.addAll(predicate.map);
    return await _methodChannel.invokeMethod(
        'requestPerObjectReadAuthorization', arguments);
  }

  /// Tells whether the device supports clinical health records.
  ///
  static Future<bool> supportsHealthRecords() async =>
      await _methodChannel.invokeMethod('supportsHealthRecords');

  /// Whether an app may request write access to the type with [identifier].
  /// False for types [HealthKit] only computes or records itself
  /// (e.g. [QuantityType.appleExerciseTime], ECGs), clinical records and correlations.
  /// Use it to build the write set of [requestAuthorization].
  ///
  static Future<bool> isWritable(String identifier) async {
    final arguments = {
      'identifier': identifier,
    };
    return await _methodChannel.invokeMethod('isWritable', arguments);
  }

  /// Returns preferred units for provided [types].
  /// Usage is only for [QuantityType]
  ///
  static Future<List<PreferredUnit>> preferredUnits(
      List<QuantityType> types) async {
    final arguments = {
      'identifiers': types.map((e) => e.identifier).toList(),
    };
    final result =
        await _methodChannel.invokeMethod('preferredUnits', arguments);
    final List<dynamic> list = jsonDecode(result);
    return list.map((e) => PreferredUnit.fromJson(e)).toList();
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
    final result = await _methodChannel.invokeMethod(
        'heartbeatSeriesQuery', predicate.map);
    final List<dynamic> list = jsonDecode(result);
    return list.map((e) => HeartbeatSeries.fromJson(e)).toList();
  }

  /// Returns [WorkoutRoute] sample for the provided time interval predicate [predicate].
  ///
  static Future<List<WorkoutRoute>> workoutRouteQuery(
      Predicate predicate) async {
    final result =
        await _methodChannel.invokeMethod('workoutRouteQuery', predicate.map);
    final List<dynamic> list = jsonDecode(result);
    return list.map((e) => WorkoutRoute.fromJson(e)).toList();
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
    return list.map((e) => Quantity.fromJson(e)).toList();
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
    return list.map((e) => Category.fromJson(e)).toList();
  }

  /// Returns [Workout] samples for the provided
  /// time interval predicate [predicate].
  /// [queryOption] tells whether the workouts must start and/or end inside
  /// the interval; both by default.
  ///
  static Future<List<Workout>> workoutQuery(Predicate predicate,
      {SampleQueryOption? queryOption}) async {
    final arguments = <String, dynamic>{};
    arguments.addAll(predicate.map);
    if (queryOption != null) {
      arguments['predicateOptions'] = queryOption.value;
    }
    final result = await _methodChannel.invokeMethod('workoutQuery', arguments);
    final List<dynamic> list = jsonDecode(result);
    return list.map((e) => Workout.fromJson(e)).toList();
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
    return list.map((e) => Electrocardiogram.fromJson(e)).toList();
  }

  /// Returns [Sample] samples for the provided [identifier] and the
  /// time interval predicate [predicate].
  ///
  /// If [identifier] was recognized as one of [QuantityType], the
  /// units will be set automatically by original
  /// library [HealthKitReporter] according to SI.
  ///
  static Future<List<Sample>> sampleQuery(
      String identifier, Predicate predicate) async {
    final arguments = <String, dynamic>{
      'identifier': identifier,
    };
    arguments.addAll(predicate.map);
    final result = await _methodChannel.invokeMethod('sampleQuery', arguments);
    final samples = <Sample>[];
    for (final String element in List.from(result)) {
      final sample = Sample.factory(jsonDecode(element));
      if (sample != null) {
        samples.add(sample);
      }
    }
    return samples;
  }

  /// Returns [Statistics] for the provided [type] and the,
  /// the preferred [unit] and the time interval predicate [predicate].
  /// With [separateBySource] the result also holds
  /// [Statistics.sourceStatistics], the values per source.
  ///
  /// Warning: The [unit] should be valid. See [preferredUnits].
  ///
  static Future<Statistics> statisticsQuery(
      QuantityType type, String unit, Predicate predicate,
      {bool separateBySource = false}) async {
    final arguments = <String, dynamic>{
      'identifier': type.identifier,
      'unit': unit,
      'separateBySource': separateBySource,
    };
    arguments.addAll(predicate.map);
    final result =
        await _methodChannel.invokeMethod('statisticsQuery', arguments);
    return Statistics.fromJson(jsonDecode(result));
  }

  /// Returns [ActivitySummary] samples for the days
  /// of the time interval predicate [predicate].
  ///
  static Future<List<ActivitySummary>> queryActivitySummary(
      Predicate predicate) async {
    final result = await _methodChannel.invokeMethod(
        'queryActivitySummary', predicate.map);
    final List<dynamic> list = jsonDecode(result);
    return list.map((e) => ActivitySummary.fromJson(e)).toList();
  }

  /// Returns [ClinicalRecord] samples of [type],
  /// optionally narrowed by the time interval predicate [predicate].
  ///
  /// Requires the Clinical Health Records entitlement,
  /// [supportsHealthRecords] and [requestClinicalRecordsAuthorization].
  ///
  static Future<List<ClinicalRecord>> clinicalRecordQuery(ClinicalType type,
      {Predicate? predicate}) async {
    final arguments = <String, dynamic>{
      'identifier': type.identifier,
    };
    if (predicate != null) arguments.addAll(predicate.map);
    final result =
        await _methodChannel.invokeMethod('clinicalRecordQuery', arguments);
    final List<dynamic> list = jsonDecode(result);
    return list.map((e) => ClinicalRecord.fromJson(e)).toList();
  }

  /// Returns [VisionPrescription] samples,
  /// optionally narrowed by the time interval predicate [predicate]. Requires iOS 16.
  ///
  /// Requires per-object read authorization, see [requestPerObjectReadAuthorization]
  /// with [VisionPrescriptionType.visionPrescription].
  ///
  static Future<List<VisionPrescription>> visionPrescriptionQuery(
      {Predicate? predicate}) async {
    final result = await _methodChannel.invokeMethod(
        'visionPrescriptionQuery', predicate?.map ?? <String, dynamic>{});
    return VisionPrescription.collect(jsonDecode(result));
  }

  /// Returns the workout effort score samples related to workouts
  /// whose dates match [predicate]. Requires iOS 18.
  ///
  /// Pass the [anchor] of the previous result to receive only the changes since;
  /// [mostRelevant] returns only the most relevant effort sample per workout.
  ///
  static Future<WorkoutEffortRelationshipResult> workoutEffortRelationshipQuery(
      {Predicate? predicate, String? anchor, bool mostRelevant = false}) async {
    final arguments = <String, dynamic>{
      'mostRelevant': mostRelevant,
    };
    if (predicate != null) arguments.addAll(predicate.map);
    if (anchor != null) arguments['anchor'] = anchor;
    final result = Map<String, dynamic>.from(await _methodChannel.invokeMethod(
        'workoutEffortRelationshipQuery', arguments));
    return WorkoutEffortRelationshipResult(
      WorkoutEffortRelationship.collect(jsonDecode(result['relationships'])),
      result['anchor'],
    );
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
    return list.map((e) => Source.fromJson(e)).toList();
  }

  /// Returns [Correlation] samples for the provided [identifier], the
  /// time interval predicate [predicate] and optional [typePredicates] for
  /// [Category] and/or [Quantity] values, keyed by their identifiers.
  ///
  /// Warning: In order to use the correlations, you must be sure, that you have
  /// provided reading permissions for relevant [QuantityType].
  ///
  /// For instance, if you want to get the data for [CorrelationType.bloodPressure],
  /// you need to ask user to give read permissions for [QuantityType.bloodPressureDiastolic] and
  /// [QuantityType.bloodPressureSystolic].
  ///
  static Future<List<Correlation>> correlationQuery(
      String identifier, Predicate predicate,
      {Map<String, Predicate>? typePredicates}) async {
    final arguments = <String, dynamic>{
      'identifier': identifier,
    };
    if (typePredicates != null) {
      arguments['typePredicates'] =
          typePredicates.map((key, value) => MapEntry(key, value.map));
    }
    arguments.addAll(predicate.map);
    final result =
        await _methodChannel.invokeMethod('correlationQuery', arguments);
    final List<dynamic> list = jsonDecode(result);
    return list.map((e) => Correlation.fromJson(e)).toList();
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

  /// Adds new [Category] samples to a [workout] stored in [HealthKit],
  /// looked up by its [Workout.uuid].
  /// [device] is optional and replaces the device of every sample.
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

  /// Adds new [Quantity] samples to a [workout] stored in [HealthKit],
  /// looked up by its [Workout.uuid].
  /// [device] is optional and replaces the device of every sample.
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

  /// Relates a workout effort score or estimated workout effort score [sample]
  /// to the stored workout with [workoutUUID], or to one of its activities
  /// with [activityUUID]. Requires iOS 18.
  ///
  /// A [sample] already stored in [HealthKit] (found by its uuid) is related as is,
  /// otherwise it is saved first.
  ///
  static Future<bool> relateWorkoutEffort(Quantity sample, String workoutUUID,
      {String? activityUUID}) async {
    final arguments = <String, dynamic>{
      'sample': sample.map,
      'workoutUUID': workoutUUID,
    };
    if (activityUUID != null) arguments['activityUUID'] = activityUUID;
    return await _methodChannel.invokeMethod('relateWorkoutEffort', arguments);
  }

  /// Removes the relation between the stored effort score [sample],
  /// looked up by its uuid, and the stored workout with [workoutUUID]
  /// (or one of its activities with [activityUUID]). Requires iOS 18.
  ///
  static Future<bool> unrelateWorkoutEffort(Quantity sample, String workoutUUID,
      {String? activityUUID}) async {
    final arguments = <String, dynamic>{
      'sample': sample.map,
      'workoutUUID': workoutUUID,
    };
    if (activityUUID != null) arguments['activityUUID'] = activityUUID;
    return await _methodChannel.invokeMethod(
        'unrelateWorkoutEffort', arguments);
  }

  /// Deletes the [sample] stored in [HealthKit], looked up by its [Sample.uuid]:
  /// use a sample read from [HealthKit] or one carrying the uuid [save] returned.
  /// An unknown uuid fails with a [PlatformException].
  ///
  static Future<bool> delete(Sample sample) async {
    final arguments = sample.parsed();
    return await _methodChannel.invokeMethod('delete', arguments);
  }

  /// Deletes the stored [samples] at once, looked up by their uuids.
  /// Either all of them are deleted or none.
  ///
  static Future<bool> deleteSamples(List<Sample> samples) async {
    final arguments = {
      'samples': samples.map((e) => e.parsed()).toList(),
    };
    return await _methodChannel.invokeMethod('deleteSamples', arguments);
  }

  /// Deletes all objects related to [identifier] with [predicate].
  /// Returns a map with the `status` and the deleted `count`.
  ///
  static Future<Map<String, dynamic>> deleteObjects(
      String identifier, Predicate predicate) async {
    final arguments = <String, dynamic>{
      'identifier': identifier,
    };
    arguments.addAll(predicate.map);
    final result =
        await _methodChannel.invokeMethod('deleteObjects', arguments);
    return Map<String, dynamic>.from(result);
  }

  /// Saves [sample] in [HealthKit] and returns the uuid
  /// [HealthKit] gave the stored sample.
  /// Keep it to delete the sample later, e.g. with [delete].
  ///
  static Future<String?> save(Sample sample) async {
    final arguments = sample.parsed();
    final result = Map<String, dynamic>.from(
        await _methodChannel.invokeMethod('save', arguments));
    return result['uuid'];
  }

  /// Saves [samples] at once; either all of them are stored or none.
  /// Returns the uuids of the stored samples, in the order of [samples].
  ///
  static Future<List<String>> saveSamples(List<Sample> samples) async {
    final arguments = {
      'samples': samples.map((e) => e.parsed()).toList(),
    };
    final result = Map<String, dynamic>.from(
        await _methodChannel.invokeMethod('saveSamples', arguments));
    return List<String>.from(result['uuids']);
  }
}
