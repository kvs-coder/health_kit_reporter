import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:health_kit_reporter/model/payload/metadata.dart';
import 'package:health_kit_reporter/model/payload/quantity.dart';

import 'fixtures.dart';

void main() {
  const json = {
    'HKTimeZone': 'Europe/Berlin',
    'HKWasUserEntered': true,
    'HKSyncVersion': 2,
    'HKAverageMETs': 3.5,
    'HKDateOfEarliestDataUsedForEstimate': {'timestamp': 1601065755.5},
    'HKHeartRateEventThreshold': {'value': 120, 'unit': 'count/min'},
  };

  test('metadata_parses_every_value_kind', () {
    final sut = Metadata.fromJson(json);
    expect(sut['HKTimeZone'], const MetadataString('Europe/Berlin'));
    expect(sut['HKWasUserEntered'], const MetadataBool(true));
    expect(sut['HKSyncVersion'], const MetadataNumber(2));
    expect(sut['HKAverageMETs'], const MetadataNumber(3.5));
    expect(sut['HKDateOfEarliestDataUsedForEstimate'],
        const MetadataDate(1601065755.5));
    expect(sut['HKHeartRateEventThreshold'],
        const MetadataQuantity(120, 'count/min'));
    expect(sut['missing'], isNull);
  });

  test('metadata_date_is_seconds_since_1970', () {
    final date = Metadata.fromJson(json)['HKDateOfEarliestDataUsedForEstimate']
        as MetadataDate;
    expect(date.date.toUtc(), DateTime.utc(2020, 9, 25, 20, 29, 15, 500));
    expect(MetadataDate.fromDateTime(date.date), date);
  });

  test('metadata_round_trips_in_the_same_flat_shape', () {
    final sut = Metadata.fromJson(json);
    expect(sut.map, json);
    expect(Metadata.fromJson(jsonDecode(jsonEncode(sut.map))), sut);
  });

  test('metadata_round_trips_through_a_sample', () {
    final sut = Quantity.fromJson(quantityJson(metadata: json));
    expect(sut.harmonized.metadata, Metadata.fromJson(json));
    final sent = sut.parsed()['quantity']['harmonized']['metadata'];
    expect(sent, json);
  });

  test('metadata_is_optional', () {
    final sut = Quantity.fromJson(quantityJson());
    expect(sut.harmonized.metadata, isNull);
    expect(sut.map['harmonized']['metadata'], isNull);
  });

  test('metadata_rejects_the_old_nested_shape', () {
    expect(
        () => Metadata.fromJson({
              'string': {
                'dictionary': {'HKTimeZone': 'Europe/Berlin'}
              }
            }),
        throwsFormatException);
  });
}
