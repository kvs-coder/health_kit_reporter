import '../../exceptions.dart';

/// Equivalent of [CategoryType]
/// from [HealthKitReporter] https://cocoapods.org/pods/HealthKitReporter
///
/// Supports [identifier] extension representing
/// original [String] of the type.
///
/// Has a factory methods [from] and [tryFrom]
/// Creating from [String]
///
enum CategoryType {
  sleepAnalysis,
  appleStandHour,
  cervicalMucusQuality,
  ovulationTestResult,
  menstrualFlow,
  intermenstrualBleeding,
  sexualActivity,
  mindfulSession,
  highHeartRateEvent,
  lowHeartRateEvent,
  irregularHeartRhythmEvent,
  toothbrushingEvent,
  pregnancy,
  lactation,
  contraceptive,
  audioExposureEvent,
  environmentalAudioExposureEvent,
  headphoneAudioExposureEvent,
  handwashingEvent,
  lowCardioFitnessEvent,
  abdominalCramps,
  acne,
  appetiteChanges,
  bladderIncontinence,
  bloating,
  breastPain,
  chestTightnessOrPain,
  chills,
  constipation,
  coughing,
  diarrhea,
  dizziness,
  drySkin,
  fainting,
  fatigue,
  fever,
  generalizedBodyAche,
  hairLoss,
  headache,
  heartburn,
  hotFlashes,
  lossOfSmell,
  lossOfTaste,
  lowerBackPain,
  memoryLapse,
  moodChanges,
  nausea,
  nightSweats,
  pelvicPain,
  rapidPoundingOrFlutteringHeartbeat,
  runnyNose,
  shortnessOfBreath,
  sinusCongestion,
  skippedHeartbeat,
  sleepChanges,
  soreThroat,
  vaginalDryness,
  vomiting,
  wheezing,
  pregnancyTestResult,
  progesteroneTestResult,
  persistentIntermenstrualBleeding,
  prolongedMenstrualPeriods,
  irregularMenstrualCycles,
  infrequentMenstrualCycles,
  appleWalkingSteadinessEvent,
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
      case CategoryType.mindfulSession:
        return 'HKCategoryTypeIdentifierMindfulSession';
      case CategoryType.highHeartRateEvent:
        return 'HKCategoryTypeIdentifierHighHeartRateEvent';
      case CategoryType.lowHeartRateEvent:
        return 'HKCategoryTypeIdentifierLowHeartRateEvent';
      case CategoryType.irregularHeartRhythmEvent:
        return 'HKCategoryTypeIdentifierIrregularHeartRhythmEvent';
      case CategoryType.toothbrushingEvent:
        return 'HKCategoryTypeIdentifierToothbrushingEvent';
      case CategoryType.pregnancy:
        return 'HKCategoryTypeIdentifierPregnancy';
      case CategoryType.lactation:
        return 'HKCategoryTypeIdentifierLactation';
      case CategoryType.contraceptive:
        return 'HKCategoryTypeIdentifierContraceptive';
      case CategoryType.environmentalAudioExposureEvent:
        return 'HKCategoryTypeIdentifierEnvironmentalAudioExposureEvent';
      case CategoryType.headphoneAudioExposureEvent:
        return 'HKCategoryTypeIdentifierHeadphoneAudioExposureEvent';
      case CategoryType.handwashingEvent:
        return 'HKCategoryTypeIdentifierHandwashingEvent';
      case CategoryType.lowCardioFitnessEvent:
        return 'HKCategoryTypeIdentifierLowCardioFitnessEvent';
      case CategoryType.abdominalCramps:
        return 'HKCategoryTypeIdentifierAbdominalCramps';
      case CategoryType.acne:
        return 'HKCategoryTypeIdentifierAcne';
      case CategoryType.appetiteChanges:
        return 'HKCategoryTypeIdentifierAppetiteChanges';
      case CategoryType.bladderIncontinence:
        return 'HKCategoryTypeIdentifierBladderIncontinence';
      case CategoryType.bloating:
        return 'HKCategoryTypeIdentifierBloating';
      case CategoryType.breastPain:
        return 'HKCategoryTypeIdentifierBreastPain';
      case CategoryType.chestTightnessOrPain:
        return 'HKCategoryTypeIdentifierChestTightnessOrPain';
      case CategoryType.chills:
        return 'HKCategoryTypeIdentifierChills';
      case CategoryType.constipation:
        return 'HKCategoryTypeIdentifierConstipation';
      case CategoryType.coughing:
        return 'HKCategoryTypeIdentifierCoughing';
      case CategoryType.diarrhea:
        return 'HKCategoryTypeIdentifierDiarrhea';
      case CategoryType.dizziness:
        return 'HKCategoryTypeIdentifierDizziness';
      case CategoryType.drySkin:
        return 'HKCategoryTypeIdentifierDrySkin';
      case CategoryType.fainting:
        return 'HKCategoryTypeIdentifierFainting';
      case CategoryType.fatigue:
        return 'HKCategoryTypeIdentifierFatigue';
      case CategoryType.fever:
        return 'HKCategoryTypeIdentifierFever';
      case CategoryType.generalizedBodyAche:
        return 'HKCategoryTypeIdentifierGeneralizedBodyAche';
      case CategoryType.hairLoss:
        return 'HKCategoryTypeIdentifierHairLoss';
      case CategoryType.headache:
        return 'HKCategoryTypeIdentifierHeadache';
      case CategoryType.heartburn:
        return 'HKCategoryTypeIdentifierHeartburn';
      case CategoryType.hotFlashes:
        return 'HKCategoryTypeIdentifierHotFlashes';
      case CategoryType.lossOfSmell:
        return 'HKCategoryTypeIdentifierLossOfSmell';
      case CategoryType.lossOfTaste:
        return 'HKCategoryTypeIdentifierLossOfTaste';
      case CategoryType.lowerBackPain:
        return 'HKCategoryTypeIdentifierLowerBackPain';
      case CategoryType.memoryLapse:
        return 'HKCategoryTypeIdentifierMemoryLapse';
      case CategoryType.moodChanges:
        return 'HKCategoryTypeIdentifierMoodChanges';
      case CategoryType.nausea:
        return 'HKCategoryTypeIdentifierNausea';
      case CategoryType.nightSweats:
        return 'HKCategoryTypeIdentifierNightSweats';
      case CategoryType.pelvicPain:
        return 'HKCategoryTypeIdentifierPelvicPain';
      case CategoryType.rapidPoundingOrFlutteringHeartbeat:
        return 'HKCategoryTypeIdentifierRapidPoundingOrFlutteringHeartbeat';
      case CategoryType.runnyNose:
        return 'HKCategoryTypeIdentifierRunnyNose';
      case CategoryType.shortnessOfBreath:
        return 'HKCategoryTypeIdentifierShortnessOfBreath';
      case CategoryType.sinusCongestion:
        return 'HKCategoryTypeIdentifierSinusCongestion';
      case CategoryType.skippedHeartbeat:
        return 'HKCategoryTypeIdentifierSkippedHeartbeat';
      case CategoryType.sleepChanges:
        return 'HKCategoryTypeIdentifierSleepChanges';
      case CategoryType.soreThroat:
        return 'HKCategoryTypeIdentifierSoreThroat';
      case CategoryType.vaginalDryness:
        return 'HKCategoryTypeIdentifierVaginalDryness';
      case CategoryType.vomiting:
        return 'HKCategoryTypeIdentifierVomiting';
      case CategoryType.wheezing:
        return 'HKCategoryTypeIdentifierWheezing';
      case CategoryType.pregnancyTestResult:
        return 'HKCategoryTypeIdentifierPregnancyTestResult';
      case CategoryType.progesteroneTestResult:
        return 'HKCategoryTypeIdentifierProgesteroneTestResult';
      case CategoryType.persistentIntermenstrualBleeding:
        return 'HKCategoryTypeIdentifierPersistentIntermenstrualBleeding';
      case CategoryType.prolongedMenstrualPeriods:
        return 'HKCategoryTypeIdentifierProlongedMenstrualPeriods';
      case CategoryType.irregularMenstrualCycles:
        return 'HKCategoryTypeIdentifierIrregularMenstrualCycles';
      case CategoryType.infrequentMenstrualCycles:
        return 'HKCategoryTypeIdentifierInfrequentMenstrualCycles';
      case CategoryType.appleWalkingSteadinessEvent:
        return 'HKCategoryTypeIdentifierAppleWalkingSteadinessEvent';
    }
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

  /// The [from] exception handling
  ///
  static CategoryType? tryFrom(String identifier) {
    try {
      return from(identifier);
    } on InvalidValueException {
      return null;
    }
  }
}
