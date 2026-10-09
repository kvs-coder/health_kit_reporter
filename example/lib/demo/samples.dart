import 'package:health_kit_reporter/model/payload/category.dart';
import 'package:health_kit_reporter/model/payload/device.dart';
import 'package:health_kit_reporter/model/payload/metadata.dart';
import 'package:health_kit_reporter/model/payload/quantity.dart';
import 'package:health_kit_reporter/model/payload/sample.dart';
import 'package:health_kit_reporter/model/payload/source.dart';
import 'package:health_kit_reporter/model/payload/source_revision.dart';
import 'package:health_kit_reporter/model/payload/workout.dart';
import 'package:health_kit_reporter/model/payload/workout_activity_type.dart';

/// Metadata key HealthKit keeps for an identifier of the writing app
const externalUUIDKey = 'HKExternalUUID';

/// Builds the payloads the demo writes. Each carries an [externalUUIDKey]
/// starting with [marker], so the demo finds and deletes only its own data.
///
/// New samples have no uuid yet: HealthKit gives the stored sample one,
/// which `HealthKitReporter.save` returns.
/// Timestamps of samples sent to the native side are milliseconds since 1970.
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
        start.millisecondsSinceEpoch,
        (end ?? start).millisecondsSinceEpoch,
        device,
        sourceRevision,
        QuantityHarmonized(value, unit, this.metadata(metadata)),
      );

  Category category(String identifier, int value, DateTime start, DateTime end,
          {Map<String, MetadataValue> metadata = const {}}) =>
      Category(
        '',
        identifier,
        start.millisecondsSinceEpoch,
        end.millisecondsSinceEpoch,
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
        start.millisecondsSinceEpoch,
        start.add(duration).millisecondsSinceEpoch,
        device,
        sourceRevision,
        WorkoutHarmonized(type, kilocalories, 'kcal', meters, 'm', null,
            'count', null, 'count', metadata()),
        duration.inSeconds,
        const [],
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
