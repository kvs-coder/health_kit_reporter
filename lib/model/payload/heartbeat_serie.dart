class HeartbeatSerie {
  const HeartbeatSerie(
    this.ibiArray,
    this.indexArray,
  );

  final List<double> ibiArray;
  final List<int> indexArray;

  Map<String, dynamic> get map => {
        'ibiArray': ibiArray,
        'indexArray': indexArray,
      };

  HeartbeatSerie.fromJson(Map<String, dynamic> json)
      : ibiArray = json['ibiArray'],
        indexArray = json['indexArray'];
}
