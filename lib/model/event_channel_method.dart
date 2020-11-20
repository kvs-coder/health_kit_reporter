enum EventChannelMethod {
  statisticsCollectionQuery,
  queryActivitySummary,
  anchoredObjectQuery,
  observerQuery,
}

extension Name on EventChannelMethod {
  String get name => toString().split('.').last;
}
