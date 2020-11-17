class PreferredUnit {
  const PreferredUnit(
    this.identifier,
    this.unit,
  );

  final String identifier;
  final String unit;

  PreferredUnit.fromJson(Map<String, dynamic> json)
      : identifier = json['identifier'],
        unit = json['unit'];
}
