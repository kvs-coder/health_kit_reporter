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
  heartRateVariabilitySDNN,
  bodyMassIndex,
  bodyFatPercentage,
  heartRate,
  respiratoryRate,
  oxygenSaturation,
  bodyTemperature,
  basalBodyTemperature,
  bloodPressureSystolic,
  bloodPressureDiastolic,
  bloodGlucose,
  height,
  bodyMass,
  restingHeartRate,
  vo2Max,
  waistCircumference,
  stepCount,
  distanceSwimming,
  distanceWalkingRunning,
  distanceCycling,
  basalEnergyBurned,
  activeEnergyBurned,
  flightsClimbed,
  appleExerciseTime,
  dietaryEnergyConsumed,
  dietaryCarbohydrates,
  dietaryFiber,
  dietarySugar,
  dietaryFatTotal,
  dietaryFatSaturated,
  dietaryProtein,
  dietaryVitaminA,
  dietaryThiamin,
  dietaryRiboflavin,
  dietaryNiacin,
  dietaryPantothenicAcid,
  dietaryVitaminB6,
  dietaryVitaminB12,
  dietaryVitaminC,
  dietaryVitaminD,
  dietaryVitaminE,
  dietaryVitaminK,
  dietaryFolate,
  dietaryCalcium,
  dietaryIron,
  dietaryMagnesium,
  dietaryPhosphorus,
  dietaryPotassium,
  dietarySodium,
  dietaryZinc,
  dietaryIodine,
  dietaryManganese,
  dietaryWater,
  environmentalAudioExposure,
  headphoneAudioExposure,
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
    }
    throw InvalidValueException('Unknown case: $this');
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

  static QuantityType tryFrom(String identifier) {
    try {
      return from(identifier);
    } on InvalidValueException {
      return null;
    }
  }
}
