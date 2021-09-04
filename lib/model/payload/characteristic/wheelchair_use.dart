/// Equivalent of [WheelchairUse]
/// from [HealthKitReporter] https://cocoapods.org/pods/HealthKitReporter
///
/// Supports [String] description extension [Description]
/// for available cases
///
/// Has a factory method [from]
/// Creating from [String]
///
enum WheelchairUseType {
  notSet,
  no,
  yes,
}

extension Description on WheelchairUseType {
  String get string {
    switch (this) {
      case WheelchairUseType.notSet:
        return 'na';
      case WheelchairUseType.no:
        return 'No';
      case WheelchairUseType.yes:
        return 'Yes';
    }
  }
}

extension WheelchairUseTypeFactory on WheelchairUseType {
  static WheelchairUseType? from(String string) {
    switch (string) {
      case 'na':
        return WheelchairUseType.notSet;
      case 'No':
        return WheelchairUseType.no;
      case 'Yes':
        return WheelchairUseType.yes;
      default:
        return null;
    }
  }
}
