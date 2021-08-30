/// Equivalent of [WorkoutConfiguration]
/// from [HealthKitReporter] https://cocoapods.org/pods/HealthKitReporter
///
/// Supports [map] representation.
///
/// Requires [WorkoutType] permissions provided.
///
class WorkoutConfiguration {
  const WorkoutConfiguration(this.activityValue, this.locationValue,
      this.swimmingValue, this.harmonized);

  final int activityValue;
  final int locationValue;
  final int swimmingValue;
  final WorkoutConfigurationHarmonized harmonized;

  /// General map representation
  ///
  Map<String, dynamic> get map => {
        'activityValue': activityValue,
        'locationValue': locationValue,
        'swimmingValue': swimmingValue,
        'value': harmonized.value,
        'unit': harmonized.unit,
      };
}

/// Equivalent of [WorkoutConfiguration.Harmonized]
/// from [HealthKitReporter] https://cocoapods.org/pods/HealthKitReporter
///
/// Supports [map] representation.
///
class WorkoutConfigurationHarmonized {
  const WorkoutConfigurationHarmonized(this.value, this.unit);

  final int value;
  final String unit;

  /// General map representation
  ///
  Map<String, dynamic> get map => {
        'value': value,
        'unit': unit,
      };
}
