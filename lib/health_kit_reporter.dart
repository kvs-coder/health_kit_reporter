
import 'dart:async';

import 'package:flutter/services.dart';

class HealthKitReporter {
  static const MethodChannel _channel =
      const MethodChannel('health_kit_reporter');

  static Future<String> get platformVersion async {
    final String version = await _channel.invokeMethod('getPlatformVersion');
    return version;
  }
}
