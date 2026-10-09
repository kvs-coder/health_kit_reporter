import 'package:flutter_test/flutter_test.dart';
import 'package:health_kit_reporter/model/payload/audiogram.dart';

import 'fixtures.dart';

void main() {
  test('audiogram_parse_from_json', () {
    final sut = Audiogram.fromJson(audiogramJson());
    expect(sut.uuid, 'AUDIOGRAM-UUID');
    expect(sut.identifier, 'HKDataTypeIdentifierAudiogram');
    expect(sut.startTimestamp, 1601065755.0);
    final first = sut.harmonized.sensitivityPoints.first;
    expect(first.frequency, 1000);
    expect(first.leftEarSensitivity, 20);
    expect(first.rightEarSensitivity, 25.5);
    expect(first.tests!.single.sensitivity, 20);
    expect(first.tests!.single.conductionType, 0);
    expect(first.tests!.single.masked, isFalse);
    expect(first.tests!.single.side, 0);
    final second = sut.harmonized.sensitivityPoints.last;
    expect(second.rightEarSensitivity, isNull);
    expect(second.tests, isNull);
    expect(sut.harmonized.metadata, isNull);
  });

  test('audiogram_is_sent_as_audiogram', () {
    final sut = Audiogram.fromJson(audiogramJson());
    expect(sut.parsed().keys, ['audiogram']);
    expect(sut.parsed()['audiogram']['uuid'], 'AUDIOGRAM-UUID');
  });
}
