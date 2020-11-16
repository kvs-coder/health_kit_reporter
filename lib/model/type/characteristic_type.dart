import '../../exceptions.dart';

enum CharacteristicType {
  fitzpatrickSkinType,
  dateOfBirth,
  bloodType,
  biologicalSex,
}

extension Identifier on CharacteristicType {
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
    }
    throw InvalidValueException('Unknown case: $this');
  }
}
