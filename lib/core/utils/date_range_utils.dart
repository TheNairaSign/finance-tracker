class DateRangeUtils {
  /// Returns the start and end of the given month.
  /// If no date is provided, defaults to [DateTime.now()].
  static Map<String, DateTime> getMonthRange([DateTime? date]) {
    final now = date ?? DateTime.now();
    final startOfMonth = DateTime(now.year, now.month, 1, 0, 0, 0);
    final startOfNextMonth = (now.month == 12)
        ? DateTime(now.year + 1, 1, 1, 0, 0, 0)
        : DateTime(now.year, now.month + 1, 1, 0, 0, 0);

    final endOfMonth = startOfNextMonth.subtract(const Duration(seconds: 1));

    return {
      "start": startOfMonth,
      "end": endOfMonth,
    };
  }

  /// Returns the start and end of today
  static Map<String, DateTime> getDayRange([DateTime? date]) {
    final now = date ?? DateTime.now();
    final startOfDay = DateTime(now.year, now.month, now.day, 0, 0, 0);
    final endOfDay = DateTime(now.year, now.month, now.day, 23, 59, 59);

    return {
      "start": startOfDay,
      "end": endOfDay,
    };
  }

  /// Returns a list of month names in order from January to December
  static List<String> getMonthNames() {
    return [
      'January',
      'February',
      'March',
      'April',
      'May',
      'June',
      'July',
      'August',
      'September',
      'October',
      'November',
      'December'
    ];
  }
}
