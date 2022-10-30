import 'package:health_kit_reporter/exceptions.dart';

/// Equivalent of [QuantityType]
/// from [HealthKitReporter] https://cocoapods.org/pods/HealthKitReporter
///
/// Supports [identifier] extension representing
/// original [String] of the type.
///
/// Has a factory methods [from] and [tryFrom]
/// Creating from [String]
///
enum QuantityType {
  bodyMassIndex,
  bodyFatPercentage,
  height,
  bodyMass,
  leanBodyMass,
  waistCircumference,
  stepCount,
  distanceWalkingRunning,
  distanceCycling,
  distanceWheelchair,
  basalEnergyBurned,
  activeEnergyBurned,
  flightsClimbed,
  nikeFuel,
  appleExerciseTime,
  pushCount,
  distanceSwimming,
  swimmingStrokeCount,
  vo2Max,
  distanceDownhillSnowSports,
  appleStandTime,
  walkingSpeed,
  walkingDoubleSupportPercentage,
  walkingAsymmetryPercentage,
  walkingStepLength,
  sixMinuteWalkTestDistance,
  stairAscentSpeed,
  stairDescentSpeed,
  heartRate,
  bodyTemperature,
  basalBodyTemperature,
  bloodPressureSystolic,
  bloodPressureDiastolic,
  respiratoryRate,
  restingHeartRate,
  walkingHeartRateAverage,
  heartRateVariabilitySDNN,
  oxygenSaturation,
  peripheralPerfusionIndex,
  bloodGlucose,
  numberOfTimesFallen,
  electrodermalActivity,
  inhalerUsage,
  insulinDelivery,
  bloodAlcoholContent,
  forcedVitalCapacity,
  forcedExpiratoryVolume1,
  peakExpiratoryFlowRate,
  environmentalAudioExposure,
  headphoneAudioExposure,
  dietaryFatTotal,
  dietaryFatPolyunsaturated,
  dietaryFatMonounsaturated,
  dietaryFatSaturated,
  dietaryCholesterol,
  dietarySodium,
  dietaryCarbohydrates,
  dietaryFiber,
  dietarySugar,
  dietaryEnergyConsumed,
  dietaryProtein,
  dietaryVitaminA,
  dietaryVitaminB6,
  dietaryVitaminB12,
  dietaryVitaminC,
  dietaryVitaminD,
  dietaryVitaminE,
  dietaryVitaminK,
  dietaryCalcium,
  dietaryIron,
  dietaryThiamin,
  dietaryRiboflavin,
  dietaryNiacin,
  dietaryFolate,
  dietaryBiotin,
  dietaryPantothenicAcid,
  dietaryPhosphorus,
  dietaryIodine,
  dietaryMagnesium,
  dietaryZinc,
  dietarySelenium,
  dietaryCopper,
  dietaryManganese,
  dietaryChromium,
  dietaryMolybdenum,
  dietaryChloride,
  dietaryPotassium,
  dietaryCaffeine,
  dietaryWater,
  uvExposure,
  appleMoveTime,
  appleWalkingSteadiness,
  appleSleepingWristTemperature,
  runningStrideLength,
  runningVerticalOscillation,
  runningGroundContactTime,
  runningPower,
  runningSpeed,
  heartRateRecoveryOneMinute,
  numberOfAlcoholicBeverages,
  atrialFibrillationBurden,
  underwaterDepth,
  waterTemperature,
}

extension QuantityTypeIdentifier on QuantityType {
  String get identifier {
    switch (this) {
      case QuantityType.heartRateVariabilitySDNN:
        return 'HKQuantityTypeIdentifierHeartRateVariabilitySDNN';
      case QuantityType.bodyMassIndex:
        return 'HKQuantityTypeIdentifierBodyMassIndex';
      case QuantityType.bodyFatPercentage:
        return 'HKQuantityTypeIdentifierBodyFatPercentage';
      case QuantityType.heartRate:
        return 'HKQuantityTypeIdentifierHeartRate';
      case QuantityType.respiratoryRate:
        return 'HKQuantityTypeIdentifierRespiratoryRate';
      case QuantityType.oxygenSaturation:
        return 'HKQuantityTypeIdentifierOxygenSaturation';
      case QuantityType.bodyTemperature:
        return 'HKQuantityTypeIdentifierBodyTemperature';
      case QuantityType.basalBodyTemperature:
        return 'HKQuantityTypeIdentifierBasalBodyTemperature';
      case QuantityType.bloodPressureSystolic:
        return 'HKQuantityTypeIdentifierBloodPressureSystolic';
      case QuantityType.bloodPressureDiastolic:
        return 'HKQuantityTypeIdentifierBloodPressureDiastolic';
      case QuantityType.bloodGlucose:
        return 'HKQuantityTypeIdentifierBloodGlucose';
      case QuantityType.height:
        return 'HKQuantityTypeIdentifierHeight';
      case QuantityType.bodyMass:
        return 'HKQuantityTypeIdentifierBodyMass';
      case QuantityType.restingHeartRate:
        return 'HKQuantityTypeIdentifierRestingHeartRate';
      case QuantityType.vo2Max:
        return 'HKQuantityTypeIdentifierVO2Max';
      case QuantityType.waistCircumference:
        return 'HKQuantityTypeIdentifierWaistCircumference';
      case QuantityType.stepCount:
        return 'HKQuantityTypeIdentifierStepCount';
      case QuantityType.distanceSwimming:
        return 'HKQuantityTypeIdentifierDistanceSwimming';
      case QuantityType.distanceWalkingRunning:
        return 'HKQuantityTypeIdentifierDistanceWalkingRunning';
      case QuantityType.distanceCycling:
        return 'HKQuantityTypeIdentifierDistanceCycling';
      case QuantityType.basalEnergyBurned:
        return 'HKQuantityTypeIdentifierBasalEnergyBurned';
      case QuantityType.activeEnergyBurned:
        return 'HKQuantityTypeIdentifierActiveEnergyBurned';
      case QuantityType.flightsClimbed:
        return 'HKQuantityTypeIdentifierFlightsClimbed';
      case QuantityType.appleExerciseTime:
        return 'HKQuantityTypeIdentifierAppleExerciseTime';
      case QuantityType.dietaryEnergyConsumed:
        return 'HKQuantityTypeIdentifierDietaryEnergyConsumed';
      case QuantityType.dietaryCarbohydrates:
        return 'HKQuantityTypeIdentifierDietaryCarbohydrates';
      case QuantityType.dietaryFiber:
        return 'HKQuantityTypeIdentifierDietaryFiber';
      case QuantityType.dietarySugar:
        return 'HKQuantityTypeIdentifierDietarySugar';
      case QuantityType.dietaryFatTotal:
        return 'HKQuantityTypeIdentifierDietaryFatTotal';
      case QuantityType.dietaryFatSaturated:
        return 'HKQuantityTypeIdentifierDietaryFatSaturated';
      case QuantityType.dietaryProtein:
        return 'HKQuantityTypeIdentifierDietaryProtein';
      case QuantityType.dietaryVitaminA:
        return 'HKQuantityTypeIdentifierDietaryVitaminA';
      case QuantityType.dietaryThiamin:
        return 'HKQuantityTypeIdentifierDietaryThiamin';
      case QuantityType.dietaryRiboflavin:
        return 'HKQuantityTypeIdentifierDietaryRiboflavin';
      case QuantityType.dietaryNiacin:
        return 'HKQuantityTypeIdentifierDietaryNiacin';
      case QuantityType.dietaryPantothenicAcid:
        return 'HKQuantityTypeIdentifierDietaryPantothenicAcid';
      case QuantityType.dietaryVitaminB6:
        return 'HKQuantityTypeIdentifierDietaryVitaminB6';
      case QuantityType.dietaryVitaminB12:
        return 'HKQuantityTypeIdentifierDietaryVitaminB12';
      case QuantityType.dietaryVitaminC:
        return 'HKQuantityTypeIdentifierDietaryVitaminC';
      case QuantityType.dietaryVitaminD:
        return 'HKQuantityTypeIdentifierDietaryVitaminD';
      case QuantityType.dietaryVitaminE:
        return 'HKQuantityTypeIdentifierDietaryVitaminE';
      case QuantityType.dietaryVitaminK:
        return 'HKQuantityTypeIdentifierDietaryVitaminK';
      case QuantityType.dietaryFolate:
        return 'HKQuantityTypeIdentifierDietaryFolate';
      case QuantityType.dietaryCalcium:
        return 'HKQuantityTypeIdentifierDietaryCalcium';
      case QuantityType.dietaryIron:
        return 'HKQuantityTypeIdentifierDietaryIron';
      case QuantityType.dietaryMagnesium:
        return 'HKQuantityTypeIdentifierDietaryMagnesium';
      case QuantityType.dietaryPhosphorus:
        return 'HKQuantityTypeIdentifierDietaryPhosphorus';
      case QuantityType.dietaryPotassium:
        return 'HKQuantityTypeIdentifierDietaryPotassium';
      case QuantityType.dietarySodium:
        return 'HKQuantityTypeIdentifierDietarySodium';
      case QuantityType.dietaryZinc:
        return 'HKQuantityTypeIdentifierDietaryZinc';
      case QuantityType.dietaryIodine:
        return 'HKQuantityTypeIdentifierDietaryIodine';
      case QuantityType.dietaryManganese:
        return 'HKQuantityTypeIdentifierDietaryManganese';
      case QuantityType.dietaryWater:
        return 'HKQuantityTypeIdentifierDietaryWater';
      case QuantityType.environmentalAudioExposure:
        return 'HKQuantityTypeIdentifierEnvironmentalAudioExposure';
      case QuantityType.headphoneAudioExposure:
        return 'HKQuantityTypeIdentifierHeadphoneAudioExposure';
      case QuantityType.leanBodyMass:
        return 'HKQuantityTypeIdentifierLeanBodyMass';
      case QuantityType.distanceWheelchair:
        return 'HKQuantityTypeIdentifierDistanceWheelchair';
      case QuantityType.nikeFuel:
        return 'HKQuantityTypeIdentifierNikeFuel';
      case QuantityType.pushCount:
        return 'HKQuantityTypeIdentifierPushCount';
      case QuantityType.swimmingStrokeCount:
        return 'HKQuantityTypeIdentifierSwimmingStrokeCount';
      case QuantityType.distanceDownhillSnowSports:
        return 'HKQuantityTypeIdentifierDistanceDownhillSnowSports';
      case QuantityType.appleStandTime:
        return 'HKQuantityTypeIdentifierAppleStandTime';
      case QuantityType.walkingSpeed:
        return 'HKQuantityTypeIdentifierWalkingSpeed';
      case QuantityType.walkingDoubleSupportPercentage:
        return 'HKQuantityTypeIdentifierWalkingDoubleSupportPercentage';
      case QuantityType.walkingAsymmetryPercentage:
        return 'HKQuantityTypeIdentifierWalkingAsymmetryPercentage';
      case QuantityType.walkingStepLength:
        return 'HKQuantityTypeIdentifierWalkingStepLength';
      case QuantityType.sixMinuteWalkTestDistance:
        return 'HKQuantityTypeIdentifierSixMinuteWalkTestDistance';
      case QuantityType.stairAscentSpeed:
        return 'HKQuantityTypeIdentifierStairAscentSpeed';
      case QuantityType.stairDescentSpeed:
        return 'HKQuantityTypeIdentifierStairDescentSpeed';
      case QuantityType.walkingHeartRateAverage:
        return 'HKQuantityTypeIdentifierWalkingHeartRateAverage';
      case QuantityType.peripheralPerfusionIndex:
        return 'HKQuantityTypeIdentifierPeripheralPerfusionIndex';
      case QuantityType.numberOfTimesFallen:
        return 'HKQuantityTypeIdentifierNumberOfTimesFallen';
      case QuantityType.electrodermalActivity:
        return 'HKQuantityTypeIdentifierElectrodermalActivity';
      case QuantityType.inhalerUsage:
        return 'HKQuantityTypeIdentifierInhalerUsage';
      case QuantityType.insulinDelivery:
        return 'HKQuantityTypeIdentifierInsulinDelivery';
      case QuantityType.bloodAlcoholContent:
        return 'HKQuantityTypeIdentifierBloodAlcoholContent';
      case QuantityType.forcedVitalCapacity:
        return 'HKQuantityTypeIdentifierForcedVitalCapacity';
      case QuantityType.forcedExpiratoryVolume1:
        return 'HKQuantityTypeIdentifierForcedExpiratoryVolume1';
      case QuantityType.peakExpiratoryFlowRate:
        return 'HKQuantityTypeIdentifierPeakExpiratoryFlowRate';
      case QuantityType.dietaryFatPolyunsaturated:
        return 'HKQuantityTypeIdentifierDietaryFatPolyunsaturated';
      case QuantityType.dietaryFatMonounsaturated:
        return 'HKQuantityTypeIdentifierDietaryFatMonounsaturated';
      case QuantityType.dietaryCholesterol:
        return 'HKQuantityTypeIdentifierDietaryCholesterol';
      case QuantityType.dietaryBiotin:
        return 'HKQuantityTypeIdentifierDietaryBiotin';
      case QuantityType.dietarySelenium:
        return 'HKQuantityTypeIdentifierDietarySelenium';
      case QuantityType.dietaryCopper:
        return 'HKQuantityTypeIdentifierDietaryCopper';
      case QuantityType.dietaryChromium:
        return 'HKQuantityTypeIdentifierDietaryChromium';
      case QuantityType.dietaryMolybdenum:
        return 'HKQuantityTypeIdentifierDietaryMolybdenum';
      case QuantityType.dietaryChloride:
        return 'HKQuantityTypeIdentifierDietaryChloride';
      case QuantityType.dietaryCaffeine:
        return 'HKQuantityTypeIdentifierDietaryCaffeine';
      case QuantityType.uvExposure:
        return 'HKQuantityTypeIdentifierUVExposure';
      case QuantityType.appleMoveTime:
        return 'HKQuantityTypeIdentifierAppleMoveTime';
      case QuantityType.appleWalkingSteadiness:
        return 'HKQuantityTypeIdentifierAppleWalkingSteadiness';
      case QuantityType.appleSleepingWristTemperature:
        return 'HKQuantityTypeIdentifierAppleSleepingWristTemperature';
      case QuantityType.runningStrideLength:
        return 'HKQuantityTypeIdentifierRunningStrideLength';
      case QuantityType.runningVerticalOscillation:
        return 'HKQuantityTypeIdentifierRunningVerticalOscillation';
      case QuantityType.runningGroundContactTime:
        return 'HKQuantityTypeIdentifierRunningGroundContactTime';
      case QuantityType.runningPower:
        return 'HKQuantityTypeIdentifierRunningPower';
      case QuantityType.runningSpeed:
        return 'HKQuantityTypeIdentifierRunningSpeed';
      case QuantityType.heartRateRecoveryOneMinute:
        return 'HKQuantityTypeIdentifierHeartRateRecoveryOneMinute';
      case QuantityType.numberOfAlcoholicBeverages:
        return 'HKQuantityTypeIdentifierNumberOfAlcoholicBeverages';
      case QuantityType.atrialFibrillationBurden:
        return 'HKQuantityTypeIdentifierAtrialFibrillationBurden';
      case QuantityType.underwaterDepth:
        return 'HKQuantityTypeIdentifierUnderwaterDepth';
      case QuantityType.waterTemperature:
        return 'HKQuantityTypeIdentifierWaterTemperature';
    }
  }
}

extension QuantityTypeFactory on QuantityType {
  static QuantityType from(String identifier) {
    for (final type in QuantityType.values) {
      if (type.identifier == identifier) {
        return type;
      }
    }
    throw InvalidValueException('Unknown identifier: $identifier');
  }

  /// The [from] exception handling
  ///
  static QuantityType? tryFrom(String identifier) {
    try {
      return from(identifier);
    } on InvalidValueException {
      return null;
    }
  }
}
