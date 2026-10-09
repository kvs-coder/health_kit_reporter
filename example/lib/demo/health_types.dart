import 'package:flutter/services.dart';
import 'package:health_kit_reporter/health_kit_reporter.dart';
import 'package:health_kit_reporter/model/type/activity_summary_type.dart';
import 'package:health_kit_reporter/model/type/audiogram_type.dart';
import 'package:health_kit_reporter/model/type/category_type.dart';
import 'package:health_kit_reporter/model/type/characteristic_type.dart';
import 'package:health_kit_reporter/model/type/document_type.dart';
import 'package:health_kit_reporter/model/type/electrocardiogram_type.dart';
import 'package:health_kit_reporter/model/type/quantity_type.dart';
import 'package:health_kit_reporter/model/type/scored_assessment_type.dart';
import 'package:health_kit_reporter/model/type/series_type.dart';
import 'package:health_kit_reporter/model/type/state_of_mind_type.dart';
import 'package:health_kit_reporter/model/type/vision_prescription_type.dart';
import 'package:health_kit_reporter/model/type/workout_type.dart';

/// The types the demo authorizes, split the way HealthKit accepts them.
class HealthTypes {
  const HealthTypes(this.read, this.write, this.unavailable);

  final List<String> read;
  final List<String> write;

  /// Identifiers the running iOS version doesn't know
  final List<String> unavailable;

  static HealthTypes? _cached;

  /// Every sample type, characteristic and activity summary to read;
  /// every type whose [HealthKitReporter.isWritable] is true to write.
  ///
  /// Correlations, clinical records and per-object types (vision prescriptions,
  /// medications) aren't read: HealthKit authorizes them differently.
  /// Vision prescriptions are only written.
  static Future<HealthTypes> load() async {
    if (_cached != null) return _cached!;
    final sampleTypes = [
      ...QuantityType.values.map((e) => e.identifier),
      ...CategoryType.values.map((e) => e.identifier),
      ...WorkoutType.values.map((e) => e.identifier),
      ...SeriesType.values.map((e) => e.identifier),
      ...ElectrocardiogramType.values.map((e) => e.identifier),
      ...AudiogramType.values.map((e) => e.identifier),
      ...StateOfMindType.values.map((e) => e.identifier),
      ...ScoredAssessmentType.values.map((e) => e.identifier),
      ...DocumentType.values.map((e) => e.identifier),
    ];
    final read = <String>[
      ...CharacteristicType.values.map((e) => e.identifier),
      ...ActivitySummaryType.values.map((e) => e.identifier),
    ];
    final write = <String>[];
    final unavailable = <String>[];
    for (final identifier in sampleTypes.toSet()) {
      try {
        if (await HealthKitReporter.isWritable(identifier)) {
          write.add(identifier);
        }
        read.add(identifier);
      } on PlatformException {
        unavailable.add(identifier);
      }
    }
    final prescription = VisionPrescriptionType.visionPrescription.identifier;
    if (await HealthKitReporter.isWritable(prescription)) {
      write.add(prescription);
    }
    return _cached = HealthTypes(read, write, unavailable);
  }
}
