import 'package:flutter_test/flutter_test.dart';
import 'package:health_kit_reporter_example/demo/catalog.dart';

void main() {
  test('every_row_runs_or_listens', () {
    final sections = Catalog().sections;
    expect(sections.map((e) => e.title), contains('Steps: save, read, delete'));
    for (final row in sections.expand((e) => e.rows)) {
      expect(row.run != null || row.listen != null, isTrue, reason: row.title);
    }
  });
}
