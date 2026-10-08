/// General date extension
///
extension Date on String {
  /// Try to parse the date coming from native side
  /// Expected format from native side is [yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ]
  ///
  DateTime get date => DateTime.parse(this);
}

/// Reads a number of the JSON payload.
///
/// JSON has no infinity or NaN, so the native side sends non-finite numbers
/// as the strings `"Infinity"`, `"-Infinity"` and `"NaN"`.
///
num parseNum(dynamic value) {
  if (value is num) return value;
  if (value is String) return double.parse(value);
  throw FormatException('Expected a number, got $value');
}

/// [parseNum] for optional fields.
///
num? tryParseNum(dynamic value) => value == null ? null : parseNum(value);

/// Reads a list of JSON objects, e.g. a nested payload list.
///
List<T> parseList<T>(
    dynamic value, T Function(Map<String, dynamic> json) fromJson) {
  if (value == null) return <T>[];
  return List<dynamic>.from(value)
      .map((e) => fromJson(Map<String, dynamic>.from(e)))
      .toList();
}

/// Seconds since 1970, as the payload timestamps hold them, to [DateTime].
///
DateTime dateFromSeconds(num seconds) =>
    DateTime.fromMicrosecondsSinceEpoch((seconds * 1000000).round());
