import '../decorator/extensions.dart';
import 'quantity.dart';
import 'workout.dart';

/// Equivalent of [WorkoutEffortRelationship]
/// from [HealthKitReporter] https://github.com/kvs-coder/HealthKitReporter
///
/// Effort score samples related to a workout or one of its activities (iOS 18+). Read only.
///
/// Has a [WorkoutEffortRelationship.fromJson] constructor
/// to create instances from JSON payload coming from iOS native code.
///
class WorkoutEffortRelationship {
  const WorkoutEffortRelationship(
      this.workout, this.activityUUID, this.samples);

  final Workout workout;

  /// uuid of the workout activity the samples belong to; null for the whole workout
  final String? activityUUID;

  /// Workout effort score and estimated workout effort score samples
  final List<Quantity> samples;

  /// General map representation
  ///
  Map<String, dynamic> get map => {
        'workout': workout.map,
        'activityUUID': activityUUID,
        'samples': samples.map((e) => e.map).toList(),
      };

  /// General constructor from JSON payload
  ///
  WorkoutEffortRelationship.fromJson(Map<String, dynamic> json)
      : workout = Workout.fromJson(Map<String, dynamic>.from(json['workout'])),
        activityUUID = json['activityUUID'],
        samples = parseList(json['samples'], Quantity.fromJson);

  /// Simplifies creating a list of objects from JSON payload.
  ///
  static List<WorkoutEffortRelationship> collect(List<dynamic> list) =>
      parseList(list, WorkoutEffortRelationship.fromJson);
}

/// Result of [HealthKitReporter.workoutEffortRelationshipQuery]:
/// the relationships and the [anchor] to pass to the next query
/// to receive only the changes.
///
class WorkoutEffortRelationshipResult {
  const WorkoutEffortRelationshipResult(this.relationships, this.anchor);

  final List<WorkoutEffortRelationship> relationships;

  /// Base64 string; persist it as is
  final String? anchor;
}
