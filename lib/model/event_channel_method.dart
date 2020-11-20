enum EventChannelMethod {
  statisticsCollectionQuery,
  queryActivitySummary,
  anchoredObjectQuery,
  observerQuery,
  enableBackgroundDelivery,
  disableAllBackgroundDelivery,
  disableBackgroundDelivery,
}

extension Name on EventChannelMethod {
  String get name => toString().split('.').last;
}
