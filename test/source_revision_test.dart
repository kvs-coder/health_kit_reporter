import 'package:flutter_test/flutter_test.dart';
import 'package:health_kit_reporter/model/payload/source_revision.dart';

void main() {
  test('source_revision_parse_from_json', () {
    final json = {
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
    };
    final sut = SourceRevision.fromJson(json);
    expect(sut.source.name, 'health_kit_reporter_example');
    expect(sut.source.bundleIdentifier, 'com.kvs.healthKitReporterExample');
    expect(sut.version, '1');
    expect(sut.productType, 'iPhone13,3');
    expect(sut.systemVersion, '14.5.0');
    expect(sut.operatingSystem.majorVersion, 14);
    expect(sut.operatingSystem.minorVersion, 5);
    expect(sut.operatingSystem.patchVersion, 0);
  });
}
