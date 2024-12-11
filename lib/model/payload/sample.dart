import 'package:health_kit_reporter/health_kit_reporter.dart';

import '../type/category_type.dart';
import '../type/clinical_type.dart';
import '../type/correlation_type.dart';
import '../type/electrocardiogram_type.dart';
import '../type/quantity_type.dart';
import '../type/workout_type.dart';
import 'category.dart';
import 'clinical_record.dart';
import 'correlation.dart';
import 'device.dart';
import 'electrocardiogram.dart';
import 'quantity.dart';
import 'source_revision.dart';
import 'workout.dart';

/// Equivalent of [Sample]
/// from [HealthKitReporter] https://cocoapods.org/pods/HealthKitReporter
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
abstract class Sample<Harmonized> {
  const Sample(
    this.uuid,
    this.identifier,
    this.startTimestamp,
    this.endTimestamp,
    this.device,
    this.sourceRevision,
    this.harmonized,
  );

  final String uuid;
  final String identifier;
  final num startTimestamp;
  final num endTimestamp;
  final Device? device;
  final SourceRevision sourceRevision;
  final Harmonized harmonized;

  /// General map representation
  ///
  Map<String, dynamic> get map;

  /// General constructor from JSON payload
  ///
  Sample.from(Map<String, dynamic> json, this.harmonized)
      : uuid = json['uuid'],
        identifier = json['identifier'],
        startTimestamp = json['startTimestamp'],
        endTimestamp = json['endTimestamp'],
        device =
            json['device'] != null ? Device.fromJson(json['device']) : null,
        sourceRevision = SourceRevision.fromJson(json['sourceRevision']);

  /// For saving data, prepares appropriate map
  /// for [HealthKitReporter.save]
  ///
  Map<String, dynamic> parsed() {
    final arguments = <String, dynamic>{};
    if (this is Quantity) arguments['quantity'] = map;
    if (this is Category) arguments['category'] = map;
    if (this is Workout) arguments['workout'] = map;
    if (this is Correlation) arguments['correlation'] = map;
    return arguments;
  }

  /// Factory method to create instances as a result of
  /// [HealthKitReporter.sampleQuery]
  ///
  static Sample? factory(Map<String, dynamic> json) {
    final identifier = json['identifier'];
    final quantityType = QuantityTypeFactory.tryFrom(identifier);
    if (quantityType != null) {
      return Quantity.fromJson(json);
    }
    final categoryType = CategoryTypeFactory.tryFrom(identifier);
    if (categoryType != null) {
      return Category.fromJson(json);
    }
    final workoutType = WorkoutTypeFactory.tryFrom(identifier);
    if (workoutType != null) {
      return Workout.fromJson(json);
    }
    final correlationType = CorrelationTypeFactory.tryFrom(identifier);
    if (correlationType != null) {
      return Correlation.fromJson(json);
    }
    final electrocardiogramType =
        ElectrocardiogramTypeFactory.tryFrom(identifier);
    if (electrocardiogramType != null) {
      return Electrocardiogram.fromJson(json);
    }
    final clinicalRecordType = ClinicalTypeFactory.tryFrom(identifier);
    if (clinicalRecordType != null) {
      return ClinicalRecord.fromJson(json);
    }
    return null;
  }
}
