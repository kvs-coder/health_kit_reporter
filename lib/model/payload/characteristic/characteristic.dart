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
  final BiologicalSex? biologicalSex;
  final DateTime? birthday;
  final BloodType? bloodType;
  final FitzpatrickSkinType? fitzpatrickSkinType;
  final WheelchairUse? wheelchairUse;
  final ActivityMoveMode? activityMoveMode;

  Map<String, String?> get map => {
        'biologicalSex': biologicalSex?.description,
        'birthday': birthday?.toIso8601String(),
        'bloodType': bloodType?.description,
        'fitzpatrickSkinType': fitzpatrickSkinType?.description,
        'wheelchairUse': wheelchairUse?.description,
        'activityMoveMode': activityMoveMode?.description,
      };

  /// General constructor from JSON payload
  ///
  Characteristic.fromJson(Map<String, dynamic> json)
      : biologicalSex = BiologicalSexFactory.from(json['biologicalSex']),
        birthday = json['birthday']?.toString().date,
        bloodType = BloodTypeFactory.from(json['bloodType']),
        fitzpatrickSkinType =
            FitzpatrickSkinTypeFactory.from(json['fitzpatrickSkinType']),
        wheelchairUse = WheelchairUseFactory.from(json['wheelchairUse']),
        activityMoveMode =
            ActivityMoveModeFactory.from(json['activityMoveMode']);
}
