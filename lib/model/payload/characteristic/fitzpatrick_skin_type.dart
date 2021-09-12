/// Equivalent of [FitzpatrickSkinType]
/// from [HealthKitReporter] https://cocoapods.org/pods/HealthKitReporter
///
/// Supports [String] description extension [Description]
/// for available cases
///
/// Has a factory method [from]
/// Creating from [String]
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

extension Description on FitzpatrickSkinType {
  String get description {
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
  }
}

extension FitzpatrickSkinTypeFactory on FitzpatrickSkinType {
  static FitzpatrickSkinType? from(String? description) {
    switch (description) {
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
