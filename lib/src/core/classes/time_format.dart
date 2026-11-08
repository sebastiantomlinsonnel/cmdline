part of 'moment.dart';

/// Turns a Moment in a new format
class TimeFormat {
  static const TimeFormat worded = const TimeFormat([
    The,
    Do,
    of,
    mmmm,
    yyyy,
    at,
    hh,
    colon,
    mm,
    colon,
    ss,
  ]);

  /// A list of words and keys that specify the format
  final List<String> tokens;

  /// Default constructor
  const TimeFormat(this.tokens);

  /// Constructs a TimeFormat from a list of tokens separated by spaces in a string
  TimeFormat.fromString(String string) : this.tokens = string.split(' ');

  /// Builds a formatted date/time string by evaluating each token in
  /// [formatStyle] against this [Moment]'s values.
  ///
  /// Tokens that don't match a known format specifier are passed through
  /// as literal strings, so you can mix separators and text freely.
  ///
  /// ```dart
  /// final m = Moment.now();
  /// m.format(formatStyle: [dddd, comma, space, mmmm, space, D, comma, space, yyyy]);
  /// // → "Wednesday, February 19, 2026"
  /// ```
  String format(Moment moment) {
    StringBuffer val = StringBuffer();
    for (int i = 0; i < tokens.length; i++) {
      final String _token = '${formatToken(moment, tokens[i])}';
      val.write(_token);
    }
    return val.toString();
  }

  /// Resolves a single format [token] into its string value for the
  /// given [moment].
  ///
  /// This powers the [format] method. You generally won't call it directly,
  /// but it's public so you can extend or override token behaviour.
  String? formatToken(Moment moment, String token) {
    switch (token) {
      case ddd:
        return '${weekDayNames[moment.weekday]!.substring(0, 3)} ';
      case dddd:
        return '${weekDayNames[moment.weekday]} ';
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
        return '${monthNames[moment.month]!.substring(0, 3)} ';
      case mmmm:
        return '${monthNames[moment.month]} ';
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
