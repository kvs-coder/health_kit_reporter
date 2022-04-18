import 'package:flutter_test/flutter_test.dart';
import 'package:health_kit_reporter/model/payload/electrocardiogram.dart';

void main() {
  test('electrocardiogram_parse_from_json', () {
    final json = {
      'device': {
        'softwareVersion': '8.0.1',
        'manufacturer': 'Apple Inc.',
        'model': 'Watch',
        'name': 'Apple Watch',
        'hardwareVersion': 'Watch6,1'
      },
      'sourceRevision': {
        'productType': 'Watch6,1',
        'systemVersion': '8.0.1',
        'source': {
          'name': 'EKG',
          'bundleIdentifier': 'com.apple.NanoHeartRhythm'
        },
        'operatingSystem': {
          'majorVersion': 8,
          'minorVersion': 0,
          'patchVersion': 1
        },
        'version': '1.90'
      },
      'uuid': 'E90DE3C5-5D94-4B05-8987-060D6B3C5FB9',
      'numberOfMeasurements': 2,
      'identifier': 'HKDataTypeIdentifierElectrocardiogram',
      'endTimestamp': 1634148827.61133,
      'startTimestamp': 1634148797.61133,
      'harmonized': {
        'voltageMeasurements': [
          {
            'harmonized': {'value': 3.7860584259033203e-05, 'unit': 'V'},
            'timeSinceSampleStart': 0
          },
          {
            'harmonized': {'value': 6.8293251037597656e-05, 'unit': 'V'},
            'timeSinceSampleStart': 0.175781250
          }
        ],
        'averageHeartRate': 62,
        'classification': 'HKElectrocardiogramClassification',
        'samplingFrequencyUnit': 'Hz',
        'averageHeartRateUnit': 'count/min',
        'symptomsStatus': 'HKElectrocardiogramSymptomsStatus',
        'samplingFrequency': 512,
        'count': 2,
        'metadata': {
          'HKMetadataKeyAppleECGAlgorithmVersion': '2',
          'HKMetadataKeySyncVersion': '0',
          'HKMetadataKeySyncIdentifier': 'E9217BF0-CA9D-4865-BCBD-88E23763E64E'
        }
      }
    };
    final sut = Electrocardiogram.fromJson(json);
    expect(sut.uuid, 'E90DE3C5-5D94-4B05-8987-060D6B3C5FB9');
    expect(sut.identifier, 'HKDataTypeIdentifierElectrocardiogram');
    expect(sut.startTimestamp, 1634148797.61133);
    expect(sut.endTimestamp, 1634148827.61133);
    expect(sut.device?.name, 'Apple Watch');
    expect(sut.device?.manufacturer, 'Apple Inc.');
    expect(sut.device?.softwareVersion, '8.0.1');
    expect(sut.device?.model, 'Watch');
    expect(sut.device?.hardwareVersion, 'Watch6,1');
    expect(sut.sourceRevision.source.name, 'EKG');
    expect(sut.sourceRevision.source.bundleIdentifier,
        'com.apple.NanoHeartRhythm');
    expect(sut.sourceRevision.version, '1.90');
    expect(sut.sourceRevision.productType, 'Watch6,1');
    expect(sut.sourceRevision.systemVersion, '8.0.1');
    expect(sut.sourceRevision.operatingSystem.majorVersion, 8);
    expect(sut.sourceRevision.operatingSystem.minorVersion, 0);
    expect(sut.sourceRevision.operatingSystem.patchVersion, 1);
    expect(sut.harmonized.voltageMeasurements[0].harmonized.value,
        3.7860584259033203e-05);
    expect(sut.harmonized.voltageMeasurements[0].harmonized.unit, "V");
    expect(sut.harmonized.voltageMeasurements[0].timeSinceSampleStart, 0);
    expect(sut.harmonized.voltageMeasurements[1].harmonized.value,
        6.8293251037597656e-05);
    expect(sut.harmonized.voltageMeasurements[1].harmonized.unit, "V");
    expect(sut.harmonized.voltageMeasurements[1].timeSinceSampleStart,
        0.175781250);
    expect(sut.harmonized.count, 2);
    expect(sut.harmonized.averageHeartRate, 62);
    expect(sut.harmonized.classification, 'HKElectrocardiogramClassification');
    expect(sut.harmonized.samplingFrequencyUnit, 'Hz');
    expect(sut.harmonized.averageHeartRateUnit, 'count/min');
    expect(sut.harmonized.symptomsStatus, 'HKElectrocardiogramSymptomsStatus');
    expect(sut.harmonized.samplingFrequency, 512);
    expect(sut.harmonized.metadata, {
      'HKMetadataKeyAppleECGAlgorithmVersion': '2',
      'HKMetadataKeySyncVersion': '0',
      'HKMetadataKeySyncIdentifier': 'E9217BF0-CA9D-4865-BCBD-88E23763E64E'
    });
  });
}
