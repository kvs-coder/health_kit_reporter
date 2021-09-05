import 'package:flutter_test/flutter_test.dart';
import 'package:health_kit_reporter/model/payload/quantity.dart';

void main() {
  test('category_parse_from_json', () {
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
      'uuid': '035A4820-AD9C-434A-9662-71E49B1FEC07',
      'identifier': 'HKQuantityTypeIdentifierStepCount',
      'startTimestamp': 1630784373.837,
      'endTimestamp': 1630784433.837,
      'harmonized': {
        'value': 100,
        'unit': 'count',
        'metadata': {'HKWasUserEntered': 1}
      }
    };
    final sut = Quantity.fromJson(json);
    expect(sut.uuid, '035A4820-AD9C-434A-9662-71E49B1FEC07');
    expect(sut.identifier, 'HKCategoryTypeIdentifierSleepAnalysis');
    expect(sut.startTimestamp, 1630618680);
    expect(sut.endTimestamp, 1630697880);
    expect(sut.device, null);
    expect(sut.sourceRevision.source.name, 'Health');
    expect(sut.sourceRevision.source.bundleIdentifier, 'com.apple.Health');
    expect(sut.sourceRevision.version, '14.5');
    expect(sut.sourceRevision.productType, 'iPhone13,3');
    expect(sut.sourceRevision.systemVersion, '14.5.0');
    expect(sut.sourceRevision.operatingSystem.majorVersion, 14);
    expect(sut.sourceRevision.operatingSystem.minorVersion, 5);
    expect(sut.sourceRevision.operatingSystem.patchVersion, 0);
    expect(sut.harmonized.value, 1);
    expect(sut.harmonized.unit, 'count');
    expect(sut.harmonized.metadata, {'HKWasUserEntered': '1'});
  });
}
