library ansi;

import 'package:cmdline/cmdline.dart';

export 'constants/characters.dart';
export 'constants/colours.dart';
export 'constants/colours_16.dart';
export 'constants/controls.dart';
export 'constants/cursor.dart';
export 'constants/regular_expressions.dart';
export 'constants/screen.dart';
export 'constants/styling.dart';
export 'constants/terminal.dart';
export 'extensions/ansi_styled_string.dart';
export 'palettes/ansi_colour.dart';
export 'palettes/ansi_colour_rgb.dart';
export 'palettes/ansi_ink.dart';
export 'palettes/ansi_palette.dart';
export 'utils/ansi_printer.dart';

/// A string with escape codes already in it, waiting to be printed.
///
/// Build the string from the code constants or an [AnsiInk], then call
/// [write], a `print` that closes the style behind itself.
///
/// ```dart
/// Ansi('${CYAN_FG}${BOLD}ready').output();
/// ```
class Ansi implements Comparable<Ansi> {
  /// The text and codes to print, exactly as given.
  ///
  /// [RESET] is not stored here; it is added when the string is produced by
  /// [toString] or [write].
  final String string;

  /// Wraps a string that already carries its escape codes.
  const Ansi(this.string);

  /// Removes every ANSI escape sequence from [string], leaving plain text.
  String text() {
    return string
        .replaceAll(styleCodeRegExp, '')
        .replaceAll(controlCodeRegExp, '');
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    if (other is Ansi &&
        other.runtimeType == runtimeType &&
        other.string == string) {
      return true;
    } else {
      return false;
    }
  }

  @override
  int compareTo(Ansi other) => text().compareTo(other.text());

  @override
  String toString() => string;
}

// String toPrintable(String string) {
//   if (string.isEmpty) {
//     return '';
//   }
//   final characters = string.toList();
//
//   for (final s in characters) {
//     final runes = s.runes;
//     if (runes.length == 1) {
//       final c = runes.first;
//       if (c >= c0Start && c <= c0End) {
//         switch (c) {
//           case 9:
//             sb.write(r'\t');
//           case 10:
//             sb.write(r'\n');
//           case 13:
//             sb.write(r'\r');
//           default:
//             sb.write(Strings.toUnicode(c));
//         }
//       } else if (isPrintable(c)) {
//         sb.write(s);
//       } else {
//         sb.write(Strings.toUnicode(c));
//       }
//     } else {
//       // Experimental: Assumes that all clusters can be printed
//       sb.write(s);
//     }
//   }
//
//   return sb.toString();
// }
