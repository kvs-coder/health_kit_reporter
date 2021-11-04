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
  i,
  ii,
  iii,
  iv,
  v,
  vi,
}

extension Description on FitzpatrickSkinType {
  String get description {
    switch (this) {
      case FitzpatrickSkinType.notSet:
        return 'na';
      case FitzpatrickSkinType.i:
        return 'I';
      case FitzpatrickSkinType.ii:
        return 'II';
      case FitzpatrickSkinType.iii:
        return 'III';
      case FitzpatrickSkinType.iv:
        return 'IV';
      case FitzpatrickSkinType.v:
        return 'V';
      case FitzpatrickSkinType.vi:
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
        return FitzpatrickSkinType.i;
      case 'II':
        return FitzpatrickSkinType.ii;
      case 'III':
        return FitzpatrickSkinType.iii;
      case 'IV':
        return FitzpatrickSkinType.iv;
      case 'V':
        return FitzpatrickSkinType.v;
      case 'VI':
        return FitzpatrickSkinType.vi;
      default:
        return null;
    }
  }
}
