import 'package:flutter_test/flutter_test.dart';
import 'package:health_kit_reporter/model/payload/attachment.dart';
import 'package:health_kit_reporter/model/payload/metadata.dart';

import 'fixtures.dart';

void main() {
  test('attachment_parse_from_json', () {
    final sut = Attachment.fromJson(attachmentJson());
    expect(sut.identifier, 'ATTACHMENT-UUID');
    expect(sut.name, 'scan.jpg');
    expect(sut.contentType, 'public.jpeg');
    expect(sut.size, 2048);
    expect(sut.creationTimestamp, 1601065755.0);
    expect(sut.metadata!['source'], const MetadataString('camera'));
    expect(Attachment.fromJson(sut.map).map, sut.map);
  });
}
