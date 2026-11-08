part of 'moment.dart';

/// A reusable pattern that turns a [Moment] into text.
///
/// Letter runs that match a token (like `Do`, `MMMM`, `HH`) are replaced with
/// the moment's value. Everything else is kept exactly as written. Wrap text
/// in `[brackets]` to stop it being read as a token, e.g. `'[a] h:mm'`.
///
/// ```dart
/// final f = TimeFormat('The $Do of $mmmm $yyyy at $HH:$mm:$ss');
/// f.format(Moment.now()); // → "The 8th of November 2026 at 14:35:09"
/// ```
class TimeFormat {
  /// The default format, like `The 8th of November 2026 at 14:35:09`.
  static const TimeFormat worded = TimeFormat(
    'The Do of MMMM yyyy at HH:mm:ss',
  );

  /// The 24-hour time, like `14:05:09`.
  static const TimeFormat time24 = TimeFormat(t);

  /// The 12-hour time with AM/PM, like `2:05:09 PM`.
  static const TimeFormat time12 = TimeFormat(T);

  /// The ISO 8601 date, like `2026-11-08`.
  static const TimeFormat isoDate = TimeFormat('yyyy-MM-DD');

  /// The ISO 8601 date and time, like `2026-11-08T14:05:09`.
  static const TimeFormat isoDateTime = TimeFormat('yyyy-MM-DD[T]HH:mm:ss');

  /// The day-first numeric date, like `08/11/2026`.
  static const TimeFormat dateUk = TimeFormat('DD/MM/yyyy');

  /// The month-first numeric date, like `11/08/2026`.
  static const TimeFormat dateUs = TimeFormat('MM/DD/yyyy');

  /// A short date with the month abbreviated, like `8 Nov 2026`.
  static const TimeFormat shortDate = TimeFormat('D MMM yyyy');

  /// A long date with the full month name, like `8 November 2026`.
  static const TimeFormat longDate = TimeFormat('D MMMM yyyy');

  /// The full date with the weekday, like `Sunday, 8 November 2026`.
  static const TimeFormat fullDate = TimeFormat('dddd, D MMMM yyyy');

  /// The full date in US order, like `Sunday, November 8, 2026`.
  static const TimeFormat fullDateUs = TimeFormat('dddd, MMMM D, yyyy');

  /// A compact day and month, like `Sun 8 Nov`.
  static const TimeFormat dayMonth = TimeFormat('ddd D MMM');

  /// The month and year, like `November 2026`.
  static const TimeFormat monthYear = TimeFormat('MMMM yyyy');

  /// A spoken-style date, like `Sunday the 8th of November 2026`.
  static const TimeFormat spokenDate = TimeFormat('dddd the Do of MMMM yyyy');

  /// The 24-hour time without seconds, like `14:05`.
  static const TimeFormat shortTime24 = TimeFormat('HH:mm');

  /// The 12-hour time without seconds, like `2:05 PM`.
  static const TimeFormat shortTime12 = TimeFormat('h:mm A');

  /// The numeric date and short time, like `08/11/2026 14:05`.
  static const TimeFormat dateTime = TimeFormat('DD/MM/yyyy HH:mm');

  /// A sortable timestamp for logs, like `2026-11-08 14:05:09`.
  static const TimeFormat log = TimeFormat('yyyy-MM-DD HH:mm:ss');

  /// A timestamp that's safe in file names, like `2026-11-08_14-05-09`.
  static const TimeFormat fileSafe = TimeFormat('yyyy-MM-DD_HH-mm-ss');

  /// A friendly date and 12-hour time, like `Sun 8 Nov, 2:05 PM`.
  static const TimeFormat friendly = TimeFormat('ddd D MMM, h:mm A');

  /// The pattern string this format was created from.
  final String pattern;

  /// Creates a format from a [pattern] string.
  const TimeFormat(this.pattern);

  /// Matches `[escaped text]`, a run of letters, or any single other character.
  static final RegExp _splitter = RegExp(r'\[[^\]]*\]|[A-Za-z]+|[^A-Za-z]');

  /// Patterns already split into tokens, so each one is only parsed once.
  static final Map<String, List<String>> _cache = {};

  /// The tokens and literal pieces that make up [pattern].
  List<String> get tokens => _cache.putIfAbsent(
    pattern,
    () => _splitter.allMatches(pattern).map((match) => match[0]!).toList(),
  );

  /// Builds the formatted string for [moment].
  String format(Moment moment) =>
      tokens.map((token) => formatToken(moment, token)).join();

  /// Turns one [token] into its value for [moment], or returns it as literal text.
  ///
  /// This powers [format]. You generally won't call it directly, but it's
  /// public so you can extend or override token behaviour. Missing values
  /// on [moment] are treated as 0 (or 1 for the date and month).
  String formatToken(Moment moment, String token) {
    final int second = moment.second ?? 0;
    final int minute = moment.minute ?? 0;
    final int hour = moment.hour ?? 0;
    final int date = moment.date ?? 1;
    final int month = moment.month ?? 1;
    final int year = moment.year ?? 0;
    final int hour12 = hour % 12 == 0 ? 12 : hour % 12;

    switch (token) {
      case ddd:
        return (_WEEK_DAY_NAMES[moment.weekday] ?? '   ').substring(0, 3);
      case dddd:
        return _WEEK_DAY_NAMES[moment.weekday] ?? '';
      case D:
        return '$date';
      case Do:
        return '$date${_getOrdinal(date)}';
      case DD:
        return _pad(date);
      case M:
        return '$month';
      case Mo:
        return '$month${_getOrdinal(month)}';
      case MM:
        return _pad(month);
      case MMM:
        return _MONTH_NAMES[month]!.substring(0, 3);
      case MMMM:
        return _MONTH_NAMES[month]!;
      case yy:
        return _pad(year % 100);
      case yyyy:
        return '$year';
      case h:
        return '$hour12';
      case hh:
        return _pad(hour12);
      case H:
        return '$hour';
      case HH:
        return _pad(hour);
      case m:
        return '$minute';
      case mm:
        return _pad(minute);
      case s:
        return '$second';
      case ss:
        return _pad(second);
      case A:
        return moment.clockPhase;
      case a:
        return moment.clockPhase.toLowerCase();
      case t:
        return moment.time;
      case T:
        return moment.clock;
      case dateNumeric:
        return '${_pad(date)}/${_pad(month)}/$year';
      default:
        if (token.length >= 2 && token.startsWith('[') && token.endsWith(']')) {
          return token.substring(1, token.length - 1);
        }
        return token;
    }
  }

  /// Pads [value] to at least two digits, like `5` → `05`.
  String _pad(int value) => value.toString().padLeft(2, '0');

  /// The English ordinal suffix for [value], like `st` for 1 or `th` for 11.
  String _getOrdinal(int value) {
    final int lastTwo = value.abs() % 100;
    if (lastTwo >= 11 && lastTwo <= 13) return 'th';
    return switch (lastTwo % 10) {
      1 => 'st',
      2 => 'nd',
      3 => 'rd',
      _ => 'th',
    };
  }
}
