import 'package:flutter_test/flutter_test.dart';
import 'package:health_kit_reporter/model/payload/correlation.dart';

void main() {
  test('correlation_parse_from_json', () {
    final json = {
      "device": {
        "manufacturer": "Guy",
        "softwareVersion": "some_2",
        "model": "6.1.1",
        "localIdentifier": "some_3",
        "firmwareVersion": "some_1",
        "udiDeviceIdentifier": "some_4",
        "name": "Guy's iPhone",
        "hardwareVersion": "some_0"
      },
      "sourceRevision": {
        "productType": "CocoaPod",
        "systemVersion": "1.0.0.0",
        "source": {
          "name": "mySource",
          "bundleIdentifier": "com.kvs.hkreporter"
        },
        "operatingSystem": {
          "majorVersion": 1,
          "minorVersion": 1,
          "patchVersion": 1
        },
        "version": "1.0.0"
      },
      "uuid": "BA0ADD39-638C-4FF8-AF48-0FC88CDCC48A",
      "identifier": "HKCorrelationTypeIdentifierBloodPressure",
      "startTimestamp": 1653657145.998812,
      "endTimestamp": 1653657205.998812,
      "harmonized": {
        "metadata": {"you": "saved it"},
        "categorySamples": [],
        "quantitySamples": [
          {
            "device": {
              "manufacturer": "Guy",
              "softwareVersion": "some_2",
              "model": "6.1.1",
              "localIdentifier": "some_3",
              "firmwareVersion": "some_1",
              "udiDeviceIdentifier": "some_4",
              "name": "Guy's iPhone",
              "hardwareVersion": "some_0"
            },
            "sourceRevision": {
              "productType": "CocoaPod",
              "systemVersion": "1.0.0.0",
              "source": {
                "name": "mySource",
                "bundleIdentifier": "com.kvs.hkreporter"
              },
              "operatingSystem": {
                "majorVersion": 1,
                "minorVersion": 1,
                "patchVersion": 1
              },
              "version": "1.0.0"
            },
            "uuid": "52DC2FFB-D361-4CDC-9450-29EFEBD1BD94",
            "identifier": "HKQuantityTypeIdentifierBloodPressureSystolic",
            "startTimestamp": 1653657145.998812,
            "endTimestamp": 1653657205.998812,
            "harmonized": {
              "value": 123,
              "metadata": {"you": "saved it"},
              "unit": "mmHg"
            }
          },
          {
            "device": {
              "manufacturer": "Guy",
              "softwareVersion": "some_2",
              "model": "6.1.1",
              "localIdentifier": "some_3",
              "firmwareVersion": "some_1",
              "udiDeviceIdentifier": "some_4",
              "name": "Guy's iPhone",
              "hardwareVersion": "some_0"
            },
            "sourceRevision": {
              "productType": "CocoaPod",
              "systemVersion": "1.0.0.0",
              "source": {
                "name": "mySource",
                "bundleIdentifier": "com.kvs.hkreporter"
              },
              "operatingSystem": {
                "majorVersion": 1,
                "minorVersion": 1,
                "patchVersion": 1
              },
              "version": "1.0.0"
            },
            "uuid": "3850F06E-383B-476A-BFCC-4A6DF979CFAE",
            "identifier": "HKQuantityTypeIdentifierBloodPressureDiastolic",
            "startTimestamp": 1653657145.998812,
            "endTimestamp": 1653657205.998812,
            "harmonized": {
              "value": 83,
              "metadata": {"you": "saved it"},
              "unit": "mmHg"
            }
          }
        ]
      }
    };
    final sut = Correlation.fromJson(json);
    expect(sut.identifier, "HKCorrelationTypeIdentifierBloodPressure");
    expect(sut.startTimestamp, 1653657145.998812);
    expect(sut.endTimestamp, 1653657205.998812);
    expect(sut.device?.name, "Guy's iPhone");
    expect(sut.device?.manufacturer, "Guy");
    expect(sut.device?.model, "6.1.1");
    expect(sut.device?.hardwareVersion, "some_0");
    expect(sut.device?.firmwareVersion, "some_1");
    expect(sut.device?.softwareVersion, "some_2");
    expect(sut.device?.localIdentifier, "some_3");
    expect(sut.device?.udiDeviceIdentifier, "some_4");
    expect(sut.sourceRevision.source.name, "mySource");
    expect(sut.sourceRevision.source.bundleIdentifier, "com.kvs.hkreporter");
    expect(sut.sourceRevision.version, "1.0.0");
    expect(sut.sourceRevision.productType, "CocoaPod");
    expect(sut.sourceRevision.systemVersion, "1.0.0.0");
    expect(sut.sourceRevision.operatingSystem.majorVersion, 1);
    expect(sut.sourceRevision.operatingSystem.minorVersion, 1);
    expect(sut.sourceRevision.operatingSystem.patchVersion, 1);
    expect(sut.harmonized.quantitySamples.length, 2);
    expect(sut.harmonized.quantitySamples[0].identifier,
        "HKQuantityTypeIdentifierBloodPressureSystolic");
    expect(sut.harmonized.quantitySamples[0].startTimestamp, 1653657145.998812);
    expect(sut.harmonized.quantitySamples[0].endTimestamp, 1653657205.998812);
    expect(sut.harmonized.quantitySamples[0].device?.name, "Guy's iPhone");
    expect(sut.harmonized.quantitySamples[0].device?.manufacturer, "Guy");
    expect(sut.harmonized.quantitySamples[0].device?.model, "6.1.1");
    expect(sut.harmonized.quantitySamples[0].device?.hardwareVersion, "some_0");
    expect(sut.harmonized.quantitySamples[0].device?.firmwareVersion, "some_1");
    expect(sut.harmonized.quantitySamples[0].device?.softwareVersion, "some_2");
    expect(sut.harmonized.quantitySamples[0].device?.localIdentifier, "some_3");
    expect(sut.harmonized.quantitySamples[0].device?.udiDeviceIdentifier,
        "some_4");
    expect(sut.harmonized.quantitySamples[0].sourceRevision.source.name,
        "mySource");
    expect(
        sut.harmonized.quantitySamples[0].sourceRevision.source
            .bundleIdentifier,
        "com.kvs.hkreporter");
    expect(sut.harmonized.quantitySamples[0].sourceRevision.version, "1.0.0");
    expect(sut.harmonized.quantitySamples[0].sourceRevision.productType,
        "CocoaPod");
    expect(sut.harmonized.quantitySamples[0].sourceRevision.systemVersion,
        "1.0.0.0");
    expect(
        sut.harmonized.quantitySamples[0].sourceRevision.operatingSystem
            .majorVersion,
        1);
    expect(
        sut.harmonized.quantitySamples[0].sourceRevision.operatingSystem
            .minorVersion,
        1);
    expect(
        sut.harmonized.quantitySamples[0].sourceRevision.operatingSystem
            .patchVersion,
        1);
    expect(sut.harmonized.quantitySamples[0].harmonized.value, 123);
    expect(sut.harmonized.quantitySamples[0].harmonized.unit, "mmHg");
    expect(sut.harmonized.quantitySamples[0].harmonized.metadata,
        {"you": "saved it"});
    expect(sut.harmonized.quantitySamples[1].identifier,
        "HKQuantityTypeIdentifierBloodPressureDiastolic");
    expect(sut.harmonized.quantitySamples[1].startTimestamp, 1653657145.998812);
    expect(sut.harmonized.quantitySamples[1].endTimestamp, 1653657205.998812);
    expect(sut.harmonized.quantitySamples[1].device?.name, "Guy's iPhone");
    expect(sut.harmonized.quantitySamples[1].device?.manufacturer, "Guy");
    expect(sut.harmonized.quantitySamples[1].device?.model, "6.1.1");
    expect(sut.harmonized.quantitySamples[1].device?.hardwareVersion, "some_0");
    expect(sut.harmonized.quantitySamples[1].device?.firmwareVersion, "some_1");
    expect(sut.harmonized.quantitySamples[1].device?.softwareVersion, "some_2");
    expect(sut.harmonized.quantitySamples[1].device?.localIdentifier, "some_3");
    expect(sut.harmonized.quantitySamples[1].device?.udiDeviceIdentifier,
        "some_4");
    expect(sut.harmonized.quantitySamples[1].sourceRevision.source.name,
        "mySource");
    expect(
        sut.harmonized.quantitySamples[1].sourceRevision.source
            .bundleIdentifier,
        "com.kvs.hkreporter");
    expect(sut.harmonized.quantitySamples[1].sourceRevision.version, "1.0.0");
    expect(sut.harmonized.quantitySamples[1].sourceRevision.productType,
        "CocoaPod");
    expect(sut.harmonized.quantitySamples[1].sourceRevision.systemVersion,
        "1.0.0.0");
    expect(
        sut.harmonized.quantitySamples[1].sourceRevision.operatingSystem
            .majorVersion,
        1);
    expect(
        sut.harmonized.quantitySamples[1].sourceRevision.operatingSystem
            .minorVersion,
        1);
    expect(
        sut.harmonized.quantitySamples[1].sourceRevision.operatingSystem
            .patchVersion,
        1);
    expect(sut.harmonized.quantitySamples[1].harmonized.value, 83);
    expect(sut.harmonized.quantitySamples[1].harmonized.unit, "mmHg");
    expect(sut.harmonized.quantitySamples[1].harmonized.metadata,
        {"you": "saved it"});
    expect(sut.harmonized.categorySamples.length, 0);
    expect(sut.harmonized.metadata, {"you": "saved it"});
  });
}
