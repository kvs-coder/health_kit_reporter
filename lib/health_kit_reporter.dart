import 'dart:async';

import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

class HealthKitReporter {
  static const MethodChannel _channel =
      const MethodChannel('health_kit_reporter');

  static Future<String> quantityQuery(String identifier, String unit,
      DateTime startDate, DateTime endDate) async {
    try {
      final DateFormat formatter = DateFormat('yyyy-MM-dd');
      final arguments = {
        'identifier': identifier,
        'unit': unit,
        'startDate': formatter.format(startDate),
        'endDate': formatter.format(endDate)
      };
      final String json =
          await _channel.invokeMethod('quantityQuery', arguments);
      return json;
    } catch (exception) {
      print(exception);
    }
    return null;
  }
}
