import '../../decorator/extensions.dart';
import 'biological_sex.dart';
import 'blood_type.dart';
import 'fitzpatrick_skin_type.dart';

class Characteristic {
  const Characteristic(
    this.biologicalSex,
    this.birthday,
    this.bloodType,
    this.skinType,
  );

  final BiologicalSex biologicalSex;
  final DateTime birthday;
  final BloodType bloodType;
  final FitzpatrickSkinType skinType;

  Map<String, String> get map => {
        'biologicalSex': biologicalSex.string,
        'birthday': birthday?.toIso8601String(),
        'bloodType': bloodType.string,
        'skinType': skinType.string,
      };

  Characteristic.fromJson(Map<String, dynamic> json)
      : biologicalSex = BiologicalSexFactory.from(json['biologicalSex']),
        birthday = json['birthday']?.toString()?.date,
        bloodType = BloodTypeFactory.from(json['bloodType']),
        skinType = FitzpatrickSkinTypeFactory.from(json['skinType']);
}
