import '../../../exceptions.dart';

/// Equivalent of [FitzpatrickSkinType]
/// from [HealthKitReporter] https://cocoapods.org/pods/HealthKitReporter
///
enum FitzpatrickSkinType {
  notSet,
  I,
  II,
  III,
  IV,
  V,
  VI,
}

/// String description of [FitzpatrickSkinType] cases
///
extension Description on FitzpatrickSkinType {
  String get string {
    switch (this) {
      case FitzpatrickSkinType.notSet:
        return 'na';
      case FitzpatrickSkinType.I:
        return 'I';
      case FitzpatrickSkinType.II:
        return 'II';
      case FitzpatrickSkinType.III:
        return 'III';
      case FitzpatrickSkinType.IV:
        return 'IV';
      case FitzpatrickSkinType.V:
        return 'V';
      case FitzpatrickSkinType.VI:
        return 'VI';
    }
    throw InvalidValueException('Unknown case: $this');
  }
}

/// Factory for [FitzpatrickSkinType]
/// Creating from [String]
///
extension FitzpatrickSkinTypeFactory on FitzpatrickSkinType {
  static FitzpatrickSkinType from(String string) {
    switch (string) {
      case 'na':
        return FitzpatrickSkinType.notSet;
      case 'I':
        return FitzpatrickSkinType.I;
      case 'II':
        return FitzpatrickSkinType.II;
      case 'III':
        return FitzpatrickSkinType.III;
      case 'IV':
        return FitzpatrickSkinType.IV;
      case 'V':
        return FitzpatrickSkinType.V;
      case 'VI':
        return FitzpatrickSkinType.VI;
      default:
        return null;
    }
  }
}
