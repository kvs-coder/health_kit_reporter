import 'package:flutter_test/flutter_test.dart';
import 'package:health_kit_reporter/model/payload/workout.dart';
import 'package:health_kit_reporter/model/payload/workout_activity_type.dart';
import 'package:health_kit_reporter/model/payload/workout_event_type.dart';

void main() {
  test('workout_parse_from_json', () {
    final json = {
      'device': {
        'manufacturer': 'kvs',
        'softwareVersion': '1.1.1',
        'model': 'T-800',
        'localIdentifier': 'kvs.sample.app',
        'firmwareVersion': '3.0',
        'udiDeviceIdentifier': '444-888-555',
        'name': 'FlutterTracker',
        'hardwareVersion': '3'
      },
      'sourceRevision': {
        'productType': 'iPhone13,3',
        'systemVersion': '14.5.0',
        'source': {
          'name': 'health_kit_reporter_example',
          'bundleIdentifier': 'com.kvs.healthKitReporterExample'
        },
        'operatingSystem': {
          'majorVersion': 14,
          'minorVersion': 5,
          'patchVersion': 0
        },
        'version': '1'
      },
      'uuid': 'D2544F53-E56D-4417-A358-43AEC1663190',
      'duration': 60,
      'identifier': 'HKWorkoutTypeIdentifier',
      'endTimestamp': 1630784431.079,
      'startTimestamp': 1630784371.079,
      'workoutEvents': [
        {
          'startTimestamp': 1630784431.079,
          'harmonized': {
            'value': 1,
            'metadata': {'some': 'meta'},
            'description': 'Pause'
          },
          'endTimestamp': 1630784431.079,
          'duration': 0
        }
      ],
      'harmonized': {
        'totalFlightsClimbedUnit': 'count',
        'totalEnergyBurnedUnit': 'Cal',
        'totalEnergyBurned': 1.2,
        'totalDistance': 123,
        'value': 4,
        'description': 'Badminton',
        'totalSwimmingStrokeCount': 0,
        'totalDistanceUnit': 'm',
        'totalSwimmingStrokeCountUnit': 'count',
        'metadata': {'HKWasUserEntered': '1'}
      }
    };
    final sut = Workout.fromJson(json);
    expect(sut.uuid, 'D2544F53-E56D-4417-A358-43AEC1663190');
    expect(sut.identifier, 'HKWorkoutTypeIdentifier');
    expect(sut.startTimestamp, 1630784371.079);
    expect(sut.endTimestamp, 1630784431.079);
    expect(sut.device?.manufacturer, 'kvs');
    expect(sut.device?.softwareVersion, '1.1.1');
    expect(sut.device?.model, 'T-800');
    expect(sut.device?.localIdentifier, 'kvs.sample.app');
    expect(sut.device?.firmwareVersion, '3.0');
    expect(sut.device?.udiDeviceIdentifier, '444-888-555');
    expect(sut.device?.name, 'FlutterTracker');
    expect(sut.device?.hardwareVersion, '3');
    expect(sut.sourceRevision.source.name, 'health_kit_reporter_example');
    expect(sut.sourceRevision.source.bundleIdentifier,
        'com.kvs.healthKitReporterExample');
    expect(sut.sourceRevision.version, '1');
    expect(sut.sourceRevision.productType, 'iPhone13,3');
    expect(sut.sourceRevision.systemVersion, '14.5.0');
    expect(sut.sourceRevision.operatingSystem.majorVersion, 14);
    expect(sut.sourceRevision.operatingSystem.minorVersion, 5);
    expect(sut.sourceRevision.operatingSystem.patchVersion, 0);
    expect(sut.workoutEvents[0].endTimestamp, 1630784431.079);
    expect(sut.workoutEvents[0].startTimestamp, 1630784431.079);
    expect(sut.workoutEvents[0].duration, 0);
    expect(sut.workoutEvents[0].harmonized.type.value,
        WorkoutEventType.pause.value);
    expect(sut.workoutEvents[0].harmonized.type.description,
        WorkoutEventType.pause.description);
    expect(sut.workoutEvents[0].harmonized.metadata, {'some': 'meta'});
    expect(sut.harmonized.totalFlightsClimbedUnit, 'count');
    expect(sut.harmonized.totalEnergyBurnedUnit, 'Cal');
    expect(sut.harmonized.totalEnergyBurned, 1.2);
    expect(sut.harmonized.type.value, WorkoutActivityType.badminton.value);
    expect(sut.harmonized.type.description,
        WorkoutActivityType.badminton.description);
    expect(sut.harmonized.totalSwimmingStrokeCount, 0);
    expect(sut.harmonized.totalDistanceUnit, 'm');
    expect(sut.harmonized.totalDistance, 123);
    expect(sut.harmonized.totalSwimmingStrokeCountUnit, 'count');
    expect(sut.harmonized.metadata, {'HKWasUserEntered': '1'});
  });
}
