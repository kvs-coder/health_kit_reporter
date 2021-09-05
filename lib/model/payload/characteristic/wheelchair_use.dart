/// Equivalent of [WheelchairUse]
/// from [HealthKitReporter] https://cocoapods.org/pods/HealthKitReporter
///
/// Supports [String] description extension [Description]
/// for available cases
///
/// Has a factory method [from]
/// Creating from [String]
///
enum WheelchairUse {
  notSet,
  no,
  yes,
}

extension Description on WheelchairUse {
  String get description {
    switch (this) {
      case WheelchairUse.notSet:
        return 'na';
      case WheelchairUse.no:
        return 'No';
      case WheelchairUse.yes:
        return 'Yes';
    }
  }
}

extension WheelchairUseFactory on WheelchairUse {
  static WheelchairUse? from(String description) {
    switch (description) {
      case 'na':
        return WheelchairUse.notSet;
      case 'No':
        return WheelchairUse.no;
      case 'Yes':
        return WheelchairUse.yes;
      default:
        return null;
    }
  }
}
