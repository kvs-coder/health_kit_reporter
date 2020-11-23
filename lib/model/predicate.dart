class Predicate {
  const Predicate(
    this.startDate,
    this.endDate,
  );

  final DateTime startDate;
  final DateTime endDate;

  Map<String, int> get map => {
        'startTimestamp': startDate.millisecondsSinceEpoch,
        'endTimestamp': endDate.millisecondsSinceEpoch,
      };
}
