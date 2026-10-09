import '../decorator/extensions.dart';
import '../type/scored_assessment_type.dart';
import 'metadata.dart';
import 'sample.dart';

/// Equivalent of [ScoredAssessment]
/// from [HealthKitReporter] https://github.com/kvs-coder/HealthKitReporter
///
/// GAD-7 or PHQ-9 questionnaire (iOS 18+), told apart by [identifier].
/// Answers are 0 not at all, 1 several days, 2 more than half the days,
/// 3 nearly every day, and 4 prefer not to answer (PHQ-9 question 9 only).
///
/// Supports [map] representation.
///
/// Has a [ScoredAssessment.fromJson] constructor
/// to create instances from JSON payload coming from iOS native code.
/// And supports multiple object creation by [collect] method from JSON list.
///
/// Requires [ScoredAssessmentType] permissions provided.
///
class ScoredAssessment extends Sample<ScoredAssessmentHarmonized> {
  const ScoredAssessment(
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
  ScoredAssessment.fromJson(Map<String, dynamic> json)
      : super.from(
            json,
            ScoredAssessmentHarmonized.fromJson(
                Map<String, dynamic>.from(json['harmonized'])));

  /// Simplifies creating a list of objects from JSON payload.
  ///
  static List<ScoredAssessment> collect(List<dynamic> list) =>
      parseList(list, ScoredAssessment.fromJson);
}

/// Equivalent of [ScoredAssessment.Harmonized]
/// from [HealthKitReporter] https://github.com/kvs-coder/HealthKitReporter
///
/// HealthKit saves exactly 7 (GAD-7) or 9 (PHQ-9) [answers].
///
class ScoredAssessmentHarmonized {
  const ScoredAssessmentHarmonized(
    this.answers,
    this.score,
    this.risk,
    this.metadata,
  );

  final List<int> answers;

  /// Read only, computed by HealthKit
  final int? score;

  /// Read only, computed by HealthKit (HKGAD7Assessment.Risk / HKPHQ9Assessment.Risk)
  final int? risk;
  final Metadata? metadata;

  /// General map representation
  ///
  Map<String, dynamic> get map => {
        'answers': answers,
        'score': score,
        'risk': risk,
        'metadata': metadata?.map,
      };

  /// General constructor from JSON payload
  ///
  ScoredAssessmentHarmonized.fromJson(Map<String, dynamic> json)
      : answers = parseInts(json['answers']),
        score = tryParseNum(json['score'])?.toInt(),
        risk = tryParseNum(json['risk'])?.toInt(),
        metadata = Metadata.tryFromJson(json['metadata']);
}
