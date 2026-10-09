import '../decorator/extensions.dart';
import '../type/state_of_mind_type.dart';
import 'metadata.dart';
import 'sample.dart';
import 'payload.dart';

/// Equivalent of [StateOfMind]
/// from [HealthKitReporter] https://github.com/kvs-coder/HealthKitReporter
///
/// Logged emotion or mood (iOS 18+).
/// Raw values follow HKStateOfMind: kind 1 momentary emotion, 2 daily mood;
/// valence classification 1 very unpleasant ... 7 very pleasant;
/// labels and associations their enum raw values.
///
/// Supports [map] representation.
///
/// Has a [StateOfMind.fromJson] constructor
/// to create instances from JSON payload coming from iOS native code.
/// And supports multiple object creation by [collect] method from JSON list.
///
/// Requires [StateOfMindType] permissions provided.
///
class StateOfMind extends Sample<StateOfMindHarmonized> {
  const StateOfMind(
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
  StateOfMind.fromJson(Map<String, dynamic> json)
      : super.from(
            json,
            StateOfMindHarmonized.fromJson(
                Map<String, dynamic>.from(json['harmonized'])));

  /// Simplifies creating a list of objects from JSON payload.
  ///
  static List<StateOfMind> collect(List<dynamic> list) =>
      parseList(list, StateOfMind.fromJson);
}

/// Equivalent of [StateOfMind.Harmonized]
/// from [HealthKitReporter] https://github.com/kvs-coder/HealthKitReporter
///
class StateOfMindHarmonized with Payload {
  const StateOfMindHarmonized(
    this.kind,
    this.valence,
    this.valenceClassification,
    this.labels,
    this.associations,
    this.metadata,
  );

  /// 1 momentary emotion, 2 daily mood
  final int kind;

  /// -1 very unpleasant ... 1 very pleasant
  final num valence;

  /// Read only, derived from the [valence]
  final int? valenceClassification;
  final List<int> labels;
  final List<int> associations;
  final Metadata? metadata;

  /// General map representation
  ///
  @override
  Map<String, dynamic> get map => {
        'kind': kind,
        'valence': valence,
        'valenceClassification': valenceClassification,
        'labels': labels,
        'associations': associations,
        'metadata': metadata?.map,
      };

  /// General constructor from JSON payload
  ///
  StateOfMindHarmonized.fromJson(Map<String, dynamic> json)
      : kind = parseNum(json['kind']).toInt(),
        valence = parseNum(json['valence']),
        valenceClassification =
            tryParseNum(json['valenceClassification'])?.toInt(),
        labels = parseInts(json['labels']),
        associations = parseInts(json['associations']),
        metadata = Metadata.tryFromJson(json['metadata']);
}
