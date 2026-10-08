import '../decorator/extensions.dart';

/// Equivalent of [Metadata]
/// from [HealthKitReporter] https://github.com/kvs-coder/HealthKitReporter
///
/// A flat JSON object whose values are strings, numbers, booleans,
/// dates as `{"timestamp": <seconds since 1970>}`
/// and quantities as `{"value": <number>, "unit": <unit>}`.
///
/// Supports [map] representation, which the native side reads back
/// when saving samples.
///
class Metadata {
  const Metadata(this.values);

  final Map<String, MetadataValue> values;

  /// The value for [key], or null
  ///
  MetadataValue? operator [](String key) => values[key];

  /// General map representation
  ///
  Map<String, dynamic> get map =>
      values.map((key, value) => MapEntry(key, value.json));

  /// General constructor from JSON payload
  ///
  Metadata.fromJson(Map<String, dynamic> json)
      : values = json
            .map((key, value) => MapEntry(key, MetadataValue.fromJson(value)));

  /// Null for a missing metadata object
  ///
  static Metadata? tryFromJson(dynamic json) =>
      json == null ? null : Metadata.fromJson(Map<String, dynamic>.from(json));

  @override
  bool operator ==(Object other) =>
      other is Metadata &&
      other.values.length == values.length &&
      values.entries.every((entry) => other.values[entry.key] == entry.value);

  @override
  int get hashCode => Object.hashAllUnordered(
      values.entries.map((entry) => Object.hash(entry.key, entry.value)));

  @override
  String toString() => 'Metadata($values)';
}

/// A value of [Metadata]:
/// - [MetadataString]
/// - [MetadataNumber]
/// - [MetadataBool]
/// - [MetadataDate]
/// - [MetadataQuantity]
///
sealed class MetadataValue {
  const MetadataValue();

  /// The JSON value of the payload
  ///
  dynamic get json;

  /// Creates the value from its JSON representation
  ///
  factory MetadataValue.fromJson(dynamic json) {
    if (json is bool) return MetadataBool(json);
    if (json is num) return MetadataNumber(json);
    if (json is String) return MetadataString(json);
    if (json is Map) {
      if (json.length == 1 && json['timestamp'] != null) {
        return MetadataDate(parseNum(json['timestamp']));
      }
      if (json.length == 2 && json['value'] != null && json['unit'] is String) {
        return MetadataQuantity(parseNum(json['value']), json['unit']);
      }
    }
    throw FormatException('Invalid metadata value: $json');
  }
}

/// A [String] metadata value
///
final class MetadataString extends MetadataValue {
  const MetadataString(this.value);

  final String value;

  @override
  String get json => value;

  @override
  bool operator ==(Object other) =>
      other is MetadataString && other.value == value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'MetadataString($value)';
}

/// A [num] metadata value
///
final class MetadataNumber extends MetadataValue {
  const MetadataNumber(this.value);

  final num value;

  @override
  num get json => value;

  @override
  bool operator ==(Object other) =>
      other is MetadataNumber && other.value == value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'MetadataNumber($value)';
}

/// A [bool] metadata value
///
final class MetadataBool extends MetadataValue {
  const MetadataBool(this.value);

  final bool value;

  @override
  bool get json => value;

  @override
  bool operator ==(Object other) =>
      other is MetadataBool && other.value == value;

  @override
  int get hashCode => value.hashCode;

  @override
  String toString() => 'MetadataBool($value)';
}

/// A date metadata value; [timestamp] is seconds since 1970
///
final class MetadataDate extends MetadataValue {
  const MetadataDate(this.timestamp);

  /// Creates the value from a [DateTime]
  ///
  MetadataDate.fromDateTime(DateTime date)
      : timestamp = date.microsecondsSinceEpoch / 1000000;

  final num timestamp;

  DateTime get date => dateFromSeconds(timestamp);

  @override
  Map<String, num> get json => {'timestamp': timestamp};

  @override
  bool operator ==(Object other) =>
      other is MetadataDate && other.timestamp == timestamp;

  @override
  int get hashCode => timestamp.hashCode;

  @override
  String toString() => 'MetadataDate($timestamp)';
}

/// A quantity metadata value, e.g. 120 count/min
///
final class MetadataQuantity extends MetadataValue {
  const MetadataQuantity(this.value, this.unit);

  final num value;
  final String unit;

  @override
  Map<String, dynamic> get json => {'value': value, 'unit': unit};

  @override
  bool operator ==(Object other) =>
      other is MetadataQuantity && other.value == value && other.unit == unit;

  @override
  int get hashCode => Object.hash(value, unit);

  @override
  String toString() => 'MetadataQuantity($value $unit)';
}
