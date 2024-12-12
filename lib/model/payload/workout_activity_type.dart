import 'package:health_kit_reporter/exceptions.dart';

/// Equivalent of [HKWorkoutActivityType]
/// from [HealthKitReporter] https://cocoapods.org/pods/HealthKitReporter
///
/// Supports [String] description extension [Description]
/// for available cases
///
/// Has a factory method [from]
/// Creating from [String]
///
enum WorkoutActivityType {
  americanFootball,
  archery,
  australianFootball,
  badminton,
  baseball,
  basketball,
  bowling,
  boxing,
  climbing,
  cricket,
  crossTraining,
  curling,
  cycling,
  dance,
  danceInspiredTraining,
  elliptical,
  equestrianSports,
  fencing,
  fishing,
  functionalStrengthTraining,
  golf,
  gymnastics,
  handball,
  hiking,
  hockey,
  hunting,
  lacrosse,
  martialArts,
  mindAndBody,
  mixedMetabolicCardioTraining,
  paddleSports,
  play,
  preparationAndRecovery,
  racquetball,
  rowing,
  rugby,
  running,
  sailing,
  skatingSports,
  snowSports,
  soccer,
  softball,
  squash,
  stairClimbing,
  surfingSports,
  swimming,
  tableTennis,
  tennis,
  trackAndField,
  traditionalStrengthTraining,
  volleyball,
  walking,
  waterFitness,
  waterPolo,
  waterSports,
  wrestling,
  yoga,
  barre,
  coreTraining,
  crossCountrySkiing,
  downhillSkiing,
  flexibility,
  highIntensityIntervalTraining,
  jumpRope,
  kickboxing,
  pilates,
  snowboarding,
  stairs,
  stepTraining,
  wheelchairWalkPace,
  wheelchairRunPace,
  taiChi,
  mixedCardio,
  handCycling,
  discSports,
  fitnessGaming,
  cardioDance,
  socialDance,
  pickleball,
  cooldown,
  swimBikeRun,
  transition,
  underwaterDiving,
  other,
}

extension Value on WorkoutActivityType {
  int get value {
    switch (this) {
      case WorkoutActivityType.americanFootball:
        return 1;
      case WorkoutActivityType.archery:
        return 2;
      case WorkoutActivityType.australianFootball:
        return 3;
      case WorkoutActivityType.badminton:
        return 4;
      case WorkoutActivityType.baseball:
        return 5;
      case WorkoutActivityType.basketball:
        return 6;
      case WorkoutActivityType.bowling:
        return 7;
      case WorkoutActivityType.boxing:
        return 8;
      case WorkoutActivityType.climbing:
        return 9;
      case WorkoutActivityType.cricket:
        return 10;
      case WorkoutActivityType.crossTraining:
        return 11;
      case WorkoutActivityType.curling:
        return 12;
      case WorkoutActivityType.cycling:
        return 13;
      case WorkoutActivityType.dance:
        return 14;
      case WorkoutActivityType.danceInspiredTraining:
        return 15;
      case WorkoutActivityType.elliptical:
        return 16;
      case WorkoutActivityType.equestrianSports:
        return 17;
      case WorkoutActivityType.fencing:
        return 18;
      case WorkoutActivityType.fishing:
        return 19;
      case WorkoutActivityType.functionalStrengthTraining:
        return 20;
      case WorkoutActivityType.golf:
        return 21;
      case WorkoutActivityType.gymnastics:
        return 22;
      case WorkoutActivityType.handball:
        return 23;
      case WorkoutActivityType.hiking:
        return 24;
      case WorkoutActivityType.hockey:
        return 25;
      case WorkoutActivityType.hunting:
        return 26;
      case WorkoutActivityType.lacrosse:
        return 27;
      case WorkoutActivityType.martialArts:
        return 28;
      case WorkoutActivityType.mindAndBody:
        return 29;
      case WorkoutActivityType.mixedMetabolicCardioTraining:
        return 30;
      case WorkoutActivityType.paddleSports:
        return 31;
      case WorkoutActivityType.play:
        return 32;
      case WorkoutActivityType.preparationAndRecovery:
        return 33;
      case WorkoutActivityType.racquetball:
        return 34;
      case WorkoutActivityType.rowing:
        return 35;
      case WorkoutActivityType.rugby:
        return 36;
      case WorkoutActivityType.running:
        return 37;
      case WorkoutActivityType.sailing:
        return 38;
      case WorkoutActivityType.skatingSports:
        return 39;
      case WorkoutActivityType.snowSports:
        return 40;
      case WorkoutActivityType.soccer:
        return 41;
      case WorkoutActivityType.softball:
        return 42;
      case WorkoutActivityType.squash:
        return 43;
      case WorkoutActivityType.stairClimbing:
        return 44;
      case WorkoutActivityType.surfingSports:
        return 45;
      case WorkoutActivityType.swimming:
        return 46;
      case WorkoutActivityType.tableTennis:
        return 47;
      case WorkoutActivityType.tennis:
        return 48;
      case WorkoutActivityType.trackAndField:
        return 49;
      case WorkoutActivityType.traditionalStrengthTraining:
        return 50;
      case WorkoutActivityType.volleyball:
        return 51;
      case WorkoutActivityType.walking:
        return 52;
      case WorkoutActivityType.waterFitness:
        return 53;
      case WorkoutActivityType.waterPolo:
        return 54;
      case WorkoutActivityType.waterSports:
        return 55;
      case WorkoutActivityType.wrestling:
        return 56;
      case WorkoutActivityType.yoga:
        return 57;
      case WorkoutActivityType.barre:
        return 58;
      case WorkoutActivityType.coreTraining:
        return 59;
      case WorkoutActivityType.crossCountrySkiing:
        return 60;
      case WorkoutActivityType.downhillSkiing:
        return 61;
      case WorkoutActivityType.flexibility:
        return 62;
      case WorkoutActivityType.highIntensityIntervalTraining:
        return 63;
      case WorkoutActivityType.jumpRope:
        return 64;
      case WorkoutActivityType.kickboxing:
        return 65;
      case WorkoutActivityType.pilates:
        return 66;
      case WorkoutActivityType.snowboarding:
        return 67;
      case WorkoutActivityType.stairs:
        return 68;
      case WorkoutActivityType.stepTraining:
        return 69;
      case WorkoutActivityType.wheelchairWalkPace:
        return 70;
      case WorkoutActivityType.wheelchairRunPace:
        return 71;
      case WorkoutActivityType.taiChi:
        return 72;
      case WorkoutActivityType.mixedCardio:
        return 73;
      case WorkoutActivityType.handCycling:
        return 74;
      case WorkoutActivityType.discSports:
        return 75;
      case WorkoutActivityType.fitnessGaming:
        return 76;
      case WorkoutActivityType.cardioDance:
        return 77;
      case WorkoutActivityType.socialDance:
        return 78;
      case WorkoutActivityType.pickleball:
        return 79;
      case WorkoutActivityType.cooldown:
        return 80;
      case WorkoutActivityType.swimBikeRun:
        return 82;
      case WorkoutActivityType.transition:
        return 83;
      case WorkoutActivityType.underwaterDiving:
        return 84;
      case WorkoutActivityType.other:
        return 3000;
    }
  }
}

extension Description on WorkoutActivityType {
  String get description {
    switch (this) {
      case WorkoutActivityType.americanFootball:
        return 'American Football';
      case WorkoutActivityType.archery:
        return 'Archery';
      case WorkoutActivityType.australianFootball:
        return 'Australian Football';
      case WorkoutActivityType.badminton:
        return 'Badminton';
      case WorkoutActivityType.baseball:
        return 'Baseball';
      case WorkoutActivityType.basketball:
        return 'Basketball';
      case WorkoutActivityType.bowling:
        return 'Bowling';
      case WorkoutActivityType.boxing:
        return 'Boxing';
      case WorkoutActivityType.climbing:
        return 'Climbing';
      case WorkoutActivityType.cricket:
        return 'Cricket';
      case WorkoutActivityType.crossTraining:
        return 'Cross Training';
      case WorkoutActivityType.curling:
        return 'Curling';
      case WorkoutActivityType.cycling:
        return 'Cycling';
      case WorkoutActivityType.dance:
        return 'Dance';
      case WorkoutActivityType.danceInspiredTraining:
        return 'Dance Inspired Training';
      case WorkoutActivityType.elliptical:
        return 'Elliptical';
      case WorkoutActivityType.equestrianSports:
        return 'Equestrian Sports';
      case WorkoutActivityType.fencing:
        return 'Fencing';
      case WorkoutActivityType.fishing:
        return 'Fishing';
      case WorkoutActivityType.functionalStrengthTraining:
        return 'Functional Strength Training';
      case WorkoutActivityType.golf:
        return 'Golf';
      case WorkoutActivityType.gymnastics:
        return 'Gymnastics';
      case WorkoutActivityType.handball:
        return 'Handball';
      case WorkoutActivityType.hiking:
        return 'Hiking';
      case WorkoutActivityType.hockey:
        return 'Hockey';
      case WorkoutActivityType.hunting:
        return 'Hunting';
      case WorkoutActivityType.lacrosse:
        return 'Lacrosse';
      case WorkoutActivityType.martialArts:
        return 'Martial Arts';
      case WorkoutActivityType.mindAndBody:
        return 'Mind and Body';
      case WorkoutActivityType.mixedMetabolicCardioTraining:
        return 'Mixed Metabolic Cardio Training';
      case WorkoutActivityType.paddleSports:
        return 'Paddle Sports';
      case WorkoutActivityType.play:
        return 'Play';
      case WorkoutActivityType.preparationAndRecovery:
        return 'Prepare and Recovery';
      case WorkoutActivityType.racquetball:
        return 'Racquetball';
      case WorkoutActivityType.rowing:
        return 'Rowing';
      case WorkoutActivityType.rugby:
        return 'Rugby';
      case WorkoutActivityType.running:
        return 'Running';
      case WorkoutActivityType.sailing:
        return 'Sailing';
      case WorkoutActivityType.skatingSports:
        return 'Skating Sports';
      case WorkoutActivityType.snowSports:
        return 'Snow Sports';
      case WorkoutActivityType.soccer:
        return 'Soccer';
      case WorkoutActivityType.softball:
        return 'Softball';
      case WorkoutActivityType.squash:
        return 'Squash';
      case WorkoutActivityType.stairClimbing:
        return 'Stair Climbing';
      case WorkoutActivityType.surfingSports:
        return 'Surfing Sports';
      case WorkoutActivityType.swimming:
        return 'Swimming';
      case WorkoutActivityType.tableTennis:
        return 'Table Tennis';
      case WorkoutActivityType.tennis:
        return 'Tennis';
      case WorkoutActivityType.trackAndField:
        return 'Track and Field';
      case WorkoutActivityType.traditionalStrengthTraining:
        return 'Traditional Strength Training';
      case WorkoutActivityType.volleyball:
        return 'Volleyball';
      case WorkoutActivityType.walking:
        return 'Walking';
      case WorkoutActivityType.waterFitness:
        return 'Water Fitness';
      case WorkoutActivityType.waterPolo:
        return 'Water Polo';
      case WorkoutActivityType.waterSports:
        return 'Water Sports';
      case WorkoutActivityType.wrestling:
        return 'Wrestling';
      case WorkoutActivityType.yoga:
        return 'Yoga';
      case WorkoutActivityType.barre:
        return 'Barre';
      case WorkoutActivityType.coreTraining:
        return 'Core Training';
      case WorkoutActivityType.crossCountrySkiing:
        return 'Cross Country Skiing';
      case WorkoutActivityType.downhillSkiing:
        return 'Downhill Skiing';
      case WorkoutActivityType.flexibility:
        return 'Flexibility';
      case WorkoutActivityType.highIntensityIntervalTraining:
        return 'High Intensity Interval Training';
      case WorkoutActivityType.jumpRope:
        return 'Jump Rope';
      case WorkoutActivityType.kickboxing:
        return 'Kickboxing';
      case WorkoutActivityType.pilates:
        return 'Pilates';
      case WorkoutActivityType.snowboarding:
        return 'Snowboarding';
      case WorkoutActivityType.stairs:
        return 'Stairs';
      case WorkoutActivityType.stepTraining:
        return 'Step Training';
      case WorkoutActivityType.wheelchairWalkPace:
        return 'Wheelchair Walk Pace';
      case WorkoutActivityType.wheelchairRunPace:
        return 'Wheelchair Run Pace';
      case WorkoutActivityType.taiChi:
        return 'Tai Chi';
      case WorkoutActivityType.mixedCardio:
        return 'Mixed Cardio';
      case WorkoutActivityType.handCycling:
        return 'Handy Cycling';
      case WorkoutActivityType.discSports:
        return 'Disc Sports';
      case WorkoutActivityType.fitnessGaming:
        return 'Fitness Gaming';
      case WorkoutActivityType.cardioDance:
        return 'Cardio Dance';
      case WorkoutActivityType.socialDance:
        return 'Social Dance';
      case WorkoutActivityType.pickleball:
        return 'Pickerball';
      case WorkoutActivityType.cooldown:
        return 'Cooldown';
      case WorkoutActivityType.swimBikeRun:
        return 'Swim Bike Run';
      case WorkoutActivityType.transition:
        return 'Transition';
      case WorkoutActivityType.underwaterDiving:
        return 'Underwater Diving';
      case WorkoutActivityType.other:
        return 'Other';
    }
  }
}

extension WorkoutActivityTypeFactory on WorkoutActivityType {
  static WorkoutActivityType from(int value) {
    switch (value) {
      case 1:
        return WorkoutActivityType.americanFootball;
      case 2:
        return WorkoutActivityType.archery;
      case 3:
        return WorkoutActivityType.australianFootball;
      case 4:
        return WorkoutActivityType.badminton;
      case 5:
        return WorkoutActivityType.baseball;
      case 6:
        return WorkoutActivityType.basketball;
      case 7:
        return WorkoutActivityType.bowling;
      case 8:
        return WorkoutActivityType.boxing;
      case 9:
        return WorkoutActivityType.climbing;
      case 10:
        return WorkoutActivityType.cricket;
      case 11:
        return WorkoutActivityType.crossTraining;
      case 12:
        return WorkoutActivityType.curling;
      case 13:
        return WorkoutActivityType.cycling;
      case 14:
        return WorkoutActivityType.dance;
      case 15:
        return WorkoutActivityType.danceInspiredTraining;
      case 16:
        return WorkoutActivityType.elliptical;
      case 17:
        return WorkoutActivityType.equestrianSports;
      case 18:
        return WorkoutActivityType.fencing;
      case 19:
        return WorkoutActivityType.fishing;
      case 20:
        return WorkoutActivityType.functionalStrengthTraining;
      case 21:
        return WorkoutActivityType.golf;
      case 22:
        return WorkoutActivityType.gymnastics;
      case 23:
        return WorkoutActivityType.handball;
      case 24:
        return WorkoutActivityType.hiking;
      case 25:
        return WorkoutActivityType.hockey;
      case 26:
        return WorkoutActivityType.hunting;
      case 27:
        return WorkoutActivityType.lacrosse;
      case 28:
        return WorkoutActivityType.martialArts;
      case 29:
        return WorkoutActivityType.mindAndBody;
      case 30:
        return WorkoutActivityType.mixedMetabolicCardioTraining;
      case 31:
        return WorkoutActivityType.paddleSports;
      case 32:
        return WorkoutActivityType.play;
      case 33:
        return WorkoutActivityType.preparationAndRecovery;
      case 34:
        return WorkoutActivityType.racquetball;
      case 35:
        return WorkoutActivityType.rowing;
      case 36:
        return WorkoutActivityType.rugby;
      case 37:
        return WorkoutActivityType.running;
      case 38:
        return WorkoutActivityType.sailing;
      case 39:
        return WorkoutActivityType.skatingSports;
      case 40:
        return WorkoutActivityType.snowSports;
      case 41:
        return WorkoutActivityType.soccer;
      case 42:
        return WorkoutActivityType.softball;
      case 43:
        return WorkoutActivityType.squash;
      case 44:
        return WorkoutActivityType.stairClimbing;
      case 45:
        return WorkoutActivityType.surfingSports;
      case 46:
        return WorkoutActivityType.swimming;
      case 47:
        return WorkoutActivityType.tableTennis;
      case 48:
        return WorkoutActivityType.tennis;
      case 49:
        return WorkoutActivityType.trackAndField;
      case 50:
        return WorkoutActivityType.traditionalStrengthTraining;
      case 51:
        return WorkoutActivityType.volleyball;
      case 52:
        return WorkoutActivityType.walking;
      case 53:
        return WorkoutActivityType.waterFitness;
      case 54:
        return WorkoutActivityType.waterPolo;
      case 55:
        return WorkoutActivityType.waterSports;
      case 56:
        return WorkoutActivityType.wrestling;
      case 57:
        return WorkoutActivityType.yoga;
      case 58:
        return WorkoutActivityType.barre;
      case 59:
        return WorkoutActivityType.coreTraining;
      case 60:
        return WorkoutActivityType.crossCountrySkiing;
      case 61:
        return WorkoutActivityType.downhillSkiing;
      case 62:
        return WorkoutActivityType.flexibility;
      case 63:
        return WorkoutActivityType.highIntensityIntervalTraining;
      case 64:
        return WorkoutActivityType.jumpRope;
      case 65:
        return WorkoutActivityType.kickboxing;
      case 66:
        return WorkoutActivityType.pilates;
      case 67:
        return WorkoutActivityType.snowboarding;
      case 68:
        return WorkoutActivityType.stairs;
      case 69:
        return WorkoutActivityType.stepTraining;
      case 70:
        return WorkoutActivityType.wheelchairWalkPace;
      case 71:
        return WorkoutActivityType.wheelchairRunPace;
      case 72:
        return WorkoutActivityType.taiChi;
      case 73:
        return WorkoutActivityType.mixedCardio;
      case 74:
        return WorkoutActivityType.handCycling;
      case 75:
        return WorkoutActivityType.discSports;
      case 76:
        return WorkoutActivityType.fitnessGaming;
      case 77:
        return WorkoutActivityType.cardioDance;
      case 78:
        return WorkoutActivityType.socialDance;
      case 79:
        return WorkoutActivityType.pickleball;
      case 80:
        return WorkoutActivityType.cooldown;
      case 82:
        return WorkoutActivityType.swimBikeRun;
      case 83:
        return WorkoutActivityType.transition;
      case 84:
        return WorkoutActivityType.underwaterDiving;
      case 3000:
        return WorkoutActivityType.other;
      default:
        throw InvalidValueException('Unknown value: $value');
    }
  }
}