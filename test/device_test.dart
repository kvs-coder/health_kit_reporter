import 'package:flutter_test/flutter_test.dart';
import 'package:health_kit_reporter/model/payload/device.dart';

void main() {
  test('device_parse_from_json', () {
    final json = {
      'manufacturer': 'kvs',
      'softwareVersion': '1.1.1',
      'model': 'T-800',
      'localIdentifier': 'kvs.sample.app',
      'firmwareVersion': '3.0',
      'udiDeviceIdentifier': '444-888-555',
      'name': 'FlutterTracker',
      'hardwareVersion': '3'
    };
    final sut = Device.fromJson(json);
    expect(sut.manufacturer, 'kvs');
    expect(sut.softwareVersion, '1.1.1');
    expect(sut.model, 'T-800');
    expect(sut.localIdentifier, 'kvs.sample.app');
    expect(sut.firmwareVersion, '3.0');
    expect(sut.udiDeviceIdentifier, '444-888-555');
    expect(sut.name, 'FlutterTracker');
    expect(sut.hardwareVersion, '3');
  });
}
