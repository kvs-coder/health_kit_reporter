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

extension Identifier on CategoryType {
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
