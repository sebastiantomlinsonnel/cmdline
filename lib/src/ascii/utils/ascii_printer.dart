import 'package:cmdline/ascii.dart';

/// Glues codes and text into one string and closes it with [reset], so a style
/// cannot bleed into whatever gets printed next.
///
/// The static [value] is the whole of it for most uses:
///
/// ```dart
/// print(AsciiPrinter.value([colours.red.fg, formats.bold, 'careful']));
/// ```
///
/// Calls nest, because each one hands back a plain string:
///
/// ```dart
/// AsciiPrinter.value([
///   AsciiPrinter.value([colours.red.fg, 'What a ']),
///   AsciiPrinter.value([formats.bold, colours.high_white.bg, 'crazy']),
///   AsciiPrinter.value([colours.red.fg, ' thing to say']),
/// ]);
/// ```
///
/// Note what that costs: the inner [reset] closes *everything*, so each piece
/// has to open the styles it wants for itself — the red on the third line is
/// not inherited from the first, it is set again.
class AsciiPrinter {
  /// The codes and text to glue together, in the order they should appear.
  final List<Object?> tokens;

  /// Placed between tokens. Empty by default, so codes sit flush against the
  /// text they style; `' '` is the other useful value.
  final String separator;

  /// Holds [tokens] until something asks for the string.
  const AsciiPrinter(this.tokens, {this.separator = ''});

  /// Joins [tokens] and closes with [reset], in one call and without an
  /// instance.
  static String value(List<Object?> tokens, {String separator = ''}) =>
      '${tokens.join(separator)}$RESET';

  /// Prints the joined string and hands back the same string.
  String output() {
    final string = toString();
    // ignore: avoid_print
    print(string);

    return string;
  }

  /// The joined string, closed with [reset].
  ///
  /// Interpolating an [AsciiPrinter] goes through here, so it can be dropped
  /// straight into another string.
  @override
  String toString() => value(tokens, separator: separator);
}
