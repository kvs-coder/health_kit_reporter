// JSON payloads shaped like HealthKitReporter 4.0.0 encodes them.

Map<String, dynamic> sourceRevisionJson() => {
      'productType': 'iPhone13,3',
      'systemVersion': '18.0.0',
      'source': {
        'name': 'health_kit_reporter_example',
        'bundleIdentifier': 'com.kvs.healthKitReporterExample'
      },
      'operatingSystem': {
        'majorVersion': 18,
        'minorVersion': 0,
        'patchVersion': 0
      },
      'version': '1'
    };

Map<String, dynamic> quantityJson({
  String uuid = '8B1F9C1E-4E0A-4C38-9D57-1B2F4A6C7D10',
  String identifier = 'HKQuantityTypeIdentifierStepCount',
  dynamic value = 298,
  String unit = 'count',
  Map<String, dynamic>? metadata,
}) =>
    {
      'uuid': uuid,
      'identifier': identifier,
      'startTimestamp': 1601065755.8829093,
      'endTimestamp': 1601066077.5886581,
      'sourceRevision': sourceRevisionJson(),
      'harmonized': {
        'value': value,
        'unit': unit,
        'metadata': metadata,
      },
    };

Map<String, dynamic> statisticsJson({Map<String, dynamic>? extra}) => {
      'identifier': 'HKQuantityTypeIdentifierStepCount',
      'startTimestamp': 1601065755.0,
      'endTimestamp': 1601152155.0,
      'sources': [
        {'name': 'iPhone', 'bundleIdentifier': 'com.apple.health'}
      ],
      'harmonized': {
        'summary': 1200,
        'average': null,
        'recent': null,
        'min': null,
        'max': null,
        'unit': 'count',
      },
      ...?extra,
    };

Map<String, dynamic> workoutJson({Map<String, dynamic>? extra}) => {
      'uuid': 'F0F0AAAA-1111-2222-3333-444455556666',
      'identifier': 'HKWorkoutTypeIdentifier',
      'startTimestamp': 1601065755.0,
      'endTimestamp': 1601069355.0,
      'duration': 3600,
      'sourceRevision': sourceRevisionJson(),
      'workoutEvents': [
        {
          'startTimestamp': 1601066000.0,
          'endTimestamp': 1601066000.0,
          'duration': 0,
          'harmonized': {
            'value': 8,
            'description': 'Pause or resume request',
            'metadata': null,
          },
        }
      ],
      'harmonized': {
        'value': 79,
        'description': 'Pickleball',
        'totalEnergyBurned': 300,
        'totalEnergyBurnedUnit': 'kcal',
        'totalDistance': null,
        'totalDistanceUnit': 'm',
        'totalSwimmingStrokeCount': null,
        'totalSwimmingStrokeCountUnit': 'count',
        'totalFlightsClimbed': null,
        'totalFlightsClimbedUnit': 'count',
        'metadata': {'HKIndoorWorkout': true},
      },
      ...?extra,
    };
