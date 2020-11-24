import '../../exceptions.dart';

enum CategoryType {
  sleepAnalysis,
  appleStandHour,
  sexualActivity,
  intermenstrualBleeding,
  menstrualFlow,
  ovulationTestResult,
  cervicalMucusQuality,
  audioExposureEvent,
}

extension CategoryTypeIdentifier on CategoryType {
  String get identifier {
    switch (this) {
      case CategoryType.sleepAnalysis:
        return 'HKCategoryTypeIdentifierSleepAnalysis';
      case CategoryType.appleStandHour:
        return 'HKCategoryTypeIdentifierAppleStandHour';
      case CategoryType.sexualActivity:
        return 'HKCategoryTypeIdentifierSexualActivity';
      case CategoryType.intermenstrualBleeding:
        return 'HKCategoryTypeIdentifierIntermenstrualBleeding';
      case CategoryType.menstrualFlow:
        return 'HKCategoryTypeIdentifierMenstrualFlow';
      case CategoryType.ovulationTestResult:
        return 'HKCategoryTypeIdentifierOvulationTestResult';
      case CategoryType.cervicalMucusQuality:
        return 'HKCategoryTypeIdentifierCervicalMucusQuality';
      case CategoryType.audioExposureEvent:
        return 'HKCategoryTypeIdentifierAudioExposureEvent';
    }
    throw InvalidValueException('Unknown case: $this');
  }
}

extension CategoryTypeFactory on CategoryType {
  static CategoryType from(String identifier) {
    for (final type in CategoryType.values) {
      if (type.identifier == identifier) {
        return type;
      }
    }
    throw InvalidValueException('Unknown identifier: $identifier');
  }

  static CategoryType tryFrom(String identifier) {
    try {
      return from(identifier);
    } on InvalidValueException {
      return null;
    }
  }
}
