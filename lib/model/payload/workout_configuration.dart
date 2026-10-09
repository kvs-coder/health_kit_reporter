import 'payload.dart';

/// Equivalent of [WorkoutConfiguration]
/// from [HealthKitReporter] https://github.com/kvs-coder/HealthKitReporter
///
/// Supports [map] representation.
///
/// Requires [WorkoutType] permissions provided.
///
class WorkoutConfiguration with Payload {
  const WorkoutConfiguration(this.activityValue, this.locationValue,
      this.swimmingValue, this.harmonized);

  final int activityValue;
  final int locationValue;
  final int swimmingValue;
  final WorkoutConfigurationHarmonized harmonized;

  /// General map representation
  ///
  @override
  Map<String, dynamic> get map => {
        'activityValue': activityValue,
        'locationValue': locationValue,
        'swimmingValue': swimmingValue,
        'harmonized': harmonized.map,
      };
}

/// Equivalent of [WorkoutConfiguration.Harmonized]
/// from [HealthKitReporter] https://github.com/kvs-coder/HealthKitReporter
///
/// Supports [map] representation.
///
class WorkoutConfigurationHarmonized with Payload {
  const WorkoutConfigurationHarmonized(this.value, this.unit);

  final int value;
  final String unit;

  /// General map representation
  ///
  @override
  Map<String, dynamic> get map => {
        'value': value,
        'unit': unit,
      };
}
