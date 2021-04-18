/// Equivalent of [DeletedObject]
/// from [HealthKitReporter] https://cocoapods.org/pods/HealthKitReporter
///
/// Supports [map] representation.
///
/// Has a [DeletedObject.fromJson] constructor
/// to create instances from JSON payload coming from iOS native code.
///
class DeletedObject {
  const DeletedObject(this.uuid, this.metadata);

  final String uuid;
  final Map<String, dynamic> metadata;

  /// General map representation
  ///
  Map<String, dynamic> get map => {
        'uuid': uuid,
        'metadata': metadata,
      };

  /// General constructor from JSON payload
  ///
  DeletedObject.fromJson(Map<String, dynamic> json)
      : uuid = json['uuid'],
        metadata = json['metadata'];
}
