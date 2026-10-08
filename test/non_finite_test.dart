import 'package:flutter_test/flutter_test.dart';
import 'package:health_kit_reporter/model/payload/quantity.dart';
import 'package:health_kit_reporter/model/payload/statistics.dart';

import 'fixtures.dart';

void main() {
  test('non_finite_strings_parse_as_doubles', () {
    expect(Quantity.fromJson(quantityJson(value: 'Infinity')).harmonized.value,
        double.infinity);
    expect(Quantity.fromJson(quantityJson(value: '-Infinity')).harmonized.value,
        double.negativeInfinity);
    expect(Quantity.fromJson(quantityJson(value: 'NaN')).harmonized.value.isNaN,
        isTrue);
  });

  test('non_finite_strings_parse_in_optional_fields', () {
    final json = statisticsJson();
    json['harmonized'] = {
      ...json['harmonized'],
      'average': 'NaN',
      'min': '-Infinity',
      'max': 'Infinity',
    };
    final sut = Statistics.fromJson(json);
    expect(sut.harmonized.average!.isNaN, isTrue);
    expect(sut.harmonized.min, double.negativeInfinity);
    expect(sut.harmonized.max, double.infinity);
    expect(sut.harmonized.summary, 1200);
  });

  test('other_strings_are_not_numbers', () {
    expect(() => Quantity.fromJson(quantityJson(value: 'inf')),
        throwsFormatException);
  });
}
