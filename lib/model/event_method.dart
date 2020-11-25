import 'package:flutter/services.dart';

/// Event methods
/// which are handled by [HealthKitReporterStreamHandler.swift]
///
enum EventMethod {
  statisticsCollectionQuery,
  queryActivitySummary,
  anchoredObjectQuery,
  observerQuery,
  heartbeatSeriesQuery,
  workoutRouteQuery,
}

extension EventMethodChannel on EventMethod {
  EventChannel get channel => EventChannel(
      '${EventMethodChannel._prefix}${toString().split('.').last}');

  static const _prefix = 'health_kit_reporter_event_channel_';
}

extension EventName on EventChannel {
  String get eventName => name.split(EventMethodChannel._prefix).last;
}
