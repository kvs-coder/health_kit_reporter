/// Equivalent of [Payload]
/// from [HealthKitReporter] https://github.com/kvs-coder/HealthKitReporter
///
/// Gives a model value equality, a hash and a readable [toString]
/// from its [map]: two payloads are equal when their types and every field,
/// nested ones too, are equal. Samples compare their [uuid] and their contents,
/// so a sample read twice equals itself, while a copy saved again
/// under a new uuid doesn't.
///
mixin Payload {
  /// General map representation
  ///
  Map<String, dynamic> get map;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Payload &&
          other.runtimeType == runtimeType &&
          _equals(map, other.map);

  @override
  int get hashCode => Object.hash(runtimeType, _hash(map));

  @override
  String toString() => '$runtimeType($map)';
}

bool _equals(Object? a, Object? b) {
  if (a is Map && b is Map) {
    return a.length == b.length &&
        a.keys.every((key) => b.containsKey(key) && _equals(a[key], b[key]));
  }
  if (a is List && b is List) {
    if (a.length != b.length) return false;
    for (var i = 0; i < a.length; i++) {
      if (!_equals(a[i], b[i])) return false;
    }
    return true;
  }
  // NaN equals NaN, so a payload holding one equals itself
  if (a is double && b is double && a.isNaN && b.isNaN) return true;
  return a == b;
}

int _hash(Object? value) {
  if (value is Map) {
    return Object.hashAllUnordered(
        value.entries.map((e) => Object.hash(e.key, _hash(e.value))));
  }
  if (value is List) return Object.hashAll(value.map(_hash));
  if (value is double && value.isNaN) return double.nan.isNaN.hashCode;
  return value.hashCode;
}
