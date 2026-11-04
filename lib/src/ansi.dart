library ansi;

import 'dart:io';

import 'package:cmdline/cmdline.dart';

export 'ansi/constants/characters.dart';
export 'ansi/constants/colours.dart';
export 'ansi/constants/colours_16.dart';
export 'ansi/constants/controls.dart';
export 'ansi/constants/cursor.dart';
export 'ansi/constants/screen.dart';
export 'ansi/constants/styling.dart';
export 'ansi/constants/terminal.dart';
export 'ansi/extensions/ascii_styled_string.dart';
export 'ansi/palettes/ascii_colour.dart';
export 'ansi/palettes/ascii_colour_rgb.dart';
export 'ansi/palettes/ascii_ink.dart';
export 'ansi/palettes/ascii_palette.dart';
export 'ansi/utils/ansi_printer.dart';

/// A string with escape codes already in it, waiting to be printed.
///
/// Build the string from the code constants or an [AsciiInk], then call
/// [write], a `print` that closes the style behind itself.
///
/// ```dart
/// Ascii('${CYAN_FG}${BOLD}ready').output();
/// ```
class Ansi {
  /// The text and codes to print, exactly as given.
  ///
  /// [RESET] is not stored here; it is added when the string is produced by
  /// [toString] or [write].
  final String string;

  /// Wraps a string that already carries its escape codes.
  const Ansi(this.string);

  /// Prints [string] closed with [RESET], and hands back what it printed.
  ///
  /// The return is the same string the terminal got, so it can go into a log
  /// or a test as well.
  String write() {
    final line = toString();
    stdout.write(line);

    return line;
  }

  /// [string] with [RESET] appended, so the style stops at the end of it.
  ///
  /// This is what [write] prints, so `'$ascii'` in an interpolation gives the
  /// same safe, closed-off text.
  @override
  String toString() => '$string$RESET';
}
