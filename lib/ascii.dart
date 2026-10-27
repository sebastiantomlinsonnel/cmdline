library;

import 'ascii.dart';

export 'src/ascii/ascii.dart';
export 'src/ascii/extensions/ascii_styled_string.dart';
export 'src/ascii/palettes/ascii_colour.dart';
export 'src/ascii/palettes/ascii_colour_rgb.dart';
export 'src/ascii/palettes/ascii_ink.dart';
export 'src/ascii/utils/ascii_printer.dart';

/// A string with escape codes already in it, waiting to be printed.
///
/// Mostly a namespace: [Ascii.colour] and [Ascii.format] are the palettes, and
/// [output] is a `print` that closes the style behind itself.
///
/// ```dart
/// Ascii('${Ascii.colour.cyan.fg}${Ascii.format.bold}ready').output();
/// ```
class Ascii {
  /// The text and codes to print, as given. [reset] is appended when the
  /// string is produced, not here.
  final String string;

  /// Wraps a string that already carries its escape codes.
  const Ascii(this.string);

  /// Prints [string] closed with [reset], and hands back what it printed.
  ///
  /// The return is the same string the terminal got, so it can go into a log
  /// or a test as well.
  String output() {
    final line = toString();
    // ignore: avoid_print
    print(line);

    return line;
  }

  /// [string] with [reset] appended, so the style stops at the end of it.
  @override
  String toString() => '$string$RESET';
}
