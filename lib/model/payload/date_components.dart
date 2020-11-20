class DateComponents {
  const DateComponents({
    this.era,
    this.year,
    this.month,
    this.day,
    this.hour,
    this.minute,
    this.second,
    this.nanosecond,
    this.weekday,
    this.weekdayOrdinal,
    this.quarter,
    this.weekOfMonth,
    this.weekOfYear,
    this.yearForWeekOfYear,
  });
  final int era;
  final int year;
  final int month;
  final int day;
  final int hour;
  final int minute;
  final int second;
  final int nanosecond;
  final int weekday;
  final int weekdayOrdinal;
  final int quarter;
  final int weekOfMonth;
  final int weekOfYear;
  final int yearForWeekOfYear;

  Map<String, int> get map => {
        'era': era,
        'year': year,
        'month': month,
        'day': day,
        'hour': hour,
        'minute': minute,
        'second': second,
        'nanosecond': nanosecond,
        'weekday': weekday,
        'weekdayOrdinal': weekdayOrdinal,
        'quarter': quarter,
        'weekOfMonth': weekOfMonth,
        'weekOfYear': weekOfYear,
        'yearForWeekOfYear': yearForWeekOfYear
      };
}
