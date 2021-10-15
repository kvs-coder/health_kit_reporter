import 'package:flutter_test/flutter_test.dart';
import 'package:health_kit_reporter/model/payload/quantity.dart';

void main() {
  test('quantity_parse_from_json', () {
    final json = {
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
    expect(sut.identifier, 'HKQuantityTypeIdentifierStepCount');
    expect(sut.startTimestamp, 1630784373.837);
    expect(sut.endTimestamp, 1630784433.837);
    expect(sut.sourceRevision.source.name, 'health_kit_reporter_example');
    expect(sut.sourceRevision.source.bundleIdentifier,
        'com.kvs.healthKitReporterExample');
    expect(sut.sourceRevision.version, '1');
    expect(sut.sourceRevision.productType, 'iPhone13,3');
    expect(sut.sourceRevision.systemVersion, '14.5.0');
    expect(sut.sourceRevision.operatingSystem.majorVersion, 14);
    expect(sut.sourceRevision.operatingSystem.minorVersion, 5);
    expect(sut.sourceRevision.operatingSystem.patchVersion, 0);
    expect(sut.harmonized.value, 100);
    expect(sut.harmonized.unit, 'count');
    expect(sut.harmonized.metadata, {'HKWasUserEntered': 1});
  });
}
