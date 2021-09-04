import '../../decorator/extensions.dart';
import 'activity_move_mode.dart';
import 'biological_sex.dart';
import 'blood_type.dart';
import 'fitzpatrick_skin_type.dart';
import 'wheelchair_use.dart';

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
    this.fitzpatrickSkinType,
    this.wheelchairUseType,
    this.activityMoveModeType,
  );

  final BiologicalSex? biologicalSex;
  final DateTime? birthday;
  final BloodType? bloodType;
  final FitzpatrickSkinType? fitzpatrickSkinType;
  final WheelchairUseType? wheelchairUseType;
  final ActivityMoveModeType? activityMoveModeType;

  Map<String, String?> get map => {
        'biologicalSex': biologicalSex?.string,
        'birthday': birthday?.toIso8601String(),
        'bloodType': bloodType?.string,
        'fitzpatrickSkinType': fitzpatrickSkinType?.string,
        'wheelchairUseType': wheelchairUseType?.string,
        'activityMoveModeType': activityMoveModeType?.string,
      };

  /// General constructor from JSON payload
  ///
  Characteristic.fromJson(Map<String, dynamic> json)
      : biologicalSex = BiologicalSexFactory.from(json['biologicalSex']),
        birthday = json['birthday']?.toString().date,
        bloodType = BloodTypeFactory.from(json['bloodType']),
        fitzpatrickSkinType =
            FitzpatrickSkinTypeFactory.from(json['fitzpatrickSkinType']),
        wheelchairUseType =
            WheelchairUseTypeFactory.from(json['wheelchairUse']),
        activityMoveModeType =
            ActivityMoveModeTypeFactory.from(json['activityMoveMode']);
}
