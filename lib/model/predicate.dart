import 'package:health_kit_reporter/health_kit_reporter.dart';

/// A time interval predicate used in
/// most of query requests of [HealthKitReporter]
///
/// [startDate] - the starting point of the time interval
/// [endDate] - the end point of the time interval
///
/// For native calls the instance will be mapped to [map]
/// and timestamps values will be accepted as arguments.
///
/// See also: [UUIDPredicate]
///
class Predicate {
  const Predicate(
    this.startDate,
    this.endDate,
  );

  final DateTime startDate;
  final DateTime endDate;

  /// General map representation
  ///
  Map<String, int> get map => {
        'startTimestamp': startDate.millisecondsSinceEpoch,
        'endTimestamp': endDate.millisecondsSinceEpoch,
      };
}

/// A predicate used in [HealthKitReporter.workoutRouteForUUIDQuery]
/// to filter workout routes associated with the given workout UUID.
///
/// [uuid] - the unique identifier of the workout
///
/// For native calls the instance will be mapped to [map]
/// and accepted as `arguments`.
///
/// See also: [Predicate]
///
class UUIDPredicate {
  const UUIDPredicate(
    this.uuid,
  );

  final String uuid;

  /// General map representation
  ///
  Map<String, String> get map => {
        'uuid': uuid,
      };
}
