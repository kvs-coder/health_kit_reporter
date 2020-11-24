/// General exception to be thrown if an attempt of
/// creating an instance will fail.
///
class InvalidValueException implements Exception {
  const InvalidValueException(this.cause);

  final String cause;
}
