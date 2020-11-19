import 'package:health_kit_reporter/model/payload/category.dart';
import 'package:health_kit_reporter/model/payload/quantity.dart';
import 'package:health_kit_reporter/model/payload/workout.dart';
import 'package:health_kit_reporter/model/type/category_type.dart';
import 'package:health_kit_reporter/model/type/quantity_type.dart';
import 'package:health_kit_reporter/model/type/workout_type.dart';

import '../decorator/extensions.dart';
import 'device.dart';
import 'source_revision.dart';

abstract class Sample<Harmonized> {
  const Sample(
    this.identifier,
    this.startTimestamp,
    this.endTimestamp,
    this.device,
    this.sourceRevision,
    this.harmonized,
  );

  final String identifier;
  final int startTimestamp;
  final int endTimestamp;
  final Device device;
  final SourceRevision sourceRevision;
  final Harmonized harmonized;

  Map<String, dynamic> get map;

  Sample.fromJson(Map<String, dynamic> json, {Harmonized harmonized})
      : identifier = json['identifier'],
        startTimestamp = json['startTimestamp'].toString().integer,
        endTimestamp = json['endTimestamp'].toString().integer,
        device =
            json['device'] != null ? Device.fromJson(json['device']) : null,
        sourceRevision = SourceRevision.fromJson(json['sourceRevision']),
        harmonized = harmonized;

  static Sample factory(Map<String, dynamic> json) {
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
    return null;
  }
}
