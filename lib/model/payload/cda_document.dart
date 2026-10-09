import '../decorator/extensions.dart';
import '../type/document_type.dart';
import 'metadata.dart';
import 'sample.dart';

/// Equivalent of [CDADocument]
/// from [HealthKitReporter] https://github.com/kvs-coder/HealthKitReporter
///
/// Consolidated Clinical Document (CDA) sample.
///
/// Supports [map] representation.
///
/// Has a [CDADocument.fromJson] constructor
/// to create instances from JSON payload coming from iOS native code.
/// And supports multiple object creation by [collect] method from JSON list.
///
/// Requires [DocumentType.cda] permissions provided.
///
class CDADocument extends Sample<CDADocumentHarmonized> {
  const CDADocument(
    super.uuid,
    super.identifier,
    super.startTimestamp,
    super.endTimestamp,
    super.device,
    super.sourceRevision,
    super.harmonized,
  );

  /// General map representation
  ///
  @override
  Map<String, dynamic> get map => {
        'uuid': uuid,
        'identifier': identifier,
        'startTimestamp': startTimestamp,
        'endTimestamp': endTimestamp,
        'device': device?.map,
        'sourceRevision': sourceRevision.map,
        'harmonized': harmonized.map,
      };

  /// General constructor from JSON payload
  ///
  CDADocument.fromJson(Map<String, dynamic> json)
      : super.from(
            json,
            CDADocumentHarmonized.fromJson(
                Map<String, dynamic>.from(json['harmonized'])));

  /// Simplifies creating a list of objects from JSON payload.
  ///
  static List<CDADocument> collect(List<dynamic> list) =>
      parseList(list, CDADocument.fromJson);
}

/// Equivalent of [CDADocument.Harmonized]
/// from [HealthKitReporter] https://github.com/kvs-coder/HealthKitReporter
///
/// [HealthKit] extracts the title, patient, author and custodian
/// from the CDA XML in [documentData] when saving.
///
class CDADocumentHarmonized {
  const CDADocumentHarmonized(
    this.title,
    this.patientName,
    this.authorName,
    this.custodianName,
    this.documentData,
    this.metadata,
  );

  final String? title;
  final String? patientName;
  final String? authorName;
  final String? custodianName;

  /// Base64 encoded CDA XML; null unless the query includes document data
  final String? documentData;
  final Metadata? metadata;

  /// General map representation
  ///
  Map<String, dynamic> get map => {
        'title': title,
        'patientName': patientName,
        'authorName': authorName,
        'custodianName': custodianName,
        'documentData': documentData,
        'metadata': metadata?.map,
      };

  /// General constructor from JSON payload
  ///
  CDADocumentHarmonized.fromJson(Map<String, dynamic> json)
      : title = json['title'],
        patientName = json['patientName'],
        authorName = json['authorName'],
        custodianName = json['custodianName'],
        documentData = json['documentData'],
        metadata = Metadata.tryFromJson(json['metadata']);
}
