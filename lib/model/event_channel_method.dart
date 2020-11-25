/// Event channel methods
/// which are handled by [HealthKitReporterStreamHandler.swift]
///
enum EventChannelMethod {
  statisticsCollectionQuery,
  queryActivitySummary,
  anchoredObjectQuery,
  observerQuery,
  heartbeatSeriesQuery,
  workoutRouteQuery,
}

extension EventChannelMethodName on EventChannelMethod {
  String get name => toString().split('.').last;

  static const prefix = 'health_kit_reporter_event_channel';
}
