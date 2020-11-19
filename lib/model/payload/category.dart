import 'device.dart';
import 'sample.dart';
import 'source_revision.dart';

class Category extends Sample<Harmonized> {
  const Category(
    String identifier,
    int startTimestamp,
    int endTimestamp,
    Device device,
    SourceRevision sourceRevision,
    Harmonized harmonized,
  ) : super(
          identifier,
          startTimestamp,
          endTimestamp,
          device,
          sourceRevision,
          harmonized,
        );

  @override
  Map<String, dynamic> get map => {
        'identifier': identifier,
        'startTimestamp': startTimestamp,
        'endTimestamp': endTimestamp,
        'device': device.map,
        'sourceRevision': sourceRevision.map,
        'harmonized': harmonized.map,
      };

  Category.fromJson(Map<String, dynamic> json)
      : super.fromJson(json,
            harmonized: Harmonized.fromJson(json['harmonized']));

  static List<Category> collect(List<dynamic> list) {
    final samples = <Category>[];
    for (final Map<String, dynamic> map in list) {
      final sample = Category.fromJson(map);
      samples.add(sample);
    }
    return samples;
  }
}

class Harmonized {
  const Harmonized(
    this.value,
    this.description,
    this.metadata,
  );

  final int value;
  final String description;
  final Map<String, dynamic> metadata;

  Map<String, dynamic> get map => {
        'value': value,
        'description': description,
        'metadata': metadata,
      };

  Harmonized.fromJson(Map<String, dynamic> json)
      : value = json['value'],
        description = json['description'],
        metadata = json['metadata'];
}
