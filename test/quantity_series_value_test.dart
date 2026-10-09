import 'package:flutter_test/flutter_test.dart';
import 'package:health_kit_reporter/model/payload/quantity_series_value.dart';

import 'fixtures.dart';

void main() {
  test('quantity_series_value_parse_from_json', () {
    final sut = QuantitySeriesValue.fromJson(quantitySeriesValueJson());
    expect(sut.value, 12);
    expect(sut.unit, 'count');
    expect(sut.startTimestamp, 1601065755.0);
    expect(sut.endTimestamp, 1601065815.0);
    expect(sut.sampleUUID, 'SERIES-UUID');
  });

  test('quantity_series_value_to_write_has_no_sample_uuid', () {
    const sut = QuantitySeriesValue(12, 'count', 1601065755.0, 1601065815.0);
    expect(sut.map['sampleUUID'], isNull);
    expect(QuantitySeriesValue.fromJson(sut.map).map, sut.map);
  });
}
