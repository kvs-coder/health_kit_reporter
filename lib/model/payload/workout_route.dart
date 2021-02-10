/// Equivalent of [WorkoutRoute]
/// from [HealthKitReporter] https://cocoapods.org/pods/HealthKitReporter
///
/// Supports [map] representation.
///
/// Has a [WorkoutRoute.fromJson] constructor
/// to create instances from JSON payload coming from iOS native code.
///
/// Requires [SeriesType] permissions provided.
///
class WorkoutRoute {
  const WorkoutRoute(
    this.locations,
    this.done,
  );

  final List<WorkoutRouteLocation> locations;
  final bool done;

  /// General map representation
  ///
  Map<String, dynamic> get map => {
        'locations': locations.map((e) => e.map).toList(),
        'done': done,
      };

  /// General constructor from JSON payload
  ///
  WorkoutRoute.fromJson(Map<String, dynamic> json)
      : locations = WorkoutRouteLocation.collect(json['timeSinceSeriesStart']),
        done = json['done'];
}

/// Equivalent of [WorkoutRoute.Location]
/// from [HealthKitReporter] https://cocoapods.org/pods/HealthKitReporter
///
/// Supports [map] representation.
///
/// Has a [WorkoutRouteLocation.fromJson] constructor
/// to create instances from JSON payload coming from iOS native code.
/// And supports multiple object creation by [collect] method from JSON list.
///
/// Requires [CoreLocation] permissions provided.
///
class WorkoutRouteLocation {
  const WorkoutRouteLocation(
    this.latitude,
    this.longitude,
    this.altitude,
    this.course,
    this.courseAccuracy,
    this.floor,
    this.horizontalAccuracy,
    this.speed,
    this.speedAccuracy,
    this.timestamp,
    this.verticalAccuracy,
  );

  final num latitude;
  final num longitude;
  final num altitude;
  final num course;
  final num courseAccuracy;
  final num floor;
  final num horizontalAccuracy;
  final num speed;
  final num speedAccuracy;
  final num timestamp;
  final num verticalAccuracy;

  /// General map representation
  ///
  Map<String, dynamic> get map => {
        'latitude': latitude,
        'longitude': longitude,
        'altitude': altitude,
        'course': course,
        'courseAccuracy': courseAccuracy,
        'floor': floor,
        'horizontalAccuracy': horizontalAccuracy,
        'speed': speed,
        'speedAccuracy': speedAccuracy,
        'timestamp': timestamp,
        'verticalAccuracy': verticalAccuracy,
      };

  /// General constructor from JSON payload
  ///
  WorkoutRouteLocation.fromJson(Map<String, dynamic> json)
      : latitude = json['latitude'],
        longitude = json['longitude'],
        altitude = json['altitude'],
        course = json['course'],
        courseAccuracy = json['courseAccuracy'],
        floor = json['floor'],
        horizontalAccuracy = json['horizontalAccuracy'],
        speed = json['speed'],
        speedAccuracy = json['speedAccuracy'],
        timestamp = json['timestamp'],
        verticalAccuracy = json['verticalAccuracy'];

  /// Simplifies creating a list of objects from JSON payload.
  ///
  static List<WorkoutRouteLocation> collect(List<dynamic> list) {
    final samples = <WorkoutRouteLocation>[];
    for (final Map<String, dynamic> map in list) {
      final sample = WorkoutRouteLocation.fromJson(map);
      samples.add(sample);
    }
    return samples;
  }
}
