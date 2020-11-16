class InvalidValueException implements Exception {
  const InvalidValueException(this.cause);

  final String cause;
}
