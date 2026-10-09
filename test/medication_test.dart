import 'package:flutter_test/flutter_test.dart';
import 'package:health_kit_reporter/model/payload/medication_dose_event.dart';
import 'package:health_kit_reporter/model/payload/user_annotated_medication.dart';

import 'fixtures.dart';

void main() {
  test('medication_dose_event_parse_from_json', () {
    final sut = MedicationDoseEvent.fromJson(medicationDoseEventJson());
    expect(sut.uuid, 'DOSE-UUID');
    expect(sut.identifier,
        'HKMedicationDoseEventTypeIdentifierMedicationDoseEvent');
    expect(sut.harmonized.scheduleType, 2);
    expect(sut.harmonized.medicationConceptIdentifier, 'Q09OQ0VQVA==');
    expect(sut.harmonized.scheduledTimestamp, 1601065700.0);
    expect(sut.harmonized.scheduledDoseQuantity, 1);
    expect(sut.harmonized.doseQuantity, 1);
    expect(sut.harmonized.logStatus, 4);
    expect(sut.harmonized.unit, 'count');
  });

  test('as_needed_dose_has_no_schedule', () {
    final json = medicationDoseEventJson();
    (json['harmonized'] as Map)
      ..['scheduleType'] = 1
      ..remove('scheduledTimestamp')
      ..remove('scheduledDoseQuantity');
    final sut = MedicationDoseEvent.fromJson(json);
    expect(sut.harmonized.scheduledTimestamp, isNull);
    expect(sut.harmonized.scheduledDoseQuantity, isNull);
  });

  test('user_annotated_medication_parse_from_json', () {
    final sut = UserAnnotatedMedication.fromJson(userAnnotatedMedicationJson());
    expect(sut.nickname, 'Morning pill');
    expect(sut.isArchived, isFalse);
    expect(sut.hasSchedule, isTrue);
    expect(sut.medication.identifier, 'Q09OQ0VQVA==');
    expect(sut.medication.domain, 'medication');
    expect(sut.medication.displayText, 'Ibuprofen 200 mg');
    expect(sut.medication.generalForm, 'tablet');
    final coding = sut.medication.relatedCodings.single;
    expect(coding.system, 'http://www.nlm.nih.gov/research/umls/rxnorm');
    expect(coding.version, isNull);
    expect(coding.code, '310965');
    expect(UserAnnotatedMedication.fromJson(sut.map).map, sut.map);
  });
}
