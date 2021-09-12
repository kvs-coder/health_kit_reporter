/// Equivalent of [ActivityMoveMode]
/// from [HealthKitReporter] https://cocoapods.org/pods/HealthKitReporter
///
/// Supports [String] description extension [Description]
/// for available cases
///
/// Has a factory method [from]
/// Creating from [String]
///
enum ActivityMoveMode {
  activeEnergy,
  appleMoveTime,
}

extension Description on ActivityMoveMode {
  String get description {
    switch (this) {
      case ActivityMoveMode.activeEnergy:
        return 'Active energy';
      case ActivityMoveMode.appleMoveTime:
        return 'Apple move time';
    }
  }
}

extension ActivityMoveModeFactory on ActivityMoveMode {
  static ActivityMoveMode? from(String? description) {
    switch (description) {
      case 'Active energy':
        return ActivityMoveMode.activeEnergy;
      case 'Apple move time':
        return ActivityMoveMode.appleMoveTime;
      default:
        return null;
    }
  }
}
