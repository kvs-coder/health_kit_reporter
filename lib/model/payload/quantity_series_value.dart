import '../decorator/extensions.dart';

/// Equivalent of [QuantitySeriesValue]
/// from [HealthKitReporter] https://github.com/kvs-coder/HealthKitReporter
///
/// One quantity inside a quantity series sample.
///
/// Supports [map] representation.
///
/// Has a [QuantitySeriesValue.fromJson] constructor
/// to create instances from JSON payload coming from iOS native code.
/// And supports multiple object creation by [collect] method from JSON list.
///
class QuantitySeriesValue {
  const QuantitySeriesValue(
    this.value,
    this.unit,
    this.startTimestamp,
    this.endTimestamp, [
    this.sampleUUID,
  ]);

  final num value;
  final String unit;

  /// Seconds since 1970
  final num startTimestamp;

  /// Seconds since 1970
  final num endTimestamp;

  /// The uuid of the series sample the value belongs to; null when writing
  final String? sampleUUID;

  /// General map representation
  ///
  Map<String, dynamic> get map => {
        'value': value,
        'unit': unit,
        'startTimestamp': startTimestamp,
        'endTimestamp': endTimestamp,
        'sampleUUID': sampleUUID,
      };

  /// General constructor from JSON payload
  ///
  QuantitySeriesValue.fromJson(Map<String, dynamic> json)
      : value = parseNum(json['value']),
        unit = json['unit'],
        startTimestamp = parseNum(json['startTimestamp']),
        endTimestamp = parseNum(json['endTimestamp']),
        sampleUUID = json['sampleUUID'];

  /// Simplifies creating a list of objects from JSON payload.
  ///
  static List<QuantitySeriesValue> collect(List<dynamic> list) =>
      parseList(list, QuantitySeriesValue.fromJson);
}
