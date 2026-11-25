class Fmt {
  static String temp(num? v) => v == null ? '--°' : '${v.round()}°';
  static String tempUnit(num? v) => v == null ? '--°C' : '${v.round()}°C';
  static String percent(num? v) => v == null ? '--%' : '${v.round()}%';
  static String wind(num? v) =>
      v == null ? '-- km/j' : '${v.toStringAsFixed(1)} km/j';
  static String mm(num? v) =>
      v == null ? '-- mm' : '${v.toStringAsFixed(1)} mm';

  static const _days = ['Sen', 'Sel', 'Rab', 'Kam', 'Jum', 'Sab', 'Min'];
  static String dayShort(DateTime d) => _days[d.weekday - 1];
  static String dateShort(DateTime d) => '${d.day}/${d.month}';

  static bool isToday(DateTime d) {
    final now = DateTime.now();
    return d.year == now.year && d.month == now.month && d.day == now.day;
  }
}
