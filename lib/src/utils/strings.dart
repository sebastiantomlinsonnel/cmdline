import 'package:cmdline/cmdline.dart';

import 'graphemes.dart';
import 'printable_table.dart';

/// Where to add padding when a result is shorter than requested.
///
/// Used by functions such as [Strings.left] and [Strings.right].
enum Pad {
  /// Add the padding to the left of the String.
  left,

  /// Add the padding to the right of the String.
  right,

  /// Do not pad the String.
  none,
}

/// The last code point in the C0 control range.
const int _c0End = 0x1F;

/// The highest valid Unicode code point.
const int _unicodeEnd = 0x10FFFF;

const int _digitMask = 0x1;
const int _lowerMask = 0x2;
const int _underscoreMask = 0x4;
const int _upperMask = 0x8;
const int _alphaMask = _lowerMask | _upperMask;
const int _alphaNumMask = _alphaMask | _digitMask;

/// Classification flags for an ASCII code point.
///
/// Returns 0 for anything that is not an ASCII digit, letter or underscore.
int _asciiFlags(int c) {
  if (c >= 0x30 && c <= 0x39) return _digitMask;
  if (c >= 0x61 && c <= 0x7A) return _lowerMask;
  if (c >= 0x41 && c <= 0x5A) return _upperMask;
  if (c == 0x5F) return _underscoreMask;
  return 0;
}

/// Classification flags for a grapheme.
///
/// Only single code point ASCII graphemes get flags; everything else is 0.
int _graphemeFlags(String grapheme) {
  final runes = grapheme.runes;
  if (runes.length != 1) return 0;
  final c = runes.first;
  return c <= DEL ? _asciiFlags(c) : 0;
}

/// Null-safe String utilities that extend the core [String] API.
///
/// A [Strings] method never throws on a null argument. A null String is
/// treated as an empty String, or as a space-filled String where a range is
/// requested, so the caller gets a result of the expected length.
///
/// ```dart
/// Strings.substring(null, 2, 3);
/// // -> ' '
/// ```
class Strings {
  Strings._();

  /// Whether [string] parses as a number.
  ///
  /// Parsing uses [double.tryParse]. `Infinity` and `NaN` are not treated as
  /// numbers. Returns false for null.
  static bool isNumeric(String? string) {
    if (string == null) {
      return false;
    }
    if (string == double.infinity.toString() ||
        string == double.nan.toString()) {
      return false;
    }

    return double.tryParse(string) != null;
  }

  /// Whether [string] only contains ASCII characters.
  ///
  /// Returns false for null and true for an empty string.
  static bool isAscii(String? string) {
    if (string == null) {
      return false;
    }
    for (final s in graphemes(string)) {
      final runes = s.runes;
      if (runes.length != 1) {
        return false;
      }
      final c = runes.first;
      if (c < 0 || c > DEL) {
        return false;
      }
    }
    return true;
  }

  /// Whether [string] only contains the digits 0-9.
  ///
  /// Returns false for null and true for an empty string.
  static bool isDigits(String? string) {
    if (string == null) {
      return false;
    }
    for (var i = 0; i < string.length; i++) {
      if (!'0123456789'.contains(string[i])) {
        return false;
      }
    }
    return true;
  }

  /// Whether [string] contains no upper case letters.
  ///
  /// Returns true for null and for an empty string. A non-ASCII character
  /// counts as upper case when it equals its own [String.toUpperCase], so
  /// caseless characters such as CJK make this return false.
  static bool isLowerCase(String? string) {
    if (string == null || string.isEmpty) {
      return true;
    }

    for (final s in graphemes(string)) {
      final runes = s.runes;
      if (runes.length == 1) {
        final c = runes.first;
        if (c <= DEL) {
          if (_asciiFlags(c) & _upperMask != 0) {
            return false;
          }
        } else if (s == s.toUpperCase()) {
          return false;
        }
      }
    }

    return true;
  }

  /// Whether [character] is visible when printed to the console.
  ///
  /// Control, format, separator, unassigned, private use and surrogate code
  /// points are not printable. Returns false for null and for values outside
  /// the Unicode range 0..0x10FFFF.
  static bool isPrintable(int? character) {
    if (character == null) {
      return false;
    }
    return !isNonPrintable(character);
  }

  /// Whether every character in [string] is whitespace.
  ///
  /// Whitespace matches the set used by [String.trim], which includes
  /// Unicode spaces as well as space, tab and newline. Returns true for an
  /// empty string.
  static bool isWhitespace(String string) {
    for (final element in string.runes) {
      if (!isWhitespaceRune(element)) {
        return false;
      }
    }
    return true;
  }

  /// Whether [rune] is a whitespace character.
  ///
  /// Whitespace matches the set used by [String.trim], which includes
  /// Unicode spaces as well as space, tab and newline.
  static bool isWhitespaceRune(int rune) =>
      (rune >= 0x0009 && rune <= 0x000D) ||
      rune == 0x0020 ||
      rune == 0x0085 ||
      rune == 0x00A0 ||
      rune == 0x1680 ||
      rune == 0x180E ||
      (rune >= 0x2000 && rune <= 0x200A) ||
      rune == 0x2028 ||
      rune == 0x2029 ||
      rune == 0x202F ||
      rune == 0x205F ||
      rune == 0x3000 ||
      rune == 0xFEFF;

  /// Whether [string] contains no lower case letters.
  ///
  /// Returns true for null and for an empty string. A non-ASCII character
  /// counts as lower case when it equals its own [String.toLowerCase].
  ///
  /// ```dart
  /// Strings.isUpperCase('CamelCase'); // false
  /// Strings.isUpperCase('DART');      // true
  /// Strings.isUpperCase('');          // true
  /// ```
  static bool isUpperCase(String? string) {
    if (string == null || string.isEmpty) {
      return true;
    }

    for (final s in graphemes(string)) {
      final runes = s.runes;
      if (runes.length == 1) {
        final c = runes.first;
        if (c <= DEL) {
          if (_asciiFlags(c) & _lowerMask != 0) {
            return false;
          }
        } else if (s == s.toLowerCase()) {
          return false;
        }
      }
    }

    return true;
  }

  /// Whether [string] starts with a lower case character.
  ///
  /// Returns false for null and for an empty string. A non-ASCII first
  /// character counts as lower case when it equals its own
  /// [String.toLowerCase], so caseless characters also return true.
  ///
  /// ```dart
  /// Strings.startsWithLowerCase('camelCase'); // true
  /// Strings.startsWithLowerCase('');          // false
  /// ```
  static bool startsWithLowerCase(String? string) {
    if (string == null || string.isEmpty) {
      return false;
    }

    final s = graphemes(string).first;
    final runes = s.runes;
    if (runes.length == 1) {
      final c = runes.first;
      if (c <= DEL) {
        return _asciiFlags(c) & _lowerMask != 0;
      }
      return s == s.toLowerCase();
    }

    return false;
  }

  /// Whether [string] starts with an upper case character.
  ///
  /// Returns false for null and for an empty string. A non-ASCII first
  /// character counts as upper case when it equals its own
  /// [String.toUpperCase], so caseless characters also return true.
  ///
  /// ```dart
  /// Strings.startsWithUpperCase('Dart'); // true
  /// Strings.startsWithUpperCase('');     // false
  /// ```
  static bool startsWithUpperCase(String? string) {
    if (string == null || string.isEmpty) {
      return false;
    }

    final s = graphemes(string).first;
    final runes = s.runes;
    if (runes.length == 1) {
      final c = runes.first;
      if (c <= DEL) {
        return _asciiFlags(c) & _upperMask != 0;
      }
      return s == s.toUpperCase();
    }

    return false;
  }

  /// Converts snake_case [string] to UpperCamelCase.
  ///
  /// Pass [lower] to get lowerCamelCase instead. The input is lower cased
  /// first. Returns an empty string for null.
  ///
  /// ```dart
  /// Strings.toCamelCase('dart_vm');              // 'DartVm'
  /// Strings.toCamelCase('dart_vm', lower: true); // 'dartVm'
  /// ```
  static String toCamelCase(String? string, {bool lower = false}) {
    if (string == null) {
      return '';
    }
    if (string.isEmpty) {
      return string;
    }

    var capitalize = true;
    var position = 0;
    var remove = false;
    final sb = StringBuffer();
    for (final s in graphemes(string.toLowerCase())) {
      final flag = _graphemeFlags(s);

      if (capitalize && flag & _alphaMask != 0) {
        if (lower && position == 0) {
          sb.write(s);
        } else {
          sb.write(s.toUpperCase());
        }

        capitalize = false;
        remove = true;
        position++;
      } else if (flag & _underscoreMask != 0) {
        if (!remove) {
          sb.write(s);
          remove = true;
        }

        capitalize = true;
      } else {
        if (flag & _alphaNumMask != 0) {
          capitalize = false;
          remove = true;
        } else {
          capitalize = true;
          remove = false;
          position = 0;
        }

        sb.write(s);
      }
    }

    return sb.toString();
  }

  /// Upper cases the first character of [string].
  ///
  /// The rest of the string is left as is. Returns an empty string for null
  /// or empty input.
  ///
  /// ```dart
  /// Strings.toCapitalised('hello world'); // 'Hello world'
  /// ```
  static String toCapitalised(String? string) {
    if (string == null || string.isEmpty) {
      return '';
    }

    final first = graphemes(string).first;
    return first.toUpperCase() + string.substring(first.length);
  }

  /// Converts every space-separated word in [sentence] to Proper Case.
  ///
  /// Each word is lower cased and then has its first letter upper cased.
  /// Repeated spaces collapse to one. Returns an empty string for null.
  ///
  /// ```dart
  /// Strings.toProperCase('hELLO  wORLD'); // 'Hello World'
  /// ```
  static String toProperCase(String? sentence) {
    if (sentence == null) {
      return '';
    }
    final result = <String>[];

    for (final word in sentence.split(' ')) {
      final lower = word.toLowerCase();
      if (lower.isNotEmpty) {
        result.add(
          '${lower.substring(0, 1).toUpperCase()}${lower.substring(1)}',
        );
      }
    }
    return result.join(' ');
  }

  /// Converts camelCase [string] to snake_case.
  ///
  /// Returns an empty string for null or empty input.
  ///
  /// ```dart
  /// Strings.toSnakeCase('DartVm'); // 'dart_vm'
  /// ```
  static String toSnakeCase(String? string) {
    if (string == null || string.isEmpty) {
      return '';
    }

    final sb = StringBuffer();
    var separate = false;
    for (final s in graphemes(string)) {
      final flag = _graphemeFlags(s);

      if (separate && flag & _upperMask != 0) {
        sb
          ..write('_')
          ..write(s.toLowerCase());
      } else {
        separate =
            flag & _alphaNumMask != 0 ||
            (flag & _underscoreMask != 0 && separate);
        sb.write(s.toLowerCase());
      }
    }

    return sb.toString();
  }

  /// Reverses [string] by user-perceived characters.
  ///
  /// Emoji sequences, flags and accented letters stay intact. Returns an
  /// empty string for null.
  static String reverse(String? string) {
    if (string == null) {
      return '';
    }
    if (string.length < 2) {
      return string;
    }

    return graphemes(string).toList().reversed.join();
  }

  /// Escapes [string] so it can be pasted into Dart source.
  ///
  /// Tab, newline and carriage return become `\t`, `\n` and `\r`. Quotes,
  /// `$` and `\` are backslash escaped. Other control and non-printable
  /// characters are passed to [encode], which defaults to [toUnicode].
  /// Returns an empty string for null or empty input.
  static String toEscape(
    String? string, {
    String Function(int charCode)? encode,
  }) {
    if (string == null || string.isEmpty) {
      return '';
    }

    encode ??= Strings.toUnicode;
    final sb = StringBuffer();
    for (final s in graphemes(string)) {
      final runes = s.runes;
      if (runes.length != 1) {
        // Multi code point clusters are assumed not to need escaping.
        sb.write(s);
        continue;
      }
      final c = runes.first;
      if (c <= _c0End) {
        switch (c) {
          case 9:
            sb.write(r'\t');
          case 10:
            sb.write(r'\n');
          case 13:
            sb.write(r'\r');
          default:
            sb.write(encode(c));
        }
      } else if (c <= DEL) {
        switch (c) {
          case 34:
            sb.write(r'\"');
          case 36:
            sb.write(r'\$');
          case 39:
            sb.write(r"\'");
          case 92:
            sb.write(r'\\');
          default:
            sb.write(s);
        }
      } else if (isPrintable(c)) {
        sb.write(s);
      } else {
        sb.write(encode(c));
      }
    }

    return sb.toString();
  }

  /// Makes control and non-printable characters in [string] visible.
  ///
  /// Tab, newline and carriage return become `\t`, `\n` and `\r`. Other
  /// non-printable characters become `\uXXXX`. Unlike [toEscape], quotes and
  /// backslashes are left alone. Returns an empty string for null or empty
  /// input.
  ///
  /// ```dart
  /// Strings.toPrintable("Hello 'world' \n"); // r"Hello 'world' \n"
  /// ```
  static String toPrintable(String? string) {
    if (string == null || string.isEmpty) {
      return '';
    }

    final sb = StringBuffer();
    for (final s in graphemes(string)) {
      final runes = s.runes;
      if (runes.length != 1) {
        // Multi code point clusters are assumed to be printable.
        sb.write(s);
        continue;
      }
      final c = runes.first;
      if (c <= _c0End) {
        switch (c) {
          case 9:
            sb.write(r'\t');
          case 10:
            sb.write(r'\n');
          case 13:
            sb.write(r'\r');
          default:
            sb.write(Strings.toUnicode(c));
        }
      } else if (isPrintable(c)) {
        sb.write(s);
      } else {
        sb.write(Strings.toUnicode(c));
      }
    }

    return sb.toString();
  }

  /// Formats [charCode] as a Dart unicode escape such as `\u000a`.
  ///
  /// The hex part is padded to at least 4 digits. Returns an empty string for
  /// null. Throws a [RangeError] if [charCode] is outside 0..0x10FFFF.
  static String toUnicode(int? charCode) {
    if (charCode == null) {
      return '';
    }
    if (charCode < 0 || charCode > _unicodeEnd) {
      throw RangeError.range(charCode, 0, _unicodeEnd, 'charCode');
    }

    return '\\u${charCode.toRadixString(16).padLeft(4, '0')}';
  }

  /// Joins [list] with [separator], using [last] before the final item.
  ///
  /// ```dart
  /// Strings.conjuctionJoin(['a', 'b', 'c']); // 'a, b or c'
  /// ```
  static String conjuctionJoin(
    List<String> list, {
    String separator = ', ',
    String last = ' or ',
  }) {
    switch (list.length) {
      case 0:
        return '';
      case 1:
        return list.first;
      default:
        return '${list.sublist(0, list.length - 1).join(separator)}'
            '$last${list.last}';
    }
  }

  /// Null-safe [String.length].
  ///
  /// A null [string] is treated as an empty String.
  static int length(String? string) => (string ?? '').length;

  /// Null-safe [String.codeUnits].
  ///
  /// A null [string] is treated as an empty String.
  static List<int> codeUnits(String? string) => (string ?? '').codeUnits;

  /// Null-safe [String.runes].
  ///
  /// A null [string] is treated as an empty String.
  static Runes runes(String? string) => (string ?? '').runes;

  /// Null-safe [Pattern.allMatches] on a String [pattern].
  ///
  /// A null [pattern] is treated as an empty String.
  static Iterable<Match> allMatches(
    String? pattern,
    String string, [
    int start = 0,
  ]) => (pattern ?? '').allMatches(string, start);

  /// Null-safe [String.codeUnitAt].
  ///
  /// A null [string] is treated as an empty String, so any [index] throws a
  /// [RangeError].
  static int codeUnitAt(String? string, int index) =>
      (string ?? '').codeUnitAt(index);

  /// Null-safe [String.compareTo].
  ///
  /// Returns 0 when [string] and [other] are equal, including both null.
  /// When only one is null, [nullIsLessThan] decides whether null sorts
  /// before (-1) or after (1) the other value.
  static int compareTo(
    String? string,
    String? other, {
    bool nullIsLessThan = true,
  }) {
    if (string == other) {
      return 0;
    }
    if (string == null) {
      return nullIsLessThan ? -1 : 1;
    }
    if (other == null) {
      return nullIsLessThan ? 1 : -1;
    }
    return string.compareTo(other);
  }

  /// Null-safe [String.contains].
  ///
  /// A null [string] is treated as an empty String.
  static bool contains(String? string, Pattern other, [int startIndex = 0]) =>
      (string ?? '').contains(other, startIndex);

  /// Null-safe [String.endsWith].
  ///
  /// Returns false if either [string] or [other] is null.
  static bool endsWith(String? string, String? other) {
    if (string == null || other == null) {
      return false;
    }

    return string.endsWith(other);
  }

  /// Null-safe [String.indexOf].
  ///
  /// A null [string] is treated as an empty String.
  static int indexOf(String? string, Pattern pattern, [int start = 0]) =>
      (string ?? '').indexOf(pattern, start);

  /// Null-safe [String.lastIndexOf].
  ///
  /// A null [string] is treated as an empty String.
  static int lastIndexOf(String? string, Pattern pattern, [int? start]) =>
      (string ?? '').lastIndexOf(pattern, start);

  /// Null-safe [Pattern.matchAsPrefix] on a String [pattern].
  ///
  /// A null [pattern] is treated as an empty String.
  static Match? matchAsPrefix(
    String? pattern,
    String string, [
    int start = 0,
  ]) => (pattern ?? '').matchAsPrefix(string, start);

  /// Null-safe [String.padLeft].
  ///
  /// A null [string] is treated as an empty String.
  static String padLeft(String? string, int width, [String padding = ' ']) =>
      (string ?? '').padLeft(width, padding);

  /// Null-safe [String.padRight].
  ///
  /// A null [string] is treated as an empty String.
  static String padRight(String? string, int width, [String padding = ' ']) =>
      (string ?? '').padRight(width, padding);

  /// Null-safe [String.replaceAll].
  ///
  /// A null [string] is treated as an empty String.
  static String replaceAll(String? string, Pattern from, String replace) =>
      (string ?? '').replaceAll(from, replace);

  /// Null-safe [String.replaceAllMapped].
  ///
  /// A null [string] is treated as an empty String.
  static String replaceAllMapped(
    String? string,
    Pattern from,
    String Function(Match match) replace,
  ) => (string ?? '').replaceAllMapped(from, replace);

  /// Null-safe [String.replaceFirst].
  ///
  /// A null [string] is treated as an empty String.
  static String replaceFirst(
    String? string,
    Pattern from,
    String to, [
    int startIndex = 0,
  ]) => (string ?? '').replaceFirst(from, to, startIndex);

  /// Null-safe [String.replaceFirstMapped].
  ///
  /// A null [string] is treated as an empty String.
  static String replaceFirstMapped(
    String? string,
    Pattern from,
    String Function(Match match) replace, [
    int startIndex = 0,
  ]) => (string ?? '').replaceFirstMapped(from, replace, startIndex);

  /// Null-safe [String.replaceRange].
  ///
  /// A null [string] is treated as an empty String.
  static String replaceRange(
    String? string,
    int start,
    int? end,
    String replacement,
  ) => (string ?? '').replaceRange(start, end, replacement);

  /// Null-safe [String.split].
  ///
  /// A null [string] is treated as an empty String.
  static List<String> split(String? string, Pattern pattern) =>
      (string ?? '').split(pattern);

  /// Null-safe [String.splitMapJoin].
  ///
  /// A null [string] is treated as an empty String.
  static String splitMapJoin(
    String? string,
    Pattern pattern, {
    String Function(Match)? onMatch,
    String Function(String)? onNonMatch,
  }) => (string ?? '').splitMapJoin(
    pattern,
    onMatch: onMatch,
    onNonMatch: onNonMatch,
  );

  /// Null-safe [String.startsWith].
  ///
  /// A null [string] is treated as an empty String.
  static bool startsWith(String? string, Pattern pattern, [int index = 0]) =>
      (string ?? '').startsWith(pattern, index);

  /// Null-safe [String.substring].
  ///
  /// A null [string] returns spaces of the requested length
  /// (`end - start`, or 1 when [end] is omitted). A non-null [string] behaves
  /// exactly like [String.substring] and can throw a [RangeError].
  static String substring(String? string, int start, [int? end]) {
    if (string == null) {
      return ' ' * ((end ?? start + 1) - start);
    }
    return string.substring(start, end);
  }

  /// Null-safe [String.toLowerCase].
  ///
  /// A null [string] is treated as an empty String.
  static String toLowerCase(String? string) => (string ?? '').toLowerCase();

  /// Null-safe [String.toUpperCase].
  ///
  /// A null [string] is treated as an empty String.
  static String toUpperCase(String? string) => (string ?? '').toUpperCase();

  /// Null-safe [String.trim].
  ///
  /// A null [string] is treated as an empty String.
  static String trim(String? string) => (string ?? '').trim();

  /// Null-safe [String.trimLeft].
  ///
  /// A null [string] is treated as an empty String.
  static String trimLeft(String? string) => (string ?? '').trimLeft();

  /// Null-safe [String.trimRight].
  ///
  /// A null [string] is treated as an empty String.
  static String trimRight(String? string) => (string ?? '').trimRight();

  /// Whether [string] is null or contains only whitespace.
  ///
  /// See [isEmpty] to check for a null or zero length string.
  static bool isBlank(String? string) =>
      string == null || string.trim().isEmpty;

  /// Whether [string] is not null and contains a non-whitespace character.
  ///
  /// See [isNotEmpty] to check for a non-zero length string.
  static bool isNotBlank(String? string) => !isBlank(string);

  /// Returns [string] unless it is blank, otherwise [elseString].
  static String orElse(String? string, String elseString) =>
      isNotBlank(string) ? string! : elseString;

  /// Shortens [string] to [maxWidth] characters, ending it with '...'.
  ///
  /// ```dart
  /// Strings.abbreviate('Hello World', 6); // 'Hel...'
  /// ```
  /// Pass [offset] to abbreviate from that position instead of the start, in
  /// which case the result can also begin with '...'.
  /// If [maxWidth] is less than 4, or [string] already fits, [string] is
  /// returned unchanged. Returns an empty string for null.
  static String abbreviate(String? string, int maxWidth, {int offset = 0}) {
    if (string == null) {
      return '';
    }
    final length = string.length;
    if (length <= maxWidth || maxWidth < 4) {
      return string;
    }
    if (offset > length) {
      offset = length;
    }
    if (length - offset < maxWidth - 3) {
      offset = length - (maxWidth - 3);
    }
    const abbrevMarker = '...';
    if (offset <= 4) {
      return string.substring(0, maxWidth - 3) + abbrevMarker;
    }

    if (offset + maxWidth - 3 < length) {
      return abbrevMarker + abbreviate(string.substring(offset), maxWidth - 3);
    }
    return abbrevMarker + string.substring(length - (maxWidth - 3));
  }

  /// Masks the characters of [string] from [start] up to, not including, [end].
  ///
  /// [start] defaults to 0 and [end] to the end of the string. Positions
  /// count user-perceived characters. Each hidden character is replaced with
  /// [replaceWith], which defaults to '*'. Returns an empty string for null.
  static String hidePart(
    String? string, {
    int start = 0,
    int? end,
    String replaceWith = '*',
  }) {
    if (string == null) {
      return '';
    }
    end ??= string.length;

    final sb = StringBuffer();
    var pos = 0;
    for (final ch in graphemes(string)) {
      sb.write(pos >= start && pos < end ? replaceWith : ch);
      pos++;
    }
    return sb.toString();
  }

  /// Joins the elements of [list] with [separator].
  ///
  /// A null [list] returns an empty String. Null elements are treated as
  /// empty strings but still get a separator. If [excludeEmpty] is true, null
  /// and blank String elements are left out.
  ///
  /// ```dart
  /// Strings.join(null);                  // ''
  /// Strings.join([1, 2]);                // '12'
  /// Strings.join([1, 2], separator: ','); // '1,2'
  /// ```
  static String join(
    List<Object?>? list, {
    String separator = '',
    bool excludeEmpty = false,
  }) {
    if (list == null) {
      return '';
    }

    if (excludeEmpty) {
      return list
          .where(
            (element) =>
                element != null &&
                (element is! String || Strings.isNotBlank(element)),
          )
          .join(separator);
    }
    return list.map((element) => element ?? '').join(separator);
  }

  /// Returns the first [take] characters of [string].
  ///
  /// If [string] is shorter than [take], it is padded with spaces according
  /// to [pad]. A null [string] is treated as an empty String.
  static String left(String? string, int take, {Pad pad = Pad.none}) {
    string ??= '';
    if (string.length >= take) {
      return string.substring(0, take);
    }
    return _pad(string, take - string.length, pad);
  }

  /// Returns the last [take] characters of [string].
  ///
  /// If [string] is shorter than [take], it is padded with spaces according
  /// to [pad]. A null [string] is treated as an empty String.
  static String right(String? string, int take, {Pad pad = Pad.none}) {
    string ??= '';
    final length = string.length;
    if (length >= take) {
      return string.substring(length - take);
    }
    return _pad(string, take - length, pad);
  }

  /// Adds [padLength] spaces to [string] on the side given by [pad].
  static String _pad(String string, int padLength, Pad pad) {
    switch (pad) {
      case Pad.left:
        return "${' ' * padLength}$string";
      case Pad.right:
        return "$string${' ' * padLength}";
      case Pad.none:
        return string;
    }
  }

  /// Returns the text between the first [left] and the last [right].
  ///
  /// Nested delimiters return the outermost content. The result skips only
  /// one character after [left], so [left] is expected to be a single
  /// character. Throws an [ArgumentError] if either delimiter is missing.
  static String within(String string, String left, String right) {
    final leftIndex = string.indexOf(left);
    final rightIndex = string.lastIndexOf(right);

    if (leftIndex == -1) {
      throw ArgumentError('The left bounding character was missing');
    }

    if (rightIndex == -1) {
      throw ArgumentError('The right bounding character was missing');
    }

    return string.substring(leftIndex + 1, rightIndex);
  }

  /// Returns [string] up to, but not including, the first [delimiter].
  ///
  /// If [delimiter] is not found, the whole string is returned.
  static String upTo(String string, String delimiter) {
    final index = string.indexOf(delimiter);
    return string.substring(0, index == -1 ? string.length : index);
  }

  /// Whether [string] is null or has zero length.
  static bool isEmpty(String? string) => string == null || string.isEmpty;

  /// Whether [string] is not null and has a non-zero length.
  static bool isNotEmpty(String? string) => !isEmpty(string);

  /// Returns [string], or the result of [elseValue] if it is null.
  ///
  /// Equivalent to `string ?? elseValue()`.
  static String orElseCall(String? string, String Function() elseValue) =>
      string ?? elseValue();

  /// Returns [string], or an empty String if it is null.
  static String toEmpty(String? string) => string ?? '';

  /// Returns [string] unless it is blank, otherwise [elseString].
  static String orElseOnBlank(String? string, String elseString) =>
      isNotBlank(string) ? string! : elseString;

  /// Whether two nullable strings are equal.
  ///
  /// Returns true when both are null, and false when only one is null.
  static bool equals(String? lhs, String? rhs) => lhs == rhs;

  /// Whether two nullable strings are equal, ignoring case.
  ///
  /// Returns true when both are null, and false when only one is null.
  static bool equalsIgnoreCase(String? lhs, String? rhs) {
    if (lhs == null || rhs == null) {
      return lhs == rhs;
    }
    return lhs.toLowerCase() == rhs.toLowerCase();
  }
}
