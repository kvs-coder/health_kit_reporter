import '../../exceptions.dart';

enum ElectrocardiogramType {
  electrocardiogramType,
}

extension Identifier on ElectrocardiogramType {
  String get identifier {
    switch (this) {
      case ElectrocardiogramType.electrocardiogramType:
        return 'HKDataTypeIdentifierElectrocardiogram';
    }
    throw InvalidValueException('Unknown case: $this');
  }
}
