extension Date on String {
  DateTime get date => this != null ? DateTime.tryParse(this) : null;
}
