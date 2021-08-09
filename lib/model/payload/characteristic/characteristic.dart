import 'package:health_kit_reporter/model/type/characteristic_type.dart';

import '../../decorator/extensions.dart';
import 'biological_sex.dart';
import 'blood_type.dart';
import 'fitzpatrick_skin_type.dart';

/// Equivalent of [Characteristic]
/// from [HealthKitReporter] https://cocoapods.org/pods/HealthKitReporter
///
/// Supports [map] representation.
///
/// Has a [Characteristic.fromJson] constructor
/// to create instances from JSON payload coming from iOS native code.
///
/// Requires [CharacteristicType] permissions provided.
///
class Characteristic {
  const Characteristic(
    this.biologicalSex,
    this.birthday,
    this.bloodType,
    this.skinType,
  );

  final BiologicalSex? biologicalSex;
  final DateTime? birthday;
  final BloodType? bloodType;
  final FitzpatrickSkinType? skinType;

  Map<String, String?> get map => {
        'biologicalSex': biologicalSex?.string,
        'birthday': birthday?.toIso8601String(),
        'bloodType': bloodType?.string,
        'skinType': skinType?.string,
      };

  /// General constructor from JSON payload
  ///
  Characteristic.fromJson(Map<String, dynamic> json)
      : biologicalSex = BiologicalSexFactory.from(json['biologicalSex']),
        birthday = json['birthday']?.toString().date,
        bloodType = BloodTypeFactory.from(json['bloodType'] ?? 'na'),
        skinType = FitzpatrickSkinTypeFactory.from(json['skinType'] ?? 'na');
}
