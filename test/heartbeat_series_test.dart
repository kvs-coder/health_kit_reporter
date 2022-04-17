import 'package:flutter_test/flutter_test.dart';
import 'package:health_kit_reporter/model/payload/heartbeat_series.dart';

void main() {
  test('heartbeat_series_parse_from_json', () {
    final json = {
      'device': {
        'softwareVersion': '8.0.1',
        'manufacturer': 'Apple Inc.',
        'model': 'Watch',
        'name': 'Apple Watch',
        'hardwareVersion': 'Watch6,1'
      },
      'sourceRevision': {
        'productType': 'Watch6,1',
        'systemVersion': '8.0.1',
        'source': {
          'name': 'Apple Watch von Victor',
          'bundleIdentifier':
              'com.apple.health.9482C212-CB6B-4949-A400-E448CCA82CEF'
        },
        'operatingSystem': {
          'majorVersion': 8,
          'minorVersion': 0,
          'patchVersion': 1
        },
        'version': '8.0.1'
      },
      'uuid': '40975CB7-93FB-4D83-982C-072951654541',
      'identifier': 'HKDataTypeIdentifierHeartbeatSeries',
      'startTimestamp': 1634308957.9276123,
      'endTimestamp': 1634309012.3221436,
      'harmonized': {
        'count': 39,
        'measurements': [
          {
            'precededByGap': true,
            'done': false,
            'timeSinceSeriesStart': 0.95703125
          },
          {
            'precededByGap': false,
            'done': false,
            'timeSinceSeriesStart': 1.6875
          },
          {'precededByGap': true, 'done': false, 'timeSinceSeriesStart': 4},
          {
            'precededByGap': false,
            'done': false,
            'timeSinceSeriesStart': 4.76171875
          },
          {
            'precededByGap': false,
            'done': false,
            'timeSinceSeriesStart': 5.5390625
          },
          {
            'precededByGap': false,
            'done': false,
            'timeSinceSeriesStart': 6.265625
          },
          {
            'precededByGap': false,
            'done': false,
            'timeSinceSeriesStart': 7.22265625
          },
          {
            'precededByGap': true,
            'done': false,
            'timeSinceSeriesStart': 10.234375
          },
          {
            'precededByGap': false,
            'done': false,
            'timeSinceSeriesStart': 11.04296875
          },
          {
            'precededByGap': false,
            'done': false,
            'timeSinceSeriesStart': 11.87890625
          },
          {
            'precededByGap': false,
            'done': false,
            'timeSinceSeriesStart': 12.69921875
          },
          {
            'precededByGap': false,
            'done': false,
            'timeSinceSeriesStart': 13.51171875
          },
          {
            'precededByGap': false,
            'done': false,
            'timeSinceSeriesStart': 14.359375
          },
          {
            'precededByGap': false,
            'done': false,
            'timeSinceSeriesStart': 15.203125
          },
          {
            'precededByGap': false,
            'done': false,
            'timeSinceSeriesStart': 16.03515625
          },
          {
            'precededByGap': false,
            'done': false,
            'timeSinceSeriesStart': 16.85546875
          },
          {
            'precededByGap': false,
            'done': false,
            'timeSinceSeriesStart': 17.671875
          },
          {
            'precededByGap': false,
            'done': false,
            'timeSinceSeriesStart': 18.48046875
          },
          {
            'precededByGap': false,
            'done': false,
            'timeSinceSeriesStart': 19.30859375
          },
          {
            'precededByGap': false,
            'done': false,
            'timeSinceSeriesStart': 20.16015625
          },
          {
            'precededByGap': false,
            'done': false,
            'timeSinceSeriesStart': 20.98046875
          },
          {
            'precededByGap': false,
            'done': false,
            'timeSinceSeriesStart': 21.87109375
          },
          {
            'precededByGap': false,
            'done': false,
            'timeSinceSeriesStart': 22.61328125
          },
          {
            'precededByGap': true,
            'done': false,
            'timeSinceSeriesStart': 25.1328125
          },
          {
            'precededByGap': true,
            'done': false,
            'timeSinceSeriesStart': 27.77734375
          },
          {
            'precededByGap': false,
            'done': false,
            'timeSinceSeriesStart': 28.69140625
          },
          {
            'precededByGap': false,
            'done': false,
            'timeSinceSeriesStart': 29.58203125
          },
          {
            'precededByGap': true,
            'done': false,
            'timeSinceSeriesStart': 44.4609375
          },
          {
            'precededByGap': false,
            'done': false,
            'timeSinceSeriesStart': 45.45703125
          },
          {
            'precededByGap': false,
            'done': false,
            'timeSinceSeriesStart': 46.421875
          },
          {
            'precededByGap': false,
            'done': false,
            'timeSinceSeriesStart': 47.328125
          },
          {
            'precededByGap': false,
            'done': false,
            'timeSinceSeriesStart': 48.21484375
          },
          {
            'precededByGap': false,
            'done': false,
            'timeSinceSeriesStart': 49.02734375
          },
          {
            'precededByGap': false,
            'done': false,
            'timeSinceSeriesStart': 49.86328125
          },
          {
            'precededByGap': false,
            'done': false,
            'timeSinceSeriesStart': 50.7421875
          },
          {
            'precededByGap': false,
            'done': false,
            'timeSinceSeriesStart': 51.6328125
          },
          {
            'precededByGap': false,
            'done': false,
            'timeSinceSeriesStart': 52.5703125
          },
          {
            'precededByGap': false,
            'done': false,
            'timeSinceSeriesStart': 53.5234375
          },
          {
            'precededByGap': false,
            'done': true,
            'timeSinceSeriesStart': 54.39453125
          }
        ],
        'metadata': {'HKAlgorithmVersion': '1'}
      }
    };
    final sut = HeartbeatSeries.fromJson(json);
    expect(sut.uuid, '40975CB7-93FB-4D83-982C-072951654541');
    expect(sut.identifier, 'HKDataTypeIdentifierHeartbeatSeries');
    expect(sut.startTimestamp, 1634308957.9276123);
    expect(sut.endTimestamp, 1634309012.3221436);
    expect(sut.device?.name, 'Apple Watch');
    expect(sut.device?.manufacturer, 'Apple Inc.');
    expect(sut.device?.softwareVersion, '8.0.1');
    expect(sut.device?.model, 'Watch');
    expect(sut.device?.hardwareVersion, 'Watch6,1');
    expect(sut.sourceRevision.source.name, 'Apple Watch von Victor');
    expect(sut.sourceRevision.source.bundleIdentifier,
        'com.apple.health.9482C212-CB6B-4949-A400-E448CCA82CEF');
    expect(sut.sourceRevision.version, '8.0.1');
    expect(sut.sourceRevision.productType, 'Watch6,1');
    expect(sut.sourceRevision.systemVersion, '8.0.1');
    expect(sut.sourceRevision.operatingSystem.majorVersion, 8);
    expect(sut.sourceRevision.operatingSystem.minorVersion, 0);
    expect(sut.sourceRevision.operatingSystem.patchVersion, 1);
    expect(sut.harmonized.count, 39);
    expect(sut.harmonized.measurements.length, 39);
    expect(sut.harmonized.measurements[0].precededByGap, true);
    expect(sut.harmonized.measurements[0].done, false);
    expect(sut.harmonized.measurements[0].timeSinceSeriesStart, 0.95703125);
    expect(sut.harmonized.measurements[1].precededByGap, false);
    expect(sut.harmonized.measurements[1].done, false);
    expect(sut.harmonized.measurements[1].timeSinceSeriesStart, 1.6875);
    expect(sut.harmonized.measurements.last.precededByGap, false);
    expect(sut.harmonized.measurements.last.done, true);
    expect(sut.harmonized.measurements.last.timeSinceSeriesStart, 54.39453125);
    expect(sut.harmonized.metadata, {'HKAlgorithmVersion': '1'});
  });
}
