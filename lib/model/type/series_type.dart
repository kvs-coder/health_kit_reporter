import '../../exceptions.dart';

enum SeriesType {
  heartbeatSeries,
  route,
}

extension Identifier on SeriesType {
  String get identifier {
    switch (this) {
      case SeriesType.heartbeatSeries:
        return 'HKDataTypeIdentifierHeartbeatSeries';
      case SeriesType.route:
        return 'HKWorkoutRouteTypeIdentifier';
    }
    throw InvalidValueException('Unknown case: $this');
  }
}
