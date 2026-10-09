import 'package:health_kit_reporter/model/decorator/extensions.dart';
import 'package:health_kit_reporter/model/payload/audiogram.dart';
import 'package:health_kit_reporter/model/payload/category.dart';
import 'package:health_kit_reporter/model/payload/device.dart';
import 'package:health_kit_reporter/model/payload/metadata.dart';
import 'package:health_kit_reporter/model/payload/heartbeat_series.dart';
import 'package:health_kit_reporter/model/payload/quantity.dart';
import 'package:health_kit_reporter/model/payload/sample.dart';
import 'package:health_kit_reporter/model/payload/scored_assessment.dart';
import 'package:health_kit_reporter/model/payload/source.dart';
import 'package:health_kit_reporter/model/payload/source_revision.dart';
import 'package:health_kit_reporter/model/payload/state_of_mind.dart';
import 'package:health_kit_reporter/model/payload/vision_prescription.dart';
import 'package:health_kit_reporter/model/payload/workout.dart';
import 'package:health_kit_reporter/model/payload/workout_activity_type.dart';
import 'package:health_kit_reporter/model/type/audiogram_type.dart';
import 'package:health_kit_reporter/model/type/scored_assessment_type.dart';
import 'package:health_kit_reporter/model/type/series_type.dart';
import 'package:health_kit_reporter/model/type/state_of_mind_type.dart';
import 'package:health_kit_reporter/model/type/vision_prescription_type.dart';

/// Metadata key HealthKit keeps for an identifier of the writing app
const externalUUIDKey = 'HKExternalUUID';

/// Builds the payloads the demo writes. Each carries an [externalUUIDKey]
/// starting with [marker], so the demo finds and deletes only its own data.
///
/// New samples have no uuid yet: HealthKit gives the stored sample one,
/// which `HealthKitReporter.save` returns.
/// Timestamps of samples are seconds since 1970, also when built in Dart.
class DemoSamples {
  const DemoSamples(this.marker);

  final String marker;

  static int _counter = 0;

  /// HealthKit sets the real source on save; the payload only needs a placeholder
  static const sourceRevision = SourceRevision(
    Source('health_kit_reporter example', 'com.kvs.healthKitReporterExample'),
    null,
    null,
    '18.0.0',
    OperatingSystem(18, 0, 0),
  );

  static const device =
      Device('Flutter', 'kvs', 'example', null, null, null, null, null);

  Metadata metadata([Map<String, MetadataValue> extra = const {}]) => Metadata({
        externalUUIDKey: MetadataString(
            '$marker${DateTime.now().microsecondsSinceEpoch}-${_counter++}'),
        ...extra,
      });

  Quantity quantity(String identifier, num value, String unit, DateTime start,
          {DateTime? end, Map<String, MetadataValue> metadata = const {}}) =>
      Quantity(
        '',
        identifier,
        start.secondsSinceEpoch,
        (end ?? start).secondsSinceEpoch,
        device,
        sourceRevision,
        QuantityHarmonized(value, unit, this.metadata(metadata)),
      );

  Category category(String identifier, int value, DateTime start, DateTime end,
          {Map<String, MetadataValue> metadata = const {}}) =>
      Category(
        '',
        identifier,
        start.secondsSinceEpoch,
        end.secondsSinceEpoch,
        device,
        sourceRevision,
        CategoryHarmonized(
            value, 'HKCategoryValue', 'demo', this.metadata(metadata)),
      );

  Workout workout(WorkoutActivityType type, DateTime start, Duration duration,
          {num kilocalories = 250, num meters = 3000}) =>
      Workout(
        '',
        'HKWorkoutTypeIdentifier',
        start.secondsSinceEpoch,
        start.add(duration).secondsSinceEpoch,
        device,
        sourceRevision,
        WorkoutHarmonized(type, kilocalories, 'kcal', meters, 'm', null,
            'count', null, 'count', metadata()),
        duration.inSeconds,
        const [],
      );

  /// Hearing thresholds of both ears at 500 to 4000 Hz
  Audiogram audiogram(DateTime date) => Audiogram(
        '',
        AudiogramType.audiogram.identifier,
        date.secondsSinceEpoch,
        date.secondsSinceEpoch,
        device,
        sourceRevision,
        AudiogramHarmonized([
          for (final (frequency, sensitivity) in [
            (500, 15),
            (1000, 20),
            (2000, 25),
            (4000, 30),
          ])
            AudiogramSensitivityPoint(frequency, sensitivity, sensitivity + 5),
        ], metadata()),
      );

  /// A slightly pleasant momentary emotion: happy (label 14) about work (association 18)
  StateOfMind stateOfMind(DateTime date) => StateOfMind(
        '',
        StateOfMindType.stateOfMind.identifier,
        date.secondsSinceEpoch,
        date.secondsSinceEpoch,
        device,
        sourceRevision,
        StateOfMindHarmonized(1, 0.4, null, const [14], const [18], metadata()),
      );

  /// A GAD-7 questionnaire; HealthKit computes its score and risk
  ScoredAssessment gad7(DateTime date) => ScoredAssessment(
        '',
        ScoredAssessmentType.gad7.identifier,
        date.secondsSinceEpoch,
        date.secondsSinceEpoch,
        device,
        sourceRevision,
        ScoredAssessmentHarmonized(
            const [1, 0, 1, 2, 0, 1, 0], null, null, metadata()),
      );

  /// Beats about every 0.8 s, from [start]
  HeartbeatSeries heartbeatSeries(DateTime start, {int beats = 20}) =>
      HeartbeatSeries(
        '',
        SeriesType.heartbeatSeries.identifier,
        start.secondsSinceEpoch,
        start.add(Duration(milliseconds: 800 * beats)).secondsSinceEpoch,
        device,
        sourceRevision,
        HeartbeatSeriesHarmonized(
          beats,
          [
            for (var beat = 0; beat < beats; beat++)
              HeartbeatSeriesMeasurement(beat * 0.8 + (beat.isEven ? 0.02 : 0),
                  false, beat == beats - 1),
          ],
          metadata(),
        ),
      );

  /// Contacts prescribed at [date]
  VisionPrescription visionPrescription(DateTime date) => VisionPrescription(
        '',
        VisionPrescriptionType.visionPrescription.identifier,
        date.secondsSinceEpoch,
        date.secondsSinceEpoch,
        device,
        sourceRevision,
        VisionPrescriptionHarmonized(
          date.secondsSinceEpoch,
          date.add(const Duration(days: 365)).secondsSinceEpoch,
          PrescriptionType.contacts,
          const LensSpecification(-2, baseCurve: 8.6, diameter: 14.2),
          const LensSpecification(-1.75, baseCurve: 8.6, diameter: 14.2),
          'hkr demo',
          metadata(),
        ),
      );

  /// Whether this app wrote [sample] with this demo's marker.
  /// Other apps (e.g. the HealthKitReporter example) may use the same marker,
  /// and HealthKit doesn't let an app delete their samples.
  bool marks(Sample sample, Metadata? metadata) {
    final value = metadata?[externalUUIDKey];
    return sample.sourceRevision.source.bundleIdentifier ==
            sourceRevision.source.bundleIdentifier &&
        value is MetadataString &&
        value.value.startsWith(marker);
  }
}
