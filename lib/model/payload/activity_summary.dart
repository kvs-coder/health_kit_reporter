import 'package:health_kit_reporter/model/type/activity_summary_type.dart';

import '../decorator/extensions.dart';

/// Equivalent of [ActivitySummary]
/// from [HealthKitReporter] https://github.com/kvs-coder/HealthKitReporter
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

  /// The day of the summary; null when HealthKit gives no date components
  final DateTime? date;
  final ActivitySummaryHarmonized harmonized;

  /// General map representation
  ///
  Map<String, dynamic> get map => {
        'identifier': identifier,
        'date': date?.toIso8601String(),
        'harmonized': harmonized.map,
      };

  /// General constructor from JSON payload
  ///
  ActivitySummary.fromJson(Map<String, dynamic> json)
      : identifier = json['identifier'],
        date = (json['date'] as String?)?.date,
        harmonized = ActivitySummaryHarmonized.fromJson(
            Map<String, dynamic>.from(json['harmonized']));
}

/// Equivalent of [ActivitySummary.Harmonized]
/// from [HealthKitReporter] https://github.com/kvs-coder/HealthKitReporter
///
/// Supports [map] representation.
///
/// Has a [ActivitySummaryHarmonized.fromJson] constructor
/// to create instances from JSON payload coming from iOS native code.
///
/// The move time fields are set for move time summaries (iOS 14+),
/// see [activityMoveMode]; [paused] tells whether the rings were paused (iOS 18+).
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
    this.appleStandHoursUnit, [
    this.activityMoveMode,
    this.appleMoveTime,
    this.appleMoveTimeGoal,
    this.appleMoveTimeUnit,
    this.paused,
  ]);

  final num activeEnergyBurned;
  final num activeEnergyBurnedGoal;
  final String activeEnergyBurnedUnit;
  final num appleExerciseTime;
  final num appleExerciseTimeGoal;
  final String appleExerciseTimeUnit;
  final num appleStandHours;
  final num appleStandHoursGoal;
  final String appleStandHoursUnit;
  final String? activityMoveMode;
  final num? appleMoveTime;
  final num? appleMoveTimeGoal;
  final String? appleMoveTimeUnit;
  final bool? paused;

  /// General map representation
  ///
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
        'activityMoveMode': activityMoveMode,
        'appleMoveTime': appleMoveTime,
        'appleMoveTimeGoal': appleMoveTimeGoal,
        'appleMoveTimeUnit': appleMoveTimeUnit,
        'paused': paused,
      };

  /// General constructor from JSON payload
  ///
  ActivitySummaryHarmonized.fromJson(Map<String, dynamic> json)
      : activeEnergyBurned = parseNum(json['activeEnergyBurned']),
        activeEnergyBurnedGoal = parseNum(json['activeEnergyBurnedGoal']),
        activeEnergyBurnedUnit = json['activeEnergyBurnedUnit'],
        appleExerciseTime = parseNum(json['appleExerciseTime']),
        appleExerciseTimeGoal = parseNum(json['appleExerciseTimeGoal']),
        appleExerciseTimeUnit = json['appleExerciseTimeUnit'],
        appleStandHours = parseNum(json['appleStandHours']),
        appleStandHoursGoal = parseNum(json['appleStandHoursGoal']),
        appleStandHoursUnit = json['appleStandHoursUnit'],
        activityMoveMode = json['activityMoveMode'],
        appleMoveTime = tryParseNum(json['appleMoveTime']),
        appleMoveTimeGoal = tryParseNum(json['appleMoveTimeGoal']),
        appleMoveTimeUnit = json['appleMoveTimeUnit'],
        paused = json['paused'];
}
