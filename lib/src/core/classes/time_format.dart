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

  /// 24 hour
  static const TimeFormat time = TimeFormat('$t');

  /// 12 hour
  static const TimeFormat shortTime = TimeFormat('$T');

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
  String format(Moment moment) {
    return tokens.map((token) => formatToken(moment, token)).join().trim();
  }

  /// Resolves a single format [token] into its string value for the
  /// given [moment].
  ///
  /// This powers the [format] method. You generally won't call it directly,
  /// but it's public so you can extend or override token behaviour.
  String? formatToken(Moment moment, String token) {
    switch (token) {
      case ddd:
        return '${_WEEK_DAY_NAMES[moment.weekday]!.substring(0, 3)} ';
      case dddd:
        return '${_WEEK_DAY_NAMES[moment.weekday]} ';
      case D:
        return moment.date.toString();
      case Do:
        return '${moment.date}${_getOrdinal(moment.date!)}';
      case DD:
        return moment.date.toString().padLeft(2, '0');
      case M:
        return moment.month.toString();
      case Mo:
        return '${moment.month}${_getOrdinal(moment.month)}';
      case MM:
        return moment.month.toString().padLeft(2, '0');
      case MMM:
        return '${_MONTH_NAMES[moment.month]!.substring(0, 3)} ';
      case mmmm:
        return '${_MONTH_NAMES[moment.month]} ';
      case yy:
        return moment.year.toString().substring(2);
      case yyyy:
        return moment.year.toString();
      case h:
        final int hour12 = moment.hour! % 12;
        return hour12 == 0 ? '12' : hour12.toString();
      case hh:
        final int hour12 = moment.hour! % 12;
        return (hour12 == 0 ? 12 : hour12).toString().padLeft(2, '0');
      case H:
        return moment.hour.toString();
      case HH:
        return moment.hour.toString().padLeft(2, '0');
      case m:
        return moment.minute.toString();
      case mm:
        return moment.minute.toString().padLeft(2, '0');
      case s:
        return moment.second.toString();
      case ss:
        return moment.second.toString().padLeft(2, '0');
      case A:
        return moment.clockPhase;
      case a:
        return moment.clockPhase.toLowerCase();
      case t:
        return '${moment.hour}:${moment.minute}:${moment.second}';
      case T:
        return '${moment.clock}';
      case dateNumeric:
        return '${moment.date.toString().padLeft(2, '0')}/${moment.month.toString().padLeft(2, '0')}/${moment.year}';
      default:
        if (token == ':' || token == '-') {
          return token;
        }
        if (token != ' ') {
          return ' $token ';
        }
        return '';
    }
  }

  String _getOrdinal(int? value) {
    final String valString = value.toString();
    if (valString.length >= 2) {
      final int trailingTwo = int.parse(
        value.toString().substring(valString.length - 2, valString.length),
      );
      if (trailingTwo == 11 || trailingTwo == 12 || trailingTwo == 13) {
        return 'th';
      }
    }
    final int trailing = int.parse(
      value.toString()[value.toString().length - 1],
    );
    switch (trailing) {
      case 1:
        return 'st';
      case 2:
        return 'nd';
      case 3:
        return 'rd';
      default:
        return 'th';
    }
  }
}
