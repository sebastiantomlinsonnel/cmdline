/// ANSI and other control characters
library ansi;

import 'dart:convert';

import 'package:cmdline/cmdline.dart';

export 'src/ansi/constants/characters.dart';
export 'src/ansi/constants/colours.dart';
export 'src/ansi/constants/colours_16.dart';
export 'src/ansi/constants/controls.dart';
export 'src/ansi/constants/cursor.dart';
export 'src/ansi/constants/regular_expressions.dart';
export 'src/ansi/constants/screen.dart';
export 'src/ansi/constants/styling.dart';
export 'src/ansi/constants/terminal.dart';
export 'src/ansi/palettes/ansi_colour.dart';
export 'src/ansi/palettes/ansi_colour_rgb.dart';
export 'src/ansi/palettes/ansi_ink.dart';
export 'src/ansi/palettes/ansi_palette.dart';
export 'src/ansi/palettes/ansi_theme.dart';
export 'src/ansi/utils/ansi_printer.dart';

/// A string with escape codes already in it, waiting to be printed.
///
/// Build the string from the code constants or an [AnsiInk], then call
/// [write], a `print` that closes the style behind itself.
///
/// ```dart
/// Ansi('${CYAN_FG}${BOLD}ready').output();
/// ```
class Ansi {
  @override
  String toString() => '$string';

  /// The text and codes to print, exactly as given.
  ///
  /// [RESET] is not stored here; it is added when the string is produced by
  /// [toString] or [write].
  final String string;

  /// Wraps a string that already carries its escape codes.
  const Ansi(this.string);

  /// Shows the code names
  String get printCharcodes {
    final List<int> codeUnits = string.codeUnits.toList();
    // fail(utf8.decode(codeUnits));
    for (final int byte in codeUnits) {
      debug(utf8.decode([byte], allowMalformed: true));
    }
    return string.replaceAll(ESC, '\\${ESC.codeUnits}');
  }

  /// Show escape codes
  ///
  /// Handy for checking which codes a string really holds. Each escape
  /// character is shown as `ESC` and each bell as `BELL`.
  ///
  /// ```dart
  /// print('Hi'.bold.escaped); // ESC[1mHiESC[0m
  /// ```
  String get visible => string.replaceAll(CSI, 'ESC[').replaceAll(OSC, 'ESC]');

  /// The text with every escape code removed, just as you see it.
  ///
  /// Use it to save styled text to a file, measure its real length, or
  /// compare it with other text.
  ///
  /// ```dart
  /// 'Done'.bold.foreground(const AnsiColour(10)).plain; // 'Done'
  /// ```
  String get plain {
    final result = StringBuffer();
    int at = 0;

    while (at < string.length) {
      // Normal text is kept as it is.
      if (!string.startsWith(ESC, at)) {
        result.write(string[at]);
        at++;
        continue;
      }

      if (string.startsWith(CSI, at)) {
        // Styles, cursor moves and so on: ESC [ ... then one letter.
        at += CSI.length;
        while (at < string.length) {
          at++;
        }
        at++; // Skip the final letter too.
      } else if (string.startsWith(OSC, at)) {
        // Links, window titles and so on: ESC ] ... then BELL or ST.
        at += OSC.length;
        while (at < string.length &&
            !string.startsWith(BELL, at) &&
            !string.startsWith(ST, at)) {
          at++;
        }
        at += string.startsWith(ST, at) ? ST.length : BELL.length;
      } else {
        // Any other code: ESC and the one character after it.
        at += 2;
      }
    }

    return result.toString();
  }
}
