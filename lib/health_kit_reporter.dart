import 'dart:async';
import 'dart:convert';

import 'package:flutter/services.dart';

import 'model/authorization_request_status.dart';
import 'model/decorator/extensions.dart';
import 'model/payload/attachment.dart';
import 'model/payload/audiogram.dart';
import 'model/payload/cda_document.dart';
import 'model/payload/medication_dose_event.dart';
import 'model/payload/metadata.dart';
import 'model/payload/quantity_series_value.dart';
import 'model/payload/scored_assessment.dart';
import 'model/payload/state_of_mind.dart';
import 'model/payload/user_annotated_medication.dart';
import 'model/payload/verifiable_clinical_record.dart';
import 'model/query_descriptor.dart';
import 'model/sample_query_option.dart';
import 'model/type/medication_type.dart';
import 'model/type/scored_assessment_type.dart';
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
/// - [workoutRouteQuery]
/// - [workoutRouteQueryForWorkout]
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
/// - [authorizationRequestStatus]
/// - [earliestPermittedSampleDate]
/// - [recalibrateEstimates]
/// - [attachments]
/// - [attachmentData]
/// - [addAttachment]
/// - [removeAttachment]
/// - [sampleQueryWithDescriptors]
/// - [quantitySeriesQuery]
/// - [verifiableClinicalRecordQuery]
/// - [cdaDocumentQuery]
/// - [audiogramQuery]
/// - [stateOfMindQuery]
/// - [scoredAssessmentQuery]
/// - [medicationDoseEventQuery]
/// - [userAnnotatedMedicationQuery]
/// - [saveWorkout]
/// - [saveQuantitySeries]
/// - [saveHeartbeatSeries]
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
/// [visionPrescriptionQuery], [requestPerObjectReadAuthorization] and the attachments require iOS 16.0,
/// [workoutEffortRelationshipQuery], [relateWorkoutEffort], [unrelateWorkoutEffort],
/// [stateOfMindQuery] and [scoredAssessmentQuery] iOS 18.0,
/// [medicationDoseEventQuery] and [userAnnotatedMedicationQuery] iOS 26.0.
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
/// 2. The native side plans the queries and replies with the name of a new event channel.
/// 3. Listening to it runs the queries; when the appropriate event is detected, the [FlutterEventSink] will sink the event.
/// 4. The new event will be handled in [listen] callback of the received broadcast stream
/// 5. After handling, the mapped event will be transferred as a ready result in the function's callback [onUpdate]
///
/// This workflow allows you not to call methods on native side in [AppDelegate.swift]
///
/// Every subscription runs its own native queries on an [EventChannel] of its own,
/// so several of them, also of the same method, run side by side
/// and cancelling one doesn't stop the others.
///
class HealthKitReporter {
  /// [MethodChannel] link to [SwiftHealthKitReporterPlugin.swift]
  /// Will invoke a bridge function of the plugin.
  ///
  static const MethodChannel _methodChannel =
      MethodChannel('health_kit_reporter_method_channel');

  /// Adds the optional [limit] (the most samples to return, newest first)
  /// and [queryOption] (whether samples must start and/or end inside the
  /// predicate's interval) to [arguments].
  ///
  static Map<String, dynamic> _queryArguments(Map<String, dynamic> arguments,
      {int? limit, SampleQueryOption? queryOption}) {
    if (limit != null) arguments['limit'] = limit;
    if (queryOption != null) arguments['predicateOptions'] = queryOption.value;
    return arguments;
  }

  /// Starts a live query: the native side plans the queries of [method]
  /// and replies with the name of an [EventChannel] of their own,
  /// so every subscription runs and stops independently.
  /// Failures, also while planning, reach [onError] as [PlatformException]s
  /// whose code is [method]; so do events [parse] can't read.
  ///
  static StreamSubscription<dynamic> _subscribe<T>(
      String method,
      Map<String, dynamic> arguments,
      T Function(dynamic event) parse,
      void Function(T update) onUpdate,
      Function? onError) {
    StreamSubscription<dynamic>? events;
    var cancelled = false;
    late final StreamController<T> controller;
    controller = StreamController<T>(
      onListen: () async {
        try {
          final String name =
              await _methodChannel.invokeMethod(method, arguments);
          // Listening and cancelling releases the native queries
          // of a subscription cancelled while they were planned
          events = EventChannel(name).receiveBroadcastStream().listen((event) {
            try {
              controller.add(parse(event));
            } catch (error, stackTrace) {
              controller.addError(error, stackTrace);
            }
          }, onError: controller.addError);
          if (cancelled) await events?.cancel();
        } catch (error, stackTrace) {
          controller.addError(error, stackTrace);
        }
      },
      onCancel: () async {
        cancelled = true;
        await events?.cancel();
      },
    );
    return controller.stream.listen(onUpdate, onError: onError);
  }

  /// Sets subscription for data changes.
  /// Will call [onUpdate] callback, if
  /// there were changes regarding to the provided [identifiers]
  /// inside [HealthKit], once per changed type.
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
    return _subscribe<String>(
        'observerQuery',
        arguments,
        (event) => Map<String, dynamic>.from(event)['identifier'],
        onUpdate,
        onError);
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
  /// A sample of a kind the plugin can't read fails the whole update
  /// through [onError], so no sample is skipped behind the anchor.
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
    return _subscribe<(List<Sample>, List<DeletedObject>, String?)>(
        'anchoredObjectQuery', arguments, (event) {
      final map = Map<String, dynamic>.from(event);
      return (
        Sample.collect(map['samples']),
        [
          for (final String element in List.from(map['deletedObjects']))
            DeletedObject.fromJson(jsonDecode(element))
        ],
        map['anchor'] as String?,
      );
    }, (update) => onUpdate(update.$1, update.$2, update.$3), onError);
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
    return _subscribe<List<ActivitySummary>>(
        'queryActivitySummaryUpdates',
        predicate.map,
        (event) => parseList(jsonDecode(event), ActivitySummary.fromJson),
        onUpdate,
        onError);
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
    final arguments = <String, dynamic>{
      'preferredUnits': preferredUnits.map((e) => e.map).toList(),
      'anchorTimestamp': anchorDate.millisecondsSinceEpoch,
      'enumerateFrom': enumerateFrom.millisecondsSinceEpoch,
      'enumerateTo': enumerateTo.millisecondsSinceEpoch,
      'intervalComponents': intervalComponents.map,
      'separateBySource': separateBySource,
    };
    arguments.addAll(predicate.map);
    return _subscribe<Statistics>('statisticsCollectionQuery', arguments,
        (event) => Statistics.fromJson(jsonDecode(event)), onUpdate, onError);
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
  /// [limit] returns at most that many series, newest first.
  ///
  static Future<List<HeartbeatSeries>> heartbeatSeriesQuery(Predicate predicate,
      {int? limit}) async {
    final result = await _methodChannel.invokeMethod('heartbeatSeriesQuery',
        _queryArguments({...predicate.map}, limit: limit));
    final List<dynamic> list = jsonDecode(result);
    return list.map((e) => HeartbeatSeries.fromJson(e)).toList();
  }

  /// Returns [WorkoutRoute] sample for the provided time interval predicate [predicate].
  /// [limit] returns at most that many routes, newest first.
  ///
  static Future<List<WorkoutRoute>> workoutRouteQuery(Predicate predicate,
      {int? limit}) async {
    final result = await _methodChannel.invokeMethod(
        'workoutRouteQuery', _queryArguments({...predicate.map}, limit: limit));
    final List<dynamic> list = jsonDecode(result);
    return list.map((e) => WorkoutRoute.fromJson(e)).toList();
  }

  /// Returns the routes of the stored workout with [workoutUUID]
  /// (see [Workout.uuid]), newest first, with their locations;
  /// [limit] returns at most that many routes.
  /// Fails with a [PlatformException] when no workout with that uuid is stored.
  ///
  /// Requires [SeriesType.workoutRoute] and [WorkoutType] read permissions
  /// and the location usage descriptions, as [workoutRouteQuery] does.
  ///
  static Future<List<WorkoutRoute>> workoutRouteQueryForWorkout(
      String workoutUUID,
      {int? limit}) async {
    final result = await _methodChannel.invokeMethod(
        'workoutRouteQueryForWorkout',
        _queryArguments({'workoutUUID': workoutUUID}, limit: limit));
    final List<dynamic> list = jsonDecode(result);
    return list.map((e) => WorkoutRoute.fromJson(e)).toList();
  }

  /// Returns [Quantity] samples for the provided [type],
  /// the preferred [unit] and the time interval predicate [predicate].
  ///
  /// [limit] returns at most that many samples, newest first;
  /// [queryOption] tells whether the samples must start and/or end inside
  /// the interval, both by default.
  ///
  /// Warning: The [unit] should be valid. See [preferredUnits].
  ///
  static Future<List<Quantity>> quantityQuery(
      QuantityType type, String unit, Predicate predicate,
      {int? limit, SampleQueryOption? queryOption}) async {
    final arguments = <String, dynamic>{
      'identifier': type.identifier,
      'unit': unit,
      ...predicate.map,
    };
    final result = await _methodChannel.invokeMethod('quantityQuery',
        _queryArguments(arguments, limit: limit, queryOption: queryOption));
    final List<dynamic> list = jsonDecode(result);
    return list.map((e) => Quantity.fromJson(e)).toList();
  }

  /// Returns [Category] samples for the provided [type]
  /// and the time interval predicate [predicate].
  /// [limit] returns at most that many samples, newest first;
  /// [queryOption] tells whether the samples must start and/or end inside
  /// the interval, both by default. [SampleQueryOption.notStrict] also returns
  /// samples crossing its bounds, e.g. sleep that started the evening before.
  ///
  static Future<List<Category>> categoryQuery(
      CategoryType type, Predicate predicate,
      {int? limit, SampleQueryOption? queryOption}) async {
    final arguments = <String, dynamic>{
      'identifier': type.identifier,
      ...predicate.map,
    };
    final result = await _methodChannel.invokeMethod('categoryQuery',
        _queryArguments(arguments, limit: limit, queryOption: queryOption));
    final List<dynamic> list = jsonDecode(result);
    return list.map((e) => Category.fromJson(e)).toList();
  }

  /// Returns [Workout] samples for the provided
  /// time interval predicate [predicate].
  /// [queryOption] tells whether the workouts must start and/or end inside
  /// the interval; both by default. [limit] returns at most that many workouts,
  /// newest first.
  ///
  static Future<List<Workout>> workoutQuery(Predicate predicate,
      {int? limit, SampleQueryOption? queryOption}) async {
    final result = await _methodChannel.invokeMethod(
        'workoutQuery',
        _queryArguments({...predicate.map},
            limit: limit, queryOption: queryOption));
    final List<dynamic> list = jsonDecode(result);
    return list.map((e) => Workout.fromJson(e)).toList();
  }

  /// Returns [Electrocardiogram] samples for the provided
  /// time interval predicate [predicate].
  /// [limit] returns at most that many ECGs, newest first.
  ///
  static Future<List<Electrocardiogram>> electrocardiogramQuery(
      Predicate predicate,
      {bool withVoltageMeasurements = false,
      int? limit}) async {
    final arguments = <String, dynamic>{
      'withVoltageMeasurements': withVoltageMeasurements,
      ...predicate.map,
    };
    final result = await _methodChannel.invokeMethod(
        'electrocardiogramQuery', _queryArguments(arguments, limit: limit));
    final List<dynamic> list = jsonDecode(result);
    return list.map((e) => Electrocardiogram.fromJson(e)).toList();
  }

  /// Returns [Sample] samples for the provided [identifier] and the
  /// time interval predicate [predicate].
  ///
  /// If [identifier] was recognized as one of [QuantityType], the
  /// units will be set automatically by original
  /// library [HealthKitReporter] according to SI.
  /// Heartbeat series, workout routes and ECGs come without their
  /// measurements, which their own queries deliver.
  /// A sample of a kind the plugin can't read fails the query
  /// with an [InvalidValueException] instead of being skipped.
  /// [limit] returns at most that many samples, newest first;
  /// [queryOption] tells whether the samples must start and/or end inside
  /// the interval, both by default.
  ///
  static Future<List<Sample>> sampleQuery(
      String identifier, Predicate predicate,
      {int? limit, SampleQueryOption? queryOption}) async {
    final arguments = <String, dynamic>{
      'identifier': identifier,
      ...predicate.map,
    };
    final result = await _methodChannel.invokeMethod('sampleQuery',
        _queryArguments(arguments, limit: limit, queryOption: queryOption));
    return Sample.collect(result);
  }

  /// Returns the samples of several types at once, newest first:
  /// every [QueryDescriptor] names a type and narrows it with its own predicate.
  /// [limit] returns at most that many samples in all.
  ///
  static Future<List<Sample>> sampleQueryWithDescriptors(
      List<QueryDescriptor> descriptors,
      {int? limit}) async {
    final arguments = <String, dynamic>{
      'descriptors': descriptors.map((e) => e.map).toList(),
    };
    final result = await _methodChannel.invokeMethod(
        'sampleQueryWithDescriptors', _queryArguments(arguments, limit: limit));
    return Sample.collect(result);
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
  /// optionally narrowed by the time interval predicate [predicate];
  /// [limit] returns at most that many records, newest first.
  ///
  /// Requires the Clinical Health Records entitlement,
  /// [supportsHealthRecords] and [requestClinicalRecordsAuthorization].
  ///
  static Future<List<ClinicalRecord>> clinicalRecordQuery(ClinicalType type,
      {Predicate? predicate, int? limit}) async {
    final arguments = <String, dynamic>{
      'identifier': type.identifier,
      ...?predicate?.map,
    };
    final result = await _methodChannel.invokeMethod(
        'clinicalRecordQuery', _queryArguments(arguments, limit: limit));
    final List<dynamic> list = jsonDecode(result);
    return list.map((e) => ClinicalRecord.fromJson(e)).toList();
  }

  /// Returns [VisionPrescription] samples,
  /// optionally narrowed by the time interval predicate [predicate]; [limit]
  /// returns at most that many, newest first. Requires iOS 16.
  ///
  /// Requires per-object read authorization, see [requestPerObjectReadAuthorization]
  /// with [VisionPrescriptionType.visionPrescription].
  ///
  static Future<List<VisionPrescription>> visionPrescriptionQuery(
      {Predicate? predicate, int? limit}) async {
    final result = await _methodChannel.invokeMethod('visionPrescriptionQuery',
        _queryArguments({...?predicate?.map}, limit: limit));
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

  /// Tells whether requesting authorization for [toRead] and [toWrite]
  /// would show the permission sheet.
  /// Types [requestAuthorization] refuses fail the same way.
  ///
  static Future<AuthorizationRequestStatus> authorizationRequestStatus(
      List<String> toRead, List<String> toWrite) async {
    final arguments = {
      'toRead': toRead,
      'toWrite': toWrite,
    };
    final int result = await _methodChannel.invokeMethod(
        'authorizationRequestStatus', arguments);
    return AuthorizationRequestStatusFactory.from(result);
  }

  /// The oldest date samples can be saved or queried for on this device.
  ///
  static Future<DateTime> earliestPermittedSampleDate() async {
    final num result =
        await _methodChannel.invokeMethod('earliestPermittedSampleDate');
    return dateFromSeconds(result);
  }

  /// Recalibrates the estimates [HealthKit] computes for the type with
  /// [identifier] from [date] on, e.g. [QuantityType.vo2Max] after a change
  /// in the user's health. Fails for types that don't allow recalibration.
  ///
  static Future<bool> recalibrateEstimates(
      String identifier, DateTime date) async {
    final arguments = {
      'identifier': identifier,
      'timestamp': date.millisecondsSinceEpoch,
    };
    return await _methodChannel.invokeMethod('recalibrateEstimates', arguments);
  }

  /// Lists the files attached to the stored sample with [uuid]
  /// of the type with [identifier]. Requires iOS 16.
  ///
  static Future<List<Attachment>> attachments(
      String identifier, String uuid) async {
    final arguments = {
      'identifier': identifier,
      'uuid': uuid,
    };
    final result = await _methodChannel.invokeMethod('attachments', arguments);
    return Attachment.collect(jsonDecode(result));
  }

  /// Reads the content of the attachment with [attachmentIdentifier]
  /// of the stored sample with [uuid]. Requires iOS 16.
  ///
  static Future<Uint8List> attachmentData(
      String identifier, String uuid, String attachmentIdentifier) async {
    final arguments = {
      'identifier': identifier,
      'uuid': uuid,
      'attachmentIdentifier': attachmentIdentifier,
    };
    return await _methodChannel.invokeMethod('attachmentData', arguments);
  }

  /// Attaches the local file at [filePath] to the stored sample with [uuid]
  /// of the type with [identifier] and returns the new [Attachment].
  /// [name] is shown to the user, [contentType] is a uniform type identifier,
  /// e.g. "public.jpeg". Requires iOS 16.
  ///
  static Future<Attachment> addAttachment(String identifier, String uuid,
      String name, String contentType, String filePath,
      {Metadata? metadata}) async {
    final arguments = <String, dynamic>{
      'identifier': identifier,
      'uuid': uuid,
      'name': name,
      'contentType': contentType,
      'filePath': filePath,
    };
    if (metadata != null) arguments['metadata'] = metadata.map;
    final result =
        await _methodChannel.invokeMethod('addAttachment', arguments);
    return Attachment.fromJson(jsonDecode(result));
  }

  /// Removes the attachment with [attachmentIdentifier]
  /// from the stored sample with [uuid]. Requires iOS 16.
  ///
  static Future<bool> removeAttachment(
      String identifier, String uuid, String attachmentIdentifier) async {
    final arguments = {
      'identifier': identifier,
      'uuid': uuid,
      'attachmentIdentifier': attachmentIdentifier,
    };
    return await _methodChannel.invokeMethod('removeAttachment', arguments);
  }

  /// Returns the individual quantities inside the quantity series samples
  /// of [type] in [unit], ordered by sample start date,
  /// optionally narrowed by [predicate].
  ///
  /// Warning: The [unit] should be valid. See [preferredUnits].
  ///
  static Future<List<QuantitySeriesValue>> quantitySeriesQuery(
      QuantityType type, String unit,
      {Predicate? predicate}) async {
    final arguments = <String, dynamic>{
      'identifier': type.identifier,
      'unit': unit,
    };
    if (predicate != null) arguments.addAll(predicate.map);
    final result =
        await _methodChannel.invokeMethod('quantitySeriesQuery', arguments);
    return QuantitySeriesValue.collect(jsonDecode(result));
  }

  /// Returns verifiable clinical records, such as SMART Health Cards, of
  /// [recordTypes] (e.g. "https://smarthealth.cards#immunization"),
  /// optionally limited to [sourceTypes] (e.g. "https://smarthealth.cards")
  /// and narrowed by [predicate].
  /// The system asks the user which records to share each time.
  ///
  static Future<List<VerifiableClinicalRecord>> verifiableClinicalRecordQuery(
      List<String> recordTypes,
      {List<String> sourceTypes = const [],
      Predicate? predicate}) async {
    final arguments = <String, dynamic>{
      'recordTypes': recordTypes,
      'sourceTypes': sourceTypes,
    };
    if (predicate != null) arguments.addAll(predicate.map);
    final result = await _methodChannel.invokeMethod(
        'verifiableClinicalRecordQuery', arguments);
    return VerifiableClinicalRecord.collect(jsonDecode(result));
  }

  /// Returns CDA documents, optionally narrowed by [predicate].
  /// [includeDocumentData] includes the CDA XML; [limit] returns at most that many.
  /// The user authorizes each document the first time it matches.
  ///
  static Future<List<CDADocument>> cdaDocumentQuery(
      {Predicate? predicate,
      bool includeDocumentData = true,
      int? limit}) async {
    final arguments = <String, dynamic>{
      'includeDocumentData': includeDocumentData,
      ...?predicate?.map,
    };
    final result = await _methodChannel.invokeMethod(
        'cdaDocumentQuery', _queryArguments(arguments, limit: limit));
    return CDADocument.collect(jsonDecode(result));
  }

  /// Returns [Audiogram] samples, optionally narrowed by [predicate];
  /// [limit] returns at most that many, newest first.
  ///
  static Future<List<Audiogram>> audiogramQuery(
      {Predicate? predicate, int? limit}) async {
    final result = await _methodChannel.invokeMethod(
        'audiogramQuery', _queryArguments({...?predicate?.map}, limit: limit));
    return Audiogram.collect(jsonDecode(result));
  }

  /// Returns logged emotions and moods, optionally narrowed by [predicate];
  /// [limit] returns at most that many, newest first.
  /// Requires iOS 18.
  ///
  static Future<List<StateOfMind>> stateOfMindQuery(
      {Predicate? predicate, int? limit}) async {
    final result = await _methodChannel.invokeMethod('stateOfMindQuery',
        _queryArguments({...?predicate?.map}, limit: limit));
    return StateOfMind.collect(jsonDecode(result));
  }

  /// Returns GAD-7 or PHQ-9 assessments of [type],
  /// optionally narrowed by [predicate]; [limit] returns at most that many,
  /// newest first. Requires iOS 18.
  ///
  static Future<List<ScoredAssessment>> scoredAssessmentQuery(
      ScoredAssessmentType type,
      {Predicate? predicate,
      int? limit}) async {
    final arguments = <String, dynamic>{
      'identifier': type.identifier,
      ...?predicate?.map,
    };
    final result = await _methodChannel.invokeMethod(
        'scoredAssessmentQuery', _queryArguments(arguments, limit: limit));
    return ScoredAssessment.collect(jsonDecode(result));
  }

  /// Returns logged medication doses, optionally of the medication with
  /// [medicationConceptIdentifier] (see [UserAnnotatedMedicationConcept.identifier])
  /// and narrowed by [predicate]; [limit] returns at most that many, newest first.
  /// Requires iOS 26.
  ///
  /// Requires per-object read authorization, see [requestPerObjectReadAuthorization]
  /// with [MedicationType.userAnnotatedMedication].
  ///
  static Future<List<MedicationDoseEvent>> medicationDoseEventQuery(
      {String? medicationConceptIdentifier,
      Predicate? predicate,
      int? limit}) async {
    final arguments = <String, dynamic>{...?predicate?.map};
    if (medicationConceptIdentifier != null) {
      arguments['medicationConceptIdentifier'] = medicationConceptIdentifier;
    }
    final result = await _methodChannel.invokeMethod(
        'medicationDoseEventQuery', _queryArguments(arguments, limit: limit));
    return MedicationDoseEvent.collect(jsonDecode(result));
  }

  /// Returns the medications the user tracks, at most [limit] of them.
  /// Requires iOS 26.
  ///
  /// Requires per-object read authorization, see [requestPerObjectReadAuthorization]
  /// with [MedicationType.userAnnotatedMedication].
  ///
  static Future<List<UserAnnotatedMedication>> userAnnotatedMedicationQuery(
      {int? limit}) async {
    final result = await _methodChannel.invokeMethod(
        'userAnnotatedMedicationQuery', _queryArguments({}, limit: limit));
    return UserAnnotatedMedication.collect(jsonDecode(result));
  }

  /// Saves [workout] through a workout builder and returns the stored workout.
  /// Its totals become samples for the types [samples] doesn't contain,
  /// its activities are added (iOS 16) and [route] is saved as its route.
  ///
  /// The workout is saved even when its route fails; then the
  /// [PlatformException]'s details hold the JSON of the stored workout.
  ///
  static Future<Workout> saveWorkout(Workout workout,
      {List<Quantity> samples = const [],
      List<WorkoutRouteLocation> route = const []}) async {
    final arguments = {
      'workout': workout.map,
      'samples': samples.map((e) => e.map).toList(),
      'route': route.map((e) => e.map).toList(),
    };
    final result = await _methodChannel.invokeMethod('saveWorkout', arguments);
    return Workout.fromJson(jsonDecode(result));
  }

  /// Saves [values] of [type] as one quantity series sample.
  /// [device] and [metadata] are optional.
  ///
  static Future<bool> saveQuantitySeries(
      QuantityType type, List<QuantitySeriesValue> values,
      {Device? device, Metadata? metadata}) async {
    final arguments = <String, dynamic>{
      'identifier': type.identifier,
      'values': values.map((e) => e.map).toList(),
    };
    if (device != null) arguments['device'] = device.map;
    if (metadata != null) arguments['metadata'] = metadata.map;
    return await _methodChannel.invokeMethod('saveQuantitySeries', arguments);
  }

  /// Saves [series] beat by beat: 1 to max ascending, non-negative
  /// [HeartbeatSeriesMeasurement.timeSinceSeriesStart]s.
  ///
  static Future<bool> saveHeartbeatSeries(HeartbeatSeries series) async {
    final arguments = {
      'series': series.map,
    };
    return await _methodChannel.invokeMethod('saveHeartbeatSeries', arguments);
  }
}
