import '../../exceptions.dart';

enum DocumentType {
  cda,
}

extension DocumentTypeIdentifier on DocumentType {
  String get identifier {
    switch (this) {
      case DocumentType.cda:
        return 'HKDocumentTypeIdentifierCDA';
    }
    throw InvalidValueException('Unknown case: $this');
  }
}
