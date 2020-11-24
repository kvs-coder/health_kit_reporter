class WorkoutConfiguration {
  const WorkoutConfiguration(this.activityValue, this.locationValue,
      this.swimmingValue, this.harmonized);

  final int activityValue;
  final int locationValue;
  final int swimmingValue;
  final WorkoutConfigurationHarmonized harmonized;

  Map<String, dynamic> get map => {
        'activityValue': activityValue,
        'locationValue': locationValue,
        'swimmingValue': swimmingValue,
        'harmonized': harmonized.map,
      };
}

class WorkoutConfigurationHarmonized {
  const WorkoutConfigurationHarmonized(this.value, this.unit);

  final int value;
  final String unit;

  Map<String, dynamic> get map => {
        'value': value,
        'unit': unit,
      };
}
