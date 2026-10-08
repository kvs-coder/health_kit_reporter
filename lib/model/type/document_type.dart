/// Equivalent of [DocumentType]
/// from [HealthKitReporter] https://github.com/kvs-coder/HealthKitReporter
///
/// Supports [identifier] extension representing
/// original [String] of the type.
///
enum DocumentType {
  cda,
}

extension DocumentTypeIdentifier on DocumentType {
  String get identifier {
    switch (this) {
      case DocumentType.cda:
        return 'HKDocumentTypeIdentifierCDA';
    }
  }
}
