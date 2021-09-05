import 'package:flutter_test/flutter_test.dart';
import 'package:health_kit_reporter/model/payload/category.dart';

void main() {
  test('category_parse_from_json', () {
    final json = {
      'uuid': '4444-6666-7777-8888',
      'identifier': 'HKCategoryTypeIdentifierSleepAnalysis',
      'startTimestamp': 1630618680,
      'endTimestamp': 1630697880,
      'sourceRevision': {
        'source': {'name': 'Health', 'bundleIdentifier': 'com.apple.Health'},
        'version': '14.5',
        'productType': 'iPhone13,3',
        'systemVersion': '14.5.0',
        'operatingSystem': {
          'majorVersion': 14,
          'minorVersion': 5,
          'patchVersion': 0
        }
      },
      'harmonized': {
        'value': 1,
        'description': 'HKCategoryValueSleepAnalysis',
        'detail': 'Asleep',
        'metadata': {'HKWasUserEntered': '1'}
      }
    };
    final sut = Category.fromJson(json);
    expect(sut.uuid, '4444-6666-7777-8888');
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
    expect(sut.harmonized.description, 'HKCategoryValueSleepAnalysis');
    expect(sut.harmonized.detail, 'Asleep');
    expect(sut.harmonized.metadata, {'HKWasUserEntered': '1'});
  });
}
