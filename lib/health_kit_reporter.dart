import 'dart:async';

import 'package:flutter/services.dart';

class HealthKitReporter {
  static const MethodChannel _channel =
      const MethodChannel('health_kit_reporter');

  static Future<String> quantityQuery(String identifier, String unit,
      DateTime startDate, DateTime endDate) async {
    try {
      final arguments = {
        'identifier': identifier,
        'unit': unit,
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String()
      };
      final json = await _channel.invokeMethod('quantityQuery', arguments);
      return json;
    } catch (exception) {
      print(exception);
    }
    return null;
  }
}
