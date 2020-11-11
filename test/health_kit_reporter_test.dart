import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:health_kit_reporter/health_kit_reporter.dart';

void main() {
  const MethodChannel channel = MethodChannel('health_kit_reporter');

  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    channel.setMockMethodCallHandler((MethodCall methodCall) async {
      return '42';
    });
  });

  tearDown(() {
    channel.setMockMethodCallHandler(null);
  });

  test('getPlatformVersion', () async {
    expect(await HealthKitReporter.platformVersion, '42');
  });
}
