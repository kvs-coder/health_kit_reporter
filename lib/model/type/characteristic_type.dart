import '../../exceptions.dart';

/// Equivalent of [CharacteristicType]
/// from [HealthKitReporter] https://cocoapods.org/pods/HealthKitReporter
///
/// Supports [identifier] extension representing
/// original [String] of the type.
///
enum CharacteristicType {
  fitzpatrickSkinType,
  dateOfBirth,
  bloodType,
  biologicalSex,
  wheelchairUse,
  activityMoveMode,
}

extension CharacteristicTypeIdentifier on CharacteristicType {
  String get identifier {
    switch (this) {
      case CharacteristicType.fitzpatrickSkinType:
        return 'HKCharacteristicTypeIdentifierFitzpatrickSkinType';
      case CharacteristicType.dateOfBirth:
        return 'HKCharacteristicTypeIdentifierDateOfBirth';
      case CharacteristicType.bloodType:
        return 'HKCharacteristicTypeIdentifierBloodType';
      case CharacteristicType.biologicalSex:
        return 'HKCharacteristicTypeIdentifierBiologicalSex';
      case CharacteristicType.wheelchairUse:
        return 'HKCharacteristicTypeIdentifierWheelchairUse';
      case CharacteristicType.activityMoveMode:
        return 'HKCharacteristicTypeIdentifierActivityMoveMode';
    }
    throw InvalidValueException('Unknown case: $this');
  }
}
