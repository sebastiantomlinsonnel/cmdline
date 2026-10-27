import 'package:cmdline/ascii.dart';

/// A colour the terminal can paint with, however it was named.
///
/// The two ways of naming one — a slot in the 256-colour table
/// ([AsciiColour]) and a 24-bit triple ([AsciiColourRgb]) — differ only in the
/// middle of the code. `CSI 38 ;` and `SGR` sit around it either way, so that
/// middle is all a subclass has to supply.
///
/// An ink is not a printable code by itself: pick [fg], [bg] or [underline]
/// and you get the string to print.
abstract class AsciiInk {
  const AsciiInk();

  /// The colour half of the code, between the `38`/`48`/`58` and the `m`.
  ///
  /// `5;<index>` for the 256-colour table, `2;<r>;<g>;<b>` for 24-bit.
  String get parameters;

  /// Paints the text this colour. Cleared by [RESET_FG] or by [reset].
  String get fg => '${CSI}38;$parameters$SGR';

  /// Paints the background behind the text. Cleared by [RESET_BG] or by
  /// [reset].
  String get bg => '${CSI}48;$parameters$SGR';

  /// Paints the underline this colour, leaving the text its own colour.
  ///
  /// Only shows where an underline is already on — see
  /// [AsciiFormats.underline], or the [AsciiStyledString.underline] getter if
  /// you are chaining onto a string. Cleared by [RESET_UNDERLINE_COLOUR] or by
  /// [reset].
  String get underline => '${CSI}58;$parameters$SGR';

  /// This colour as three channels, so two of them can be mixed.
  AsciiColourRgb toRgb();

  /// This colour at [amount] strength over [over] — the fade ANSI has no code
  /// for, worked out in advance.
  ///
  /// A colour code carries three channels and no alpha, so nothing in the
  /// escape sequence can ask for half-strength text.
  /// [AsciiStyledString.dim] is the only code that gestures at it and most
  /// terminals ignore it. Mixing the two colours here gives the same look and
  /// always renders — the price is that you have to name the background being
  /// mixed into, because nothing can ask the terminal what its background
  /// really is.
  ///
  /// ```dart
  /// // a red that has faded halfway into a near-black terminal
  /// '09'.foreground(const AsciiColour.rgb(5, 0, 0).opacity(0.5));
  ///
  /// // over something else
  /// 'watermark'.foreground(
  ///   colours.high_white.opacity(0.15, over: const AsciiColourRgb.hex(0x1E1E1E)),
  /// );
  /// ```
  ///
  /// `1` is the colour untouched and `0` is the background, which paints
  /// text that is there but invisible. The result is 24-bit, so a terminal
  /// stuck on the 256-colour table will approximate it or drop it.
  AsciiColourRgb opacity(
    double amount, {
    AsciiInk over = const AsciiColourRgb(0, 0, 0),
  }) {
    assert(amount >= 0 && amount <= 1, 'amount must be 0-1');

    final AsciiColourRgb front = toRgb();
    final AsciiColourRgb back = over.toRgb();
    int mix(int f, int b) => ((f * amount) + (b * (1 - amount))).round();

    return AsciiColourRgb(
      mix(front.red, back.red),
      mix(front.green, back.green),
      mix(front.blue, back.blue),
    );
  }
}
