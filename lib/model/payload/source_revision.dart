import 'source.dart';

/// Equivalent of [SourceRevision]
/// from [HealthKitReporter] https://cocoapods.org/pods/HealthKitReporter
///
/// Supports [map] representation.
///
/// Has a [SourceRevision.fromJson] constructor
/// to create instances from JSON payload coming from iOS native code.
///
class SourceRevision {
  const SourceRevision(
    this.source,
    this.version,
    this.productType,
    this.systemVersion,
    this.operatingSystem,
  );

  final Source source;
  final String? version;
  final String? productType;
  final String systemVersion;
  final OperatingSystem operatingSystem;

  /// General map representation
  ///
  Map<String, dynamic> get map => {
        'source': source.map,
        'version': version,
        'productType': productType,
        'systemVersion': systemVersion,
        'operatingSystem': operatingSystem.map,
      };

  /// General constructor from JSON payload
  ///
  SourceRevision.fromJson(Map<String, dynamic> json)
      : source = Source.fromJson(json['source']),
        version = json['version'],
        productType = json['productType'],
        systemVersion = json['systemVersion'],
        operatingSystem = OperatingSystem.fromJson(json['operatingSystem']);
}

/// Equivalent of [SourceRevision.OperatingSystem]
/// from [HealthKitReporter] https://cocoapods.org/pods/HealthKitReporter
///
/// Supports [map] representation.
///
/// Has a [OperatingSystem.fromJson] constructor
/// to create instances from JSON payload coming from iOS native code.
///
class OperatingSystem {
  const OperatingSystem(
    this.majorVersion,
    this.minorVersion,
    this.patchVersion,
  );

  final int majorVersion;
  final int minorVersion;
  final int patchVersion;

  /// General map representation
  ///
  Map<String, int> get map => {
        'majorVersion': majorVersion,
        'minorVersion': minorVersion,
        'patchVersion': patchVersion,
      };

  /// General constructor from JSON payload
  ///
  OperatingSystem.fromJson(Map<String, dynamic> json)
      : majorVersion = json['majorVersion'],
        minorVersion = json['minorVersion'],
        patchVersion = json['patchVersion'];
}
