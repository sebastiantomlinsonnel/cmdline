/// Terminal colours and text styles using ANSI escape codes.
///
/// Import this one file to get everything:
/// * the raw codes, such as [RESET], [BOLD], [RED_FG] and the 256-colour table;
/// * colour objects: [AsciiColour] (256 colours) and [AsciiColourRgb]
///   (true colour), both [AsciiInk]s;
/// * the [AsciiStyledString] extension, e.g. `'hi'.bold.underline`;
/// * printing helpers: [Ascii], [AsciiPrinter], [sty] and [multisty].
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
/// Build the string from the code constants or an [AsciiInk], then call
/// [output], a `print` that closes the style behind itself.
///
/// ```dart
/// Ascii('${CYAN_FG}${BOLD}ready').output();
/// ```
class Ascii {
  /// The text and codes to print, exactly as given.
  ///
  /// [RESET] is not stored here; it is added when the string is produced by
  /// [toString] or [output].
  final String string;

  /// Wraps a string that already carries its escape codes.
  const Ascii(this.string);

  /// Prints [string] closed with [RESET], and hands back what it printed.
  ///
  /// The return is the same string the terminal got, so it can go into a log
  /// or a test as well.
  String output() {
    final line = toString();
    // ignore: avoid_print
    print(line);

    return line;
  }

  /// [string] with [RESET] appended, so the style stops at the end of it.
  ///
  /// This is what [output] prints, so `'$ascii'` in an interpolation gives the
  /// same safe, closed-off text.
  @override
  String toString() => '$string$RESET';
}
