import '../decorator/extensions.dart';
import 'package:health_kit_reporter/model/type/workout_type.dart';

import 'sample.dart';
import 'metadata.dart';
import 'payload.dart';

/// Equivalent of [WorkoutRoute]
/// from [HealthKitReporter] https://github.com/kvs-coder/HealthKitReporter
///
/// Supports [map] representation.
///
/// Has a [WorkoutRoute.fromJson] constructor
/// to create instances from JSON payload coming from iOS native code.
///
/// Requires [SeriesType], [WorkoutType] permissions provided.
///
class WorkoutRoute extends Sample<WorkoutRouteHarmonized> {
  const WorkoutRoute(
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
  WorkoutRoute.fromJson(Map<String, dynamic> json)
      : super.from(json, WorkoutRouteHarmonized.fromJson(json['harmonized']));
}

/// Equivalent of [WorkoutRoute.Harmonized]
/// from [HealthKitReporter] https://github.com/kvs-coder/HealthKitReporter
///
/// Supports [map] representation.
///
/// Has a [WorkoutRouteHarmonized.fromJson] constructor
/// to create instances from JSON payload coming from iOS native code.
///
class WorkoutRouteHarmonized with Payload {
  const WorkoutRouteHarmonized(
    this.count,
    this.routes,
    this.metadata,
  );

  final int count;
  final List<WorkoutRouteBatch> routes;
  final Metadata? metadata;

  /// General map representation
  ///
  @override
  Map<String, dynamic> get map => {
        'count': count,
        'routes': routes.map((e) => e.map).toList(),
        'metadata': metadata?.map,
      };

  /// General constructor from JSON payload
  ///
  WorkoutRouteHarmonized.fromJson(Map<String, dynamic> json)
      : count = json['count'],
        routes = WorkoutRouteBatch.collect(json['routes']),
        metadata = Metadata.tryFromJson(json['metadata']);
}

class WorkoutRouteBatch with Payload {
  const WorkoutRouteBatch(
    this.locations,
    this.done,
  );

  final List<WorkoutRouteLocation> locations;
  final bool done;

  /// General map representation
  ///
  @override
  Map<String, dynamic> get map => {
        'locations': locations.map((e) => e.map).toList(),
        'done': done,
      };

  /// General constructor from JSON payload
  ///
  WorkoutRouteBatch.fromJson(Map<String, dynamic> json)
      : locations = WorkoutRouteLocation.collect(json['locations']),
        done = json['done'];

  /// Simplifies creating a list of objects from JSON payload.
  ///
  static List<WorkoutRouteBatch> collect(List<dynamic> list) {
    final samples = <WorkoutRouteBatch>[];
    for (final Map<String, dynamic> map in list) {
      final sample = WorkoutRouteBatch.fromJson(map);
      samples.add(sample);
    }
    return samples;
  }
}

/// Equivalent of [WorkoutRoute.Location]
/// from [HealthKitReporter] https://github.com/kvs-coder/HealthKitReporter
///
/// Supports [map] representation.
///
/// Has a [WorkoutRouteLocation.fromJson] constructor
/// to create instances from JSON payload coming from iOS native code.
/// And supports multiple object creation by [collect] method from JSON list.
///
/// Requires [CoreLocation] permissions provided.
///
class WorkoutRouteLocation with Payload {
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
  final num? courseAccuracy;
  final num? floor;
  final num horizontalAccuracy;
  final num speed;
  final num? speedAccuracy;
  final num timestamp;
  final num verticalAccuracy;

  /// General map representation
  ///
  @override
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
      : latitude = parseNum(json['latitude']),
        longitude = parseNum(json['longitude']),
        altitude = parseNum(json['altitude']),
        course = parseNum(json['course']),
        courseAccuracy = tryParseNum(json['courseAccuracy']),
        floor = json['floor'],
        horizontalAccuracy = parseNum(json['horizontalAccuracy']),
        speed = parseNum(json['speed']),
        speedAccuracy = tryParseNum(json['speedAccuracy']),
        timestamp = parseNum(json['timestamp']),
        verticalAccuracy = parseNum(json['verticalAccuracy']);

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
