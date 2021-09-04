/// Equivalent of [ActivityMoveMode]
/// from [HealthKitReporter] https://cocoapods.org/pods/HealthKitReporter
///
/// Supports [String] description extension [Description]
/// for available cases
///
/// Has a factory method [from]
/// Creating from [String]
///
enum ActivityMoveModeType {
  activeEnergy,
  appleMoveTime,
}

extension Description on ActivityMoveModeType {
  String get string {
    switch (this) {
      case ActivityMoveModeType.activeEnergy:
        return 'Active energy';
      case ActivityMoveModeType.appleMoveTime:
        return 'Apple move time';
    }
  }
}

extension ActivityMoveModeTypeFactory on ActivityMoveModeType {
  static ActivityMoveModeType? from(String string) {
    switch (string) {
      case 'Active energy':
        return ActivityMoveModeType.activeEnergy;
      case 'Apple move time':
        return ActivityMoveModeType.appleMoveTime;
      default:
        return null;
    }
  }
}
