import '../decorator/extensions.dart';
import '../type/audiogram_type.dart';
import 'metadata.dart';
import 'sample.dart';

/// Equivalent of [Audiogram]
/// from [HealthKitReporter] https://github.com/kvs-coder/HealthKitReporter
///
/// Hearing test result. Frequencies are in hertz (Hz),
/// sensitivities in decibel hearing level (dBHL).
///
/// Supports [map] representation.
///
/// Has a [Audiogram.fromJson] constructor
/// to create instances from JSON payload coming from iOS native code.
/// And supports multiple object creation by [collect] method from JSON list.
///
/// Requires [AudiogramType] permissions provided.
///
class Audiogram extends Sample<AudiogramHarmonized> {
  const Audiogram(
    super.uuid,
    super.identifier,
    super.startTimestamp,
    super.endTimestamp,
    super.device,
    super.sourceRevision,
    super.harmonized,
  );

  /// General map representation
  ///
  @override
  Map<String, dynamic> get map => {
        'uuid': uuid,
        'identifier': identifier,
        'startTimestamp': startTimestamp,
        'endTimestamp': endTimestamp,
        'device': device?.map,
        'sourceRevision': sourceRevision.map,
        'harmonized': harmonized.map,
      };

  /// General constructor from JSON payload
  ///
  Audiogram.fromJson(Map<String, dynamic> json)
      : super.from(
            json,
            AudiogramHarmonized.fromJson(
                Map<String, dynamic>.from(json['harmonized'])));

  /// Simplifies creating a list of objects from JSON payload.
  ///
  static List<Audiogram> collect(List<dynamic> list) =>
      parseList(list, Audiogram.fromJson);
}

/// Equivalent of [Audiogram.Harmonized]
/// from [HealthKitReporter] https://github.com/kvs-coder/HealthKitReporter
///
/// HealthKit saves 1 to 30 points with unique, ascending frequencies.
///
class AudiogramHarmonized {
  const AudiogramHarmonized(
    this.sensitivityPoints,
    this.metadata,
  );

  final List<AudiogramSensitivityPoint> sensitivityPoints;
  final Metadata? metadata;

  /// General map representation
  ///
  Map<String, dynamic> get map => {
        'sensitivityPoints': sensitivityPoints.map((e) => e.map).toList(),
        'metadata': metadata?.map,
      };

  /// General constructor from JSON payload
  ///
  AudiogramHarmonized.fromJson(Map<String, dynamic> json)
      : sensitivityPoints = parseList(
            json['sensitivityPoints'], AudiogramSensitivityPoint.fromJson),
        metadata = Metadata.tryFromJson(json['metadata']);
}

/// Equivalent of [Audiogram.SensitivityPoint]
/// from [HealthKitReporter] https://github.com/kvs-coder/HealthKitReporter
///
/// Hearing sensitivity of both ears at one frequency.
///
class AudiogramSensitivityPoint {
  const AudiogramSensitivityPoint(
    this.frequency,
    this.leftEarSensitivity,
    this.rightEarSensitivity, [
    this.tests,
  ]);

  /// Hz
  final num frequency;

  /// dBHL
  final num? leftEarSensitivity;

  /// dBHL
  final num? rightEarSensitivity;

  /// Tests behind the sensitivities (iOS 18.1+, read only)
  final List<AudiogramTest>? tests;

  /// General map representation
  ///
  Map<String, dynamic> get map => {
        'frequency': frequency,
        'leftEarSensitivity': leftEarSensitivity,
        'rightEarSensitivity': rightEarSensitivity,
        'tests': tests?.map((e) => e.map).toList(),
      };

  /// General constructor from JSON payload
  ///
  AudiogramSensitivityPoint.fromJson(Map<String, dynamic> json)
      : frequency = parseNum(json['frequency']),
        leftEarSensitivity = tryParseNum(json['leftEarSensitivity']),
        rightEarSensitivity = tryParseNum(json['rightEarSensitivity']),
        tests = json['tests'] == null
            ? null
            : parseList(json['tests'], AudiogramTest.fromJson);
}

/// Equivalent of [Audiogram.Test]
/// from [HealthKitReporter] https://github.com/kvs-coder/HealthKitReporter
///
/// One test at a frequency (iOS 18.1+).
///
class AudiogramTest {
  const AudiogramTest(
    this.sensitivity,
    this.conductionType,
    this.masked,
    this.side,
  );

  /// dBHL
  final num sensitivity;

  /// 0 air conduction (HKAudiogramConductionType)
  final int conductionType;
  final bool masked;

  /// 0 left, 1 right (HKAudiogramSensitivityTestSide)
  final int side;

  /// General map representation
  ///
  Map<String, dynamic> get map => {
        'sensitivity': sensitivity,
        'conductionType': conductionType,
        'masked': masked,
        'side': side,
      };

  /// General constructor from JSON payload
  ///
  AudiogramTest.fromJson(Map<String, dynamic> json)
      : sensitivity = parseNum(json['sensitivity']),
        conductionType = parseNum(json['conductionType']).toInt(),
        masked = json['masked'],
        side = parseNum(json['side']).toInt();
}
