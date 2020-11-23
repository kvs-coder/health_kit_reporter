import 'source.dart';

class SourceRevision {
  const SourceRevision(
    this.source,
    this.version,
    this.productType,
    this.systemVersion,
    this.operatingSystem,
  );

  final Source source;
  final String version;
  final String productType;
  final String systemVersion;
  final OperatingSystem operatingSystem;

  Map<String, dynamic> get map => {
        'source': source.map,
        'version': version,
        'productType': productType,
        'systemVersion': systemVersion,
        'operatingSystem': operatingSystem.map,
      };

  SourceRevision.fromJson(Map<String, dynamic> json)
      : source = Source.fromJson(json['source']),
        version = json['version'],
        productType = json['productType'],
        systemVersion = json['systemVersion'],
        operatingSystem = OperatingSystem.fromJson(json['operatingSystem']);
}

class OperatingSystem {
  const OperatingSystem(
    this.majorVersion,
    this.minorVersion,
    this.patchVersion,
  );

  final int majorVersion;
  final int minorVersion;
  final int patchVersion;

  Map<String, int> get map => {
        'majorVersion': majorVersion,
        'minorVersion': minorVersion,
        'patchVersion': patchVersion,
      };

  OperatingSystem.fromJson(Map<String, dynamic> json)
      : majorVersion = json['majorVersion'],
        minorVersion = json['minorVersion'],
        patchVersion = json['patchVersion'];
}
