import 'package:health_kit_reporter/health_kit_reporter.dart';
import 'package:health_kit_reporter/model/payload/category.dart';
import 'package:health_kit_reporter/model/payload/metadata.dart';
import 'package:health_kit_reporter/model/payload/quantity.dart';
import 'package:health_kit_reporter/model/payload/sample.dart';
import 'package:health_kit_reporter/model/payload/workout.dart';
import 'package:health_kit_reporter/model/payload/workout_activity_type.dart';
import 'package:health_kit_reporter/model/predicate.dart';
import 'package:health_kit_reporter/model/type/category_type.dart';
import 'package:health_kit_reporter/model/type/quantity_type.dart';
import 'package:health_kit_reporter/model/type/workout_type.dart';

import 'health_types.dart';
import 'samples.dart';

/// Writes a week of plausible data for every writable type, and deletes it again.
///
/// Seeded samples carry an `HKExternalUUID` starting with [marker] and the day,
/// so seeding runs once per day and type, and [deleteSeeded] removes only
/// the data this app wrote.
class Seeding {
  static const marker = 'hkr-seed-';

  static Predicate get _lastWeek {
    final today = _startOfToday;
    return Predicate(today.subtract(const Duration(days: 7)), today);
  }

  static DateTime get _startOfToday {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  static Future<String> seed() async {
    final types = await HealthTypes.load();
    final writable = types.write.toSet();
    var saved = 0;
    final failed = <String>[];
    final skipped = <String>[];
    final units = await _units(writable);
    for (final identifier in _seedableTypes(writable)) {
      final Set<String> seededDays;
      try {
        seededDays = await _seededDays(identifier);
      } catch (_) {
        // not authorized to read the type, so seeding can't tell what exists
        failed.add(identifier);
        continue;
      }
      final samples = <Sample>[];
      for (var offset = 1; offset <= 7; offset++) {
        final day = _startOfToday.subtract(Duration(days: offset));
        final key = _dayKey(day);
        if (seededDays.contains(key)) continue;
        final payloads = _payloads(identifier, day, offset, units);
        if (payloads == null) {
          skipped.add(identifier);
          break;
        }
        samples.addAll(payloads);
      }
      if (samples.isEmpty) continue;
      try {
        // all-or-nothing per type, so a type HealthKit rejects is reported once
        saved += (await HealthKitReporter.saveSamples(samples)).length;
      } catch (e) {
        failed.add(identifier);
      }
    }
    return [
      'Seeded $saved samples for the last 7 days',
      if (skipped.isNotEmpty)
        'skipped ${skipped.length} types without a plausible value',
      if (failed.isNotEmpty) 'failed: ${failed.map(_short).join(', ')}',
    ].join('\n');
  }

  static Future<String> deleteSeeded() async {
    final types = await HealthTypes.load();
    final own = <Sample>[];
    for (final identifier in _seedableTypes(types.write.toSet())) {
      try {
        own.addAll((await HealthKitReporter.sampleQuery(identifier, _lastWeek))
            .where((sample) =>
                const DemoSamples(marker).marks(sample, _metadata(sample))));
      } catch (_) {
        // not authorized to read the type
      }
    }
    if (own.isEmpty) return 'No seeded data to delete';
    // looked up by the uuids the query returned
    await HealthKitReporter.deleteSamples(own);
    return 'Deleted ${own.length} seeded samples';
  }

  static Iterable<String> _seedableTypes(Set<String> writable) => [
        ...QuantityType.values.map((e) => e.identifier),
        ...CategoryType.values.map((e) => e.identifier),
        WorkoutType.workoutType.identifier,
        // two enum cases may name the same HealthKit type
      ].where(writable.contains).toSet();

  static Future<Map<String, String>> _units(Set<String> writable) async {
    final quantityTypes =
        QuantityType.values.where((e) => writable.contains(e.identifier));
    final units = <String, String>{};
    for (final type in quantityTypes) {
      try {
        final preferred = await HealthKitReporter.preferredUnits([type]);
        units[type.identifier] = preferred.single.unit;
      } catch (_) {
        // no preferred unit, e.g. the type is not authorized
      }
    }
    return units;
  }

  static Future<Set<String>> _seededDays(String identifier) async {
    final samples = await HealthKitReporter.sampleQuery(identifier, _lastWeek);
    return samples
        .where((sample) =>
            const DemoSamples(marker).marks(sample, _metadata(sample)))
        .map((sample) => _metadata(sample)?[externalUUIDKey])
        .whereType<MetadataString>()
        .where((value) => value.value.startsWith(marker))
        .map((value) => value.value.substring(marker.length).substring(0, 10))
        .toSet();
  }

  static Metadata? _metadata(Sample sample) {
    if (sample is Quantity) return sample.harmonized.metadata;
    if (sample is Category) return sample.harmonized.metadata;
    if (sample is Workout) return sample.harmonized.metadata;
    return null;
  }

  static String _dayKey(DateTime day) =>
      '${day.year}-${day.month.toString().padLeft(2, '0')}-${day.day.toString().padLeft(2, '0')}';

  static String _short(String identifier) =>
      identifier.replaceFirst(RegExp(r'^HK\w+TypeIdentifier'), '');

  /// Two samples per quantity type and day, one per category type and day,
  /// one workout per day; null when the demo has no plausible value for the type
  static List<Sample>? _payloads(
      String identifier, DateTime day, int offset, Map<String, String> units) {
    final samples = DemoSamples('$marker${_dayKey(day)}-');
    if (identifier == WorkoutType.workoutType.identifier) {
      return [
        samples.workout(
            WorkoutActivityType.running,
            day.add(const Duration(hours: 18)),
            Duration(minutes: 30 + offset * 5),
            kilocalories: 250 + offset * 10,
            meters: 4000 + offset * 200)
      ];
    }
    final categoryType = CategoryTypeFactory.tryFrom(identifier);
    if (categoryType != null) {
      final values = _validValues(categoryType);
      final start = day.add(const Duration(hours: 22));
      return [
        samples.category(identifier, values[offset % values.length], start,
            start.add(const Duration(hours: 1)),
            metadata: {
              if (categoryType == CategoryType.menstrualFlow)
                'HKMenstrualCycleStart': MetadataBool(offset == 7),
            })
      ];
    }
    final quantityType = QuantityTypeFactory.tryFrom(identifier);
    if (quantityType == null) return null;
    final plausible = _plausibleValues(quantityType, units[identifier]);
    if (plausible == null) return null;
    final (unit, low, high) = plausible;
    return [9, 19].map((hour) {
      final start = day.add(Duration(hours: hour));
      final fraction = ((offset * 7 + hour) % 10) / 10;
      return samples.quantity(
          identifier, low + (high - low) * fraction, unit, start,
          end: start.add(const Duration(minutes: 10)),
          metadata: {
            if (quantityType == QuantityType.insulinDelivery)
              'HKInsulinDeliveryReason': const MetadataNumber(1),
          });
    }).toList();
  }

  /// Plausible values by unit, for types without an override
  static const _defaultRanges = <String, (num, num)>{
    'count/min': (60, 100),
    'count': (1, 200),
    '%': (0.2, 0.9),
    'm/s': (1, 3),
    'm': (200, 3000),
    'g': (1, 30),
    'kcal': (20, 300),
    's': (300, 1800),
    'min': (5, 30),
    'degC': (36.4, 37.2),
    'mmHg': (75, 120),
    'ml/(kg*min)': (35, 50),
    'mL/kg·min': (35, 50),
    'L/min': (300, 500),
    'L': (2.5, 4.5),
    'mg/dL': (80, 120),
    'IU': (1, 8),
    'S': (0.000001, 0.00001),
    'W': (80, 250),
    'dBASPL': (40, 75),
    'appleEffortScore': (2, 8),
  };

  /// Types whose plausible values differ from the default of their unit
  static const _overrides = <QuantityType, (String, num, num)>{
    QuantityType.bodyMass: ('kg', 65, 80),
    QuantityType.leanBodyMass: ('kg', 50, 60),
    QuantityType.height: ('m', 1.70, 1.80),
    QuantityType.waistCircumference: ('m', 0.75, 0.90),
    QuantityType.bodyMassIndex: ('count', 21, 25),
    QuantityType.bodyFatPercentage: ('%', 0.15, 0.25),
    QuantityType.oxygenSaturation: ('%', 0.95, 0.99),
    QuantityType.bloodAlcoholContent: ('%', 0, 0.0005),
    QuantityType.peripheralPerfusionIndex: ('%', 0.02, 0.10),
    QuantityType.heartRateVariabilitySDNN: ('s', 0.03, 0.08),
    QuantityType.restingHeartRate: ('count/min', 55, 70),
    QuantityType.respiratoryRate: ('count/min', 12, 18),
    QuantityType.bloodPressureSystolic: ('mmHg', 110, 125),
    QuantityType.bloodPressureDiastolic: ('mmHg', 70, 82),
    QuantityType.basalBodyTemperature: ('degC', 36.2, 36.7),
    QuantityType.bodyTemperature: ('degC', 36.4, 37.0),
    QuantityType.uvExposure: ('count', 1, 8),
    QuantityType.flightsClimbed: ('count', 1, 15),
    QuantityType.stepCount: ('count', 300, 2000),
    QuantityType.numberOfTimesFallen: ('count', 1, 1),
    QuantityType.inhalerUsage: ('count', 1, 2),
    QuantityType.pushCount: ('count', 50, 400),
    QuantityType.swimmingStrokeCount: ('count', 20, 200),
    QuantityType.dietaryWater: ('L', 0.2, 0.5),
    QuantityType.dietaryCaffeine: ('g', 0.05, 0.2),
    QuantityType.vo2Max: ('ml/(kg*min)', 35, 50),
    QuantityType.cyclingCadence: ('count/min', 70, 95),
    QuantityType.physicalEffort: ('kcal/hr·kg', 2, 8),
    QuantityType.workoutEffortScore: ('appleEffortScore', 2, 8),
    QuantityType.estimatedWorkoutEffortScore: ('appleEffortScore', 2, 8),
    QuantityType.timeInDaylight: ('min', 10, 60),
  };

  static (String, num, num)? _plausibleValues(QuantityType type, String? unit) {
    final override = _overrides[type];
    if (override != null) return override;
    if (unit == null) return null;
    final range = _defaultRanges[unit];
    return range == null ? null : (unit, range.$1, range.$2);
  }

  /// Raw values of the HKCategoryValue… enum each category type uses
  static List<int> _validValues(CategoryType type) {
    switch (type) {
      case CategoryType.sleepAnalysis:
        return [0, 1, 2, 3, 4, 5];
      case CategoryType.menstrualFlow:
      case CategoryType.cervicalMucusQuality:
        return [1, 2, 3, 4, 5];
      case CategoryType.ovulationTestResult:
        return [1, 2, 3, 4];
      case CategoryType.bleedingAfterPregnancy:
      case CategoryType.bleedingDuringPregnancy:
        return [1, 2, 3, 4, 5];
      case CategoryType.contraceptive:
        return [1, 2, 3, 4, 5, 6, 7];
      case CategoryType.appetiteChanges:
        return [0, 1, 2, 3];
      case CategoryType.pregnancyTestResult:
      case CategoryType.progesteroneTestResult:
        return [1, 2, 3];
      case CategoryType.moodChanges:
      case CategoryType.sleepChanges:
        return [0, 1];
      case CategoryType.abdominalCramps:
      case CategoryType.acne:
      case CategoryType.bladderIncontinence:
      case CategoryType.bloating:
      case CategoryType.breastPain:
      case CategoryType.chestTightnessOrPain:
      case CategoryType.chills:
      case CategoryType.constipation:
      case CategoryType.coughing:
      case CategoryType.diarrhea:
      case CategoryType.dizziness:
      case CategoryType.drySkin:
      case CategoryType.fainting:
      case CategoryType.fatigue:
      case CategoryType.fever:
      case CategoryType.generalizedBodyAche:
      case CategoryType.hairLoss:
      case CategoryType.headache:
      case CategoryType.heartburn:
      case CategoryType.hotFlashes:
      case CategoryType.lossOfSmell:
      case CategoryType.lossOfTaste:
      case CategoryType.lowerBackPain:
      case CategoryType.memoryLapse:
      case CategoryType.nausea:
      case CategoryType.nightSweats:
      case CategoryType.pelvicPain:
      case CategoryType.rapidPoundingOrFlutteringHeartbeat:
      case CategoryType.runnyNose:
      case CategoryType.shortnessOfBreath:
      case CategoryType.sinusCongestion:
      case CategoryType.skippedHeartbeat:
      case CategoryType.soreThroat:
      case CategoryType.vaginalDryness:
      case CategoryType.vomiting:
      case CategoryType.wheezing:
        return [0, 1, 2, 3, 4];
      default:
        return [0];
    }
  }
}
