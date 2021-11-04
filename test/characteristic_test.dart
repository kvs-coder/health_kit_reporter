import 'package:flutter_test/flutter_test.dart';
import 'package:health_kit_reporter/model/decorator/extensions.dart';
import 'package:health_kit_reporter/model/payload/characteristic/activity_move_mode.dart';
import 'package:health_kit_reporter/model/payload/characteristic/biological_sex.dart';
import 'package:health_kit_reporter/model/payload/characteristic/blood_type.dart';
import 'package:health_kit_reporter/model/payload/characteristic/characteristic.dart';
import 'package:health_kit_reporter/model/payload/characteristic/fitzpatrick_skin_type.dart';
import 'package:health_kit_reporter/model/payload/characteristic/wheelchair_use.dart';

void main() {
  test('characteristic_parse_from_json', () {
    final json = {
      'biologicalSex': 'Male',
      'birthday': '1986-09-02T20:56:55.000+02:00',
      'bloodType': 'AB+',
      'fitzpatrickSkinType': 'II',
      'wheelchairUse': 'Yes',
      'activityMoveMode': 'Active energy'
    };
    final sut = Characteristic.fromJson(json);
    expect(sut.biologicalSex, BiologicalSex.male);
    expect(sut.birthday, '1986-09-02T20:56:55.000+02:00'.toString().date);
    expect(sut.bloodType, BloodType.abPositive);
    expect(sut.fitzpatrickSkinType, FitzpatrickSkinType.ii);
    expect(sut.wheelchairUse, WheelchairUse.yes);
    expect(sut.activityMoveMode, ActivityMoveMode.activeEnergy);
  });
}
