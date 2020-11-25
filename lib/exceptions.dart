/// General exception to be thrown if an attempt of
/// creating an instance will fail.
///
class InvalidValueException implements Exception {
  const InvalidValueException(this.cause);

  /// The message payload of the error.
  ///
  final String cause;
}
