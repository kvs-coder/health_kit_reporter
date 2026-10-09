import 'dart:convert';

import '../../exceptions.dart';
import '../decorator/extensions.dart';
import '../type/audiogram_type.dart';
import '../type/category_type.dart';
import '../type/clinical_type.dart';
import '../type/correlation_type.dart';
import '../type/document_type.dart';
import '../type/electrocardiogram_type.dart';
import '../type/medication_type.dart';
import '../type/quantity_type.dart';
import '../type/scored_assessment_type.dart';
import '../type/series_type.dart';
import '../type/state_of_mind_type.dart';
import '../type/vision_prescription_type.dart';
import '../type/workout_type.dart';
import 'audiogram.dart';
import 'category.dart';
import 'cda_document.dart';
import 'clinical_record.dart';
import 'correlation.dart';
import 'device.dart';
import 'electrocardiogram.dart';
import 'heartbeat_series.dart';
import 'medication_dose_event.dart';
import 'quantity.dart';
import 'scored_assessment.dart';
import 'source_revision.dart';
import 'state_of_mind.dart';
import 'vision_prescription.dart';
import 'workout.dart';
import 'workout_route.dart';
import 'payload.dart';

/// Equivalent of [Sample]
/// from [HealthKitReporter] https://github.com/kvs-coder/HealthKitReporter
///
/// Supports [map] representation.
///
/// Has a [Sample.from] constructor
/// to create instances from JSON payload coming from iOS native code and a generic Harmonized object.
///
/// Has a [factory] method for creating a specific instance of types:
/// - [Quantity]
/// - [Category]
/// - [Workout]
/// - [Correlation]
/// - [Electrocardiogram]
/// - [ClinicalRecord]
/// - [VisionPrescription]
/// - [HeartbeatSeries]
/// - [WorkoutRoute]
/// - [Audiogram]
/// - [CDADocument]
/// - [StateOfMind]
/// - [ScoredAssessment]
/// - [MedicationDoseEvent]
/// Every type conforms the requirement
/// to have an associated type [Harmonized]implemented.
///
/// Depending on request, requires permissions provided from available types:
/// - [CategoryType]
/// - [CorrelationType]
/// - [ElectrocardiogramType]
/// - [QuantityType]
/// - [WorkoutType]
///
/// The method [parsed] is used for mapping values
/// to save data in [HealthKit]
///
///
abstract class Sample<Harmonized> with Payload {
  const Sample(
    this.uuid,
    this.identifier,
    this.startTimestamp,
    this.endTimestamp,
    this.device,
    this.sourceRevision,
    this.harmonized,
  );

  /// The uuid of the sample stored in [HealthKit].
  /// Send the sample back with it to delete it or to unrelate it.
  final String uuid;
  final String identifier;

  /// Seconds since 1970, also for samples built in Dart
  /// (see [SecondsSinceEpoch.secondsSinceEpoch])
  final num startTimestamp;

  /// Seconds since 1970
  final num endTimestamp;
  final Device? device;
  final SourceRevision sourceRevision;
  final Harmonized harmonized;

  /// General map representation
  ///
  @override
  Map<String, dynamic> get map;

  /// General constructor from JSON payload
  ///
  Sample.from(Map<String, dynamic> json, this.harmonized)
      : uuid = json['uuid'],
        identifier = json['identifier'],
        startTimestamp = parseNum(json['startTimestamp']),
        endTimestamp = parseNum(json['endTimestamp']),
        device = json['device'] != null
            ? Device.fromJson(Map<String, dynamic>.from(json['device']))
            : null,
        sourceRevision = SourceRevision.fromJson(json['sourceRevision']);

  /// For saving or deleting data, prepares appropriate map
  /// for [HealthKitReporter.save] and [HealthKitReporter.delete].
  /// [uuid] is part of it: the native side deletes the stored sample with it
  ///
  Map<String, dynamic> parsed() {
    final arguments = <String, dynamic>{};
    if (this is Quantity) arguments['quantity'] = map;
    if (this is Category) arguments['category'] = map;
    if (this is Workout) arguments['workout'] = map;
    if (this is Correlation) arguments['correlation'] = map;
    if (this is VisionPrescription) arguments['visionPrescription'] = map;
    if (this is Audiogram) arguments['audiogram'] = map;
    if (this is StateOfMind) arguments['stateOfMind'] = map;
    if (this is ScoredAssessment) arguments['scoredAssessment'] = map;
    if (this is CDADocument) arguments['cdaDocument'] = map;
    return arguments;
  }

  /// Factory method to create instances as a result of
  /// [HealthKitReporter.sampleQuery] and [HealthKitReporter.anchoredObjectQuery].
  /// Throws an [InvalidValueException] for an identifier it doesn't know,
  /// so no sample is dropped silently.
  ///
  static Sample factory(Map<String, dynamic> json) {
    final String identifier = json['identifier'];
    if (QuantityTypeFactory.tryFrom(identifier) != null) {
      return Quantity.fromJson(json);
    }
    if (CategoryTypeFactory.tryFrom(identifier) != null) {
      return Category.fromJson(json);
    }
    if (WorkoutTypeFactory.tryFrom(identifier) != null) {
      return Workout.fromJson(json);
    }
    if (CorrelationTypeFactory.tryFrom(identifier) != null) {
      return Correlation.fromJson(json);
    }
    if (ElectrocardiogramTypeFactory.tryFrom(identifier) != null) {
      return Electrocardiogram.fromJson(json);
    }
    if (ClinicalTypeFactory.tryFrom(identifier) != null) {
      return ClinicalRecord.fromJson(json);
    }
    if (AudiogramTypeFactory.tryFrom(identifier) != null) {
      return Audiogram.fromJson(json);
    }
    if (StateOfMindTypeFactory.tryFrom(identifier) != null) {
      return StateOfMind.fromJson(json);
    }
    if (ScoredAssessmentTypeFactory.tryFrom(identifier) != null) {
      return ScoredAssessment.fromJson(json);
    }
    if (DocumentTypeFactory.tryFrom(identifier) != null) {
      return CDADocument.fromJson(json);
    }
    if (identifier == VisionPrescriptionType.visionPrescription.identifier) {
      return VisionPrescription.fromJson(json);
    }
    if (identifier == MedicationType.medicationDoseEvent.identifier) {
      return MedicationDoseEvent.fromJson(json);
    }
    switch (SeriesTypeFactory.tryFrom(identifier)) {
      case SeriesType.heartbeatSeries:
        return HeartbeatSeries.fromJson(json);
      case SeriesType.workoutRoute:
        return WorkoutRoute.fromJson(json);
      case null:
        throw InvalidValueException('Unknown sample identifier: $identifier');
    }
  }

  /// [factory] for a list of JSON strings, as the sample queries reply.
  ///
  static List<Sample> collect(List<dynamic> list) =>
      [for (final String element in list) factory(jsonDecode(element))];
}
