class Predicate {
  const Predicate(
    this.startDate,
    this.endDate,
  );

  final DateTime startDate;
  final DateTime endDate;

  Map<String, String> get map => {
        'startDate': startDate.toIso8601String(),
        'endDate': endDate.toIso8601String()
      };
}
