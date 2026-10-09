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

Map<String, dynamic> categoryJson() => {
      'uuid': 'C-UUID',
      'identifier': 'HKCategoryTypeIdentifierSleepAnalysis',
      'startTimestamp': 1601065755.0,
      'endTimestamp': 1601094555.0,
      'sourceRevision': sourceRevisionJson(),
      'harmonized': {
        'value': 1,
        'description': 'HKCategoryValueSleepAnalysis',
        'detail': 'Asleep',
        'metadata': {'HKTimeZone': 'Europe/Berlin'},
      },
    };

Map<String, dynamic> correlationJson() => {
      'uuid': 'CORRELATION-UUID',
      'identifier': 'HKCorrelationTypeIdentifierBloodPressure',
      'startTimestamp': 1601065755.0,
      'endTimestamp': 1601065755.0,
      'sourceRevision': sourceRevisionJson(),
      'harmonized': {
        'quantitySamples': [
          quantityJson(
              uuid: 'SYSTOLIC',
              identifier: 'HKQuantityTypeIdentifierBloodPressureSystolic',
              value: 120,
              unit: 'mmHg'),
          quantityJson(
              uuid: 'DIASTOLIC',
              identifier: 'HKQuantityTypeIdentifierBloodPressureDiastolic',
              value: 80,
              unit: 'mmHg'),
        ],
        'categorySamples': [],
        'metadata': null,
      },
    };

Map<String, dynamic> electrocardiogramJson() => {
      'uuid': 'ECG-UUID',
      'identifier': 'HKDataTypeIdentifierElectrocardiogram',
      'startTimestamp': 1634148797.61133,
      'endTimestamp': 1634148827.61133,
      'numberOfMeasurements': 1,
      'device': {'name': 'Apple Watch', 'manufacturer': 'Apple Inc.'},
      'sourceRevision': sourceRevisionJson(),
      'harmonized': {
        'averageHeartRate': 62,
        'averageHeartRateUnit': 'count/min',
        'samplingFrequency': 512,
        'samplingFrequencyUnit': 'Hz',
        'classification': 'Sinus rhythm',
        'symptomsStatus': 'None',
        'count': 1,
        'voltageMeasurements': [
          {
            'harmonized': {'value': 3.78e-05, 'unit': 'V'},
            'timeSinceSampleStart': 0,
          }
        ],
        'metadata': null,
      },
    };

Map<String, dynamic> heartbeatSeriesJson() => {
      'uuid': 'HEARTBEAT-UUID',
      'identifier': 'HKDataTypeIdentifierHeartbeatSeries',
      'startTimestamp': 1634308957.9276123,
      'endTimestamp': 1634309012.3221436,
      'sourceRevision': sourceRevisionJson(),
      'harmonized': {
        'count': 1,
        'measurements': [
          {'timeSinceSeriesStart': 0.5, 'precededByGap': false, 'done': true}
        ],
        'metadata': {'HKAlgorithmVersion': '1'},
      },
    };

Map<String, dynamic> workoutRouteJson() => {
      'uuid': 'ROUTE-UUID',
      'identifier': 'HKWorkoutRouteTypeIdentifier',
      'startTimestamp': 1650106382.259656,
      'endTimestamp': 1650107789.9993167,
      'sourceRevision': sourceRevisionJson(),
      'harmonized': {
        'count': 1,
        'metadata': null,
        'routes': [
          {
            'done': true,
            'locations': [
              {
                'latitude': 52.5,
                'longitude': 13.35,
                'altitude': 36.9,
                'course': 211.5,
                'courseAccuracy': null,
                'floor': null,
                'horizontalAccuracy': 2.3,
                'speed': 'Infinity',
                'speedAccuracy': null,
                'timestamp': 1650106382.259656,
                'verticalAccuracy': 1.4,
              }
            ],
          }
        ],
      },
    };

Map<String, dynamic> clinicalRecordJson() => {
      'uuid': 'CLINICAL-UUID',
      'identifier': 'HKClinicalTypeIdentifierImmunizationRecord',
      'startTimestamp': 1601065755.0,
      'endTimestamp': 1601065755.0,
      'sourceRevision': sourceRevisionJson(),
      'harmonized': {
        'displayName': 'Tetanus',
        'fhirSourceUrl': null,
        'fhirVersion': '4.0.1',
        'fhirData': '{"resourceType":"Immunization"}',
        'metadata': null,
      },
    };

Map<String, dynamic> activitySummaryJson() => {
      'identifier': 'HKActivitySummaryTypeIdentifier',
      'date': '2026-10-08T00:00:00.000+02:00',
      'harmonized': {
        'activeEnergyBurned': 400,
        'activeEnergyBurnedGoal': 500,
        'activeEnergyBurnedUnit': 'kcal',
        'appleExerciseTime': 20,
        'appleExerciseTimeGoal': 30,
        'appleExerciseTimeUnit': 'min',
        'appleStandHours': 8,
        'appleStandHoursGoal': 12,
        'appleStandHoursUnit': 'count',
      },
    };

Map<String, dynamic> visionPrescriptionJson() => {
      'uuid': 'VISION-UUID',
      'identifier': 'HKVisionPrescriptionTypeIdentifier',
      'startTimestamp': 1704067200.0,
      'endTimestamp': 1704067200.0,
      'sourceRevision': sourceRevisionJson(),
      'harmonized': {
        'dateIssuedTimestamp': 1704067200,
        'expirationDateTimestamp': null,
        'prescriptionType': {'id': 2, 'detail': 'Contacts'},
        'rightEye': {'sphere': -2, 'baseCurve': 8.6, 'diameter': 14.2},
        'leftEye': null,
        'brand': 'Acuvue',
        'metadata': null,
      },
    };

Map<String, dynamic> audiogramJson() => {
      'uuid': 'AUDIOGRAM-UUID',
      'identifier': 'HKDataTypeIdentifierAudiogram',
      'startTimestamp': 1601065755.0,
      'endTimestamp': 1601065755.0,
      'sourceRevision': sourceRevisionJson(),
      'harmonized': {
        'sensitivityPoints': [
          {
            'frequency': 1000,
            'leftEarSensitivity': 20,
            'rightEarSensitivity': 25.5,
            'tests': [
              {
                'sensitivity': 20,
                'conductionType': 0,
                'masked': false,
                'side': 0
              }
            ],
          },
          {'frequency': 2000, 'leftEarSensitivity': 30},
        ],
        'metadata': null,
      },
    };

Map<String, dynamic> stateOfMindJson() => {
      'uuid': 'MIND-UUID',
      'identifier': 'HKDataTypeStateOfMind',
      'startTimestamp': 1601065755.0,
      'endTimestamp': 1601065755.0,
      'sourceRevision': sourceRevisionJson(),
      'harmonized': {
        'kind': 1,
        'valence': 0.5,
        'valenceClassification': 6,
        'labels': [1, 14],
        'associations': [3],
        'metadata': null,
      },
    };

Map<String, dynamic> scoredAssessmentJson() => {
      'uuid': 'GAD7-UUID',
      'identifier': 'HKScoredAssessmentTypeIdentifierGAD7',
      'startTimestamp': 1601065755.0,
      'endTimestamp': 1601065755.0,
      'sourceRevision': sourceRevisionJson(),
      'harmonized': {
        'answers': [0, 1, 2, 3, 0, 1, 2],
        'score': 9,
        'risk': 2,
        'metadata': null,
      },
    };

Map<String, dynamic> cdaDocumentJson() => {
      'uuid': 'CDA-UUID',
      'identifier': 'HKDocumentTypeIdentifierCDA',
      'startTimestamp': 1601065755.0,
      'endTimestamp': 1601065755.0,
      'sourceRevision': sourceRevisionJson(),
      'harmonized': {
        'title': 'Summary',
        'patientName': 'Jane Doe',
        'authorName': 'Dr. Who',
        'custodianName': 'Clinic',
        'documentData': 'PENsaW5pY2FsRG9jdW1lbnQvPg==',
        'metadata': null,
      },
    };

Map<String, dynamic> medicationDoseEventJson() => {
      'uuid': 'DOSE-UUID',
      'identifier': 'HKMedicationDoseEventTypeIdentifierMedicationDoseEvent',
      'startTimestamp': 1601065755.0,
      'endTimestamp': 1601065755.0,
      'sourceRevision': sourceRevisionJson(),
      'harmonized': {
        'scheduleType': 2,
        'medicationConceptIdentifier': 'Q09OQ0VQVA==',
        'scheduledTimestamp': 1601065700.0,
        'scheduledDoseQuantity': 1,
        'doseQuantity': 1,
        'logStatus': 4,
        'unit': 'count',
        'metadata': null,
      },
    };

Map<String, dynamic> userAnnotatedMedicationJson() => {
      'nickname': 'Morning pill',
      'isArchived': false,
      'hasSchedule': true,
      'medication': {
        'identifier': 'Q09OQ0VQVA==',
        'domain': 'medication',
        'displayText': 'Ibuprofen 200 mg',
        'generalForm': 'tablet',
        'relatedCodings': [
          {
            'system': 'http://www.nlm.nih.gov/research/umls/rxnorm',
            'version': null,
            'code': '310965'
          }
        ],
      },
    };

Map<String, dynamic> verifiableClinicalRecordJson() => {
      'uuid': 'SHC-UUID',
      'identifier': 'HKVerifiableClinicalRecordTypeIdentifier',
      'startTimestamp': 1601065755.0,
      'endTimestamp': 1601065755.0,
      'sourceRevision': sourceRevisionJson(),
      'harmonized': {
        'recordTypes': ['https://smarthealth.cards#immunization'],
        'issuerIdentifier': 'https://issuer.example',
        'subject': {
          'fullName': 'Jane Doe',
          'dateOfBirth': '1990-01-01T00:00:00.000+01:00'
        },
        'issuedTimestamp': 1601065755.0,
        'relevantTimestamp': 1601065755.0,
        'itemNames': ['COVID-19'],
        'sourceType': 'https://smarthealth.cards',
        'dataRepresentation': 'ZXlK',
      },
    };

Map<String, dynamic> attachmentJson() => {
      'identifier': 'ATTACHMENT-UUID',
      'name': 'scan.jpg',
      'contentType': 'public.jpeg',
      'size': 2048,
      'creationTimestamp': 1601065755.0,
      'metadata': {'source': 'camera'},
    };

Map<String, dynamic> quantitySeriesValueJson() => {
      'value': 12,
      'unit': 'count',
      'startTimestamp': 1601065755.0,
      'endTimestamp': 1601065815.0,
      'sampleUUID': 'SERIES-UUID',
    };
