import 'dart:io';

import 'package:cmdline/cmdline.dart';

void main() {}

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
