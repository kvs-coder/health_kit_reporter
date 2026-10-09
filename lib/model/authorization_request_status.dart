import '../exceptions.dart';

/// Equivalent of [AuthorizationRequestStatus]
/// from [HealthKitReporter] https://github.com/kvs-coder/HealthKitReporter
///
/// Whether [HealthKitReporter.requestAuthorization] would show the permission sheet.
///
/// Supports [value] extension representing
/// original [int] of the type.
///
/// Has a factory methods [from]
/// Creating from [int]
///
enum AuthorizationRequestStatus {
  unknown,
  shouldRequest,
  unnecessary,
}

extension AuthorizationRequestStatusValue on AuthorizationRequestStatus {
  int get value {
    switch (this) {
      case AuthorizationRequestStatus.unknown:
        return 0;
      case AuthorizationRequestStatus.shouldRequest:
        return 1;
      case AuthorizationRequestStatus.unnecessary:
        return 2;
    }
  }
}

extension AuthorizationRequestStatusFactory on AuthorizationRequestStatus {
  static AuthorizationRequestStatus from(int value) {
    for (final status in AuthorizationRequestStatus.values) {
      if (status.value == value) {
        return status;
      }
    }
    throw InvalidValueException('Unknown authorization request status: $value');
  }
}
