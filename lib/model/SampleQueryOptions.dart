import 'package:health_kit_reporter/health_kit_reporter.dart';

/// The query options are used in HealthKit when querying samples
/// The default query option is both [strictStartDate] and [strictEndDate]
/// this allows you to choose either of the 3 other options
enum SampleQueryOption { strictStartDate, strictEndDate, notStrict }

extension Value on SampleQueryOption {
  String get value {
    switch (this) {
      case SampleQueryOption.strictStartDate:
        return "strictStartDate";
      case SampleQueryOption.strictEndDate:
        return "strictEndDate";
      case SampleQueryOption.notStrict:
        return "notStrict";
    }
  }
}
