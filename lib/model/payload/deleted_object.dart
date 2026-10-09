import 'metadata.dart';
import 'payload.dart';

/// Equivalent of [DeletedObject]
/// from [HealthKitReporter] https://github.com/kvs-coder/HealthKitReporter
///
/// Supports [map] representation.
///
/// Has a [DeletedObject.fromJson] constructor
/// to create instances from JSON payload coming from iOS native code.
///
class DeletedObject with Payload {
  const DeletedObject(this.uuid, this.metadata);

  final String uuid;
  final Metadata? metadata;

  /// General map representation
  ///
  @override
  Map<String, dynamic> get map => {
        'uuid': uuid,
        'metadata': metadata?.map,
      };

  /// General constructor from JSON payload
  ///
  DeletedObject.fromJson(Map<String, dynamic> json)
      : uuid = json['uuid'],
        metadata = Metadata.tryFromJson(json['metadata']);
}
