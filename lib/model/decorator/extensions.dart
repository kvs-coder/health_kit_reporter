/// General date extension
///
extension Date on String {
  /// Try to parse the date coming from native side
  /// Expected format from native side is [yyyy-MM-dd'T'HH:mm:ss.SSSZZZZZ]
  ///
  DateTime get date => DateTime.parse(this);
}
