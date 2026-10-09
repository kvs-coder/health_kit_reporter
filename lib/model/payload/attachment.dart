import '../decorator/extensions.dart';
import 'metadata.dart';

/// Equivalent of [Attachment]
/// from [HealthKitReporter] https://github.com/kvs-coder/HealthKitReporter
///
/// File attached to a sample, e.g. a scanned prescription (iOS 16+).
///
/// Supports [map] representation.
///
/// Has a [Attachment.fromJson] constructor
/// to create instances from JSON payload coming from iOS native code.
/// And supports multiple object creation by [collect] method from JSON list.
///
class Attachment {
  const Attachment(
    this.identifier,
    this.name,
    this.contentType,
    this.size,
    this.creationTimestamp,
    this.metadata,
  );

  /// The uuid of the attachment
  final String identifier;
  final String name;

  /// Uniform type identifier, e.g. "public.jpeg"
  final String contentType;

  /// Bytes
  final int size;

  /// Seconds since 1970
  final num creationTimestamp;
  final Metadata? metadata;

  /// General map representation
  ///
  Map<String, dynamic> get map => {
        'identifier': identifier,
        'name': name,
        'contentType': contentType,
        'size': size,
        'creationTimestamp': creationTimestamp,
        'metadata': metadata?.map,
      };

  /// General constructor from JSON payload
  ///
  Attachment.fromJson(Map<String, dynamic> json)
      : identifier = json['identifier'],
        name = json['name'],
        contentType = json['contentType'],
        size = parseNum(json['size']).toInt(),
        creationTimestamp = parseNum(json['creationTimestamp']),
        metadata = Metadata.tryFromJson(json['metadata']);

  /// Simplifies creating a list of objects from JSON payload.
  ///
  static List<Attachment> collect(List<dynamic> list) =>
      parseList(list, Attachment.fromJson);
}
