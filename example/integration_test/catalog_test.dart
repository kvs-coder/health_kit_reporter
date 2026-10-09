import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:health_kit_reporter_example/demo/catalog.dart';
import 'package:integration_test/integration_test.dart';

/// Runs every row of the demo against HealthKit in the simulator.
/// Authorize the app once first (run it and allow all), since the
/// authorization sheet can't be driven from a test.
void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();
  final catalog = Catalog();

  // Rows that present a system sheet a test can't answer
  const presentsSheet = {
    'requestClinicalRecordsAuthorization',
    'requestPerObjectReadAuthorization',
    'requestPerObjectReadAuthorization for medications',
    'verifiableClinicalRecordQuery',
  };

  // Rows that need hardware, an Apple Account or a watch app
  const expectedToFail = {
    'requestAuthorization with a read-only type',
    'requestClinicalRecordsAuthorization',
    'requestPerObjectReadAuthorization',
    'clinicalRecordQuery',
    'visionPrescriptionQuery',
    'startWatchApp',
    // allowed for VO2 max estimated by Apple Watch only
    'recalibrateEstimates',
  };

  for (final section in catalog.sections) {
    for (final row in section.rows) {
      test('${section.title} / ${row.title}',
          skip: presentsSheet.contains(row.title), () async {
        if (row.isLive) {
          final updates = <String>[];
          final subscription = row.listen!(updates.add);
          await Future<void>.delayed(const Duration(seconds: 4));
          await subscription.cancel();
          // ignore: avoid_print
          print(
              'LIVE ${row.title}: ${updates.length} updates, last: ${updates.lastOrNull}');
          return;
        }
        try {
          final result = await row.run!().timeout(const Duration(seconds: 90));
          // ignore: avoid_print
          print('OK ${row.title}: $result');
        } on PlatformException catch (error) {
          // ignore: avoid_print
          print('ERR ${row.title}: ${error.code}: ${error.message}');
          if (!expectedToFail.contains(row.title)) rethrow;
        }
      }, timeout: const Timeout(Duration(minutes: 3)));
    }
  }
}
