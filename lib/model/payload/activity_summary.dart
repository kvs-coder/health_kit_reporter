import 'package:health_kit_reporter/model/type/activity_summary_type.dart';

import '../decorator/extensions.dart';

/// Equivalent of [ActivitySummary]
/// from [HealthKitReporter] https://cocoapods.org/pods/HealthKitReporter
///
/// Supports [map] representation.
///
/// Has a [ActivitySummary.fromJson] constructor
/// to create instances from JSON payload coming from iOS native code.
///
/// Requires [ActivitySummaryType] permissions provided.
///
class ActivitySummary {
  const ActivitySummary(
    this.identifier,
    this.date,
    this.harmonized,
  );

  final String identifier;
  final DateTime date;
  final ActivitySummaryHarmonized harmonized;

  Map<String, dynamic> get map => {
        'identifier': identifier,
        'date': date.toIso8601String(),
        'harmonized': harmonized.map,
      };

  ActivitySummary.fromJson(Map<String, dynamic> json)
      : identifier = json['identifier'],
        date = json['date']?.toString()?.date,
        harmonized = ActivitySummaryHarmonized.fromJson(json['harmonized']);
}

/// Equivalent of [ActivitySummary.Harmonized]
/// from [HealthKitReporter] https://cocoapods.org/pods/HealthKitReporter
///
/// Supports [map] representation.
///
/// Has a [ActivitySummaryHarmonized.fromJson] constructor
/// to create instances from JSON payload coming from iOS native code.
///
class ActivitySummaryHarmonized {
  const ActivitySummaryHarmonized(
    this.activeEnergyBurned,
    this.activeEnergyBurnedGoal,
    this.activeEnergyBurnedUnit,
    this.appleExerciseTime,
    this.appleExerciseTimeGoal,
    this.appleExerciseTimeUnit,
    this.appleStandHours,
    this.appleStandHoursGoal,
    this.appleStandHoursUnit,
  );

  final num activeEnergyBurned;
  final num activeEnergyBurnedGoal;
  final String activeEnergyBurnedUnit;
  final num appleExerciseTime;
  final num appleExerciseTimeGoal;
  final String appleExerciseTimeUnit;
  final num appleStandHours;
  final num appleStandHoursGoal;
  final String appleStandHoursUnit;

  Map<String, dynamic> get map => {
        'activeEnergyBurned': activeEnergyBurned,
        'activeEnergyBurnedGoal': activeEnergyBurnedGoal,
        'activeEnergyBurnedUnit': activeEnergyBurnedUnit,
        'appleExerciseTime': appleExerciseTime,
        'appleExerciseTimeGoal': appleExerciseTimeGoal,
        'appleExerciseTimeUnit': appleExerciseTimeUnit,
        'appleStandHours': appleStandHours,
        'appleStandHoursGoal': appleStandHoursGoal,
        'appleStandHoursUnit': appleStandHoursUnit,
      };

  ActivitySummaryHarmonized.fromJson(Map<String, dynamic> json)
      : activeEnergyBurned = json['activeEnergyBurned'],
        activeEnergyBurnedGoal = json['activeEnergyBurnedGoal'],
        activeEnergyBurnedUnit = json['activeEnergyBurnedUnit'],
        appleExerciseTime = json['appleExerciseTime'],
        appleExerciseTimeGoal = json['appleExerciseTimeGoal'],
        appleExerciseTimeUnit = json['appleExerciseTimeUnit'],
        appleStandHours = json['appleStandHours'],
        appleStandHoursGoal = json['appleStandHoursGoal'],
        appleStandHoursUnit = json['appleStandHoursUnit'];
}
