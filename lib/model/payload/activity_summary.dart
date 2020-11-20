import '../decorator/extensions.dart';

class ActivitySummary {
  const ActivitySummary(
    this.identifier,
    this.date,
    this.harmonized,
  );

  final String identifier;
  final DateTime date;
  final Harmonized harmonized;

  Map<String, dynamic> get map => {
        'identifier': identifier,
        'date': date.toIso8601String(),
        'harmonized': harmonized.map,
      };

  ActivitySummary.fromJson(Map<String, dynamic> json)
      : identifier = json['identifier'],
        date = json['date']?.toString()?.date,
        harmonized = Harmonized.fromJson(json['harmonized']);
}

class Harmonized {
  const Harmonized(
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

  Harmonized.fromJson(Map<String, dynamic> json)
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
