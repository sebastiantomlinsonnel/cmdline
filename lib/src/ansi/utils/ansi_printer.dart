import 'dart:io';

import 'package:cmdline/cmdline.dart';

/// Builds one line from codes and values, and prints it with a final [RESET].
///
/// [tokens] can mix escape codes, [AnsiInk] codes and any other value; each
/// is turned into text with `toString()`. Unlike [sty] there is no leading
/// [RESET], so styles already active in the terminal carry in.
///
/// ```dart
/// AnsiPrinter([BOLD, 'Total:', RESET_BOLD_AND_DIM, 42], separator: ' ')
///     .output();
/// ```
class AnsiPrinter {
  /// The pieces to print, in order.
  ///
  /// `null` items print as `null`, the same as [List.join].
  final List<Object?> tokens;

  /// Text placed between every pair of [tokens].
  ///
  /// Empty by default. It goes between escape codes too, so a separator of
  /// `' '` also adds a space after a code that comes before some text.
  final String separator;

  /// Stores [tokens] and [separator] for printing later.
  ///
  /// Nothing is printed until [output] is called.
  const AnsiPrinter(this.tokens, {this.separator = ''});

  /// Joins [tokens] with [separator] and adds [RESET], without printing.
  ///
  /// Static so it can be used without creating an [AnsiPrinter], e.g. to
  /// build a string for a log or a test.
  static String value(List<Object?> tokens, {String separator = ''}) =>
      '${tokens.join(separator)}$RESET';

  /// Prints the line and returns what was printed.
  ///
  /// Uses `print`, so the output ends with a line break. The returned string
  /// is the same as [toString].
  String output() {
    final string = toString();
    stdout.writeln(string);

    return string;
  }

  /// The joined line with [RESET] at the end, exactly as [output] prints it.
  ///
  /// Same as calling [value] with this printer's [tokens] and [separator].
  @override
  String toString() => value(tokens, separator: separator);
}
