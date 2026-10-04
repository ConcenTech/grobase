DateTime max(DateTime a, DateTime b) {
  return a.isAfter(b) ? a : b;
}

extension DateTimeExtensions on DateTime {
  DateTime get startOfDay => DateTime(year, month, day);
}
