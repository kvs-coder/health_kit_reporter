extension Date on String {
  DateTime get date => this != null ? DateTime.tryParse(this) : null;
}

extension Integer on String {
  int get integer => int.parse(this);
}
