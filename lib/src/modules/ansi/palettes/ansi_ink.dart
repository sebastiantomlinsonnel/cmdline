import 'package:cmdline/cmdline.dart';

/// A colour that can be turned into terminal escape codes.
///
/// The base type for [AnsiColour] (the 256-colour palette) and
/// [AnsiColourRgb] (24-bit true colour). Subclasses supply [parameters] and
/// [toRgb]; this class builds the text, background and underline codes from
/// them and can blend colours with [opacity].
///
/// ```dart
/// const AnsiInk ink = AnsiColour(208);
/// print('${ink.fg}orange text$RESET');
/// ```
///
/// {@category ansi}
abstract class AnsiInk {
  /// Lets subclasses be `const`.
  const AnsiInk();

  /// The colour part of an SGR code, without the leading `38;` / `48;` / `58;`.
  ///
  /// `5;<index>` for a palette colour, or `2;<r>;<g>;<b>` for true colour.
  /// [fg], [bg] and [underline] wrap it into a full escape code.
  String get parameters;

  /// Escape code that sets the text colour to this colour.
  ///
  /// `CSI 38;<parameters> m`. Undo it with [RESET_FG] or [RESET].
  String get fg => '${CSI}38;$parameters$SGR';

  /// Escape code that sets the background colour to this colour.
  ///
  /// `CSI 48;<parameters> m`. Undo it with [RESET_BG] or [RESET].
  String get bg => '${CSI}48;$parameters$SGR';

  /// Escape code that sets the underline colour to this colour.
  ///
  /// `CSI 58;<parameters> m`. Only visible while an underline style such as
  /// [UNDERLINE] is on, and not every terminal supports it. Undo it with
  /// [RESET_UNDERLINE_COLOUR] or [RESET].
  String get underline => '${CSI}58;$parameters$SGR';

  /// This colour as exact red, green and blue values.
  ///
  /// Palette colours are converted with the standard xterm values. Colours
  /// 0 to 15 use typical defaults, but the real terminal theme may differ.
  AnsiColourRgb toRgb();

  /// Blends this colour over another one, like drawing it semi-transparent.
  ///
  /// [amount] goes from 0 (only [over] shows) to 1 (only this colour shows);
  /// values outside 0 to 1 fail an assert. [over] defaults to black. Both
  /// colours are converted with [toRgb] first, so the result is always an
  /// [AnsiColourRgb].
  ///
  /// ```dart
  /// // Half-strength red on a white background.
  /// final pink = const AnsiColour(9).opacity(
  ///   0.5,
  ///   over: const AnsiColourRgb(255, 255, 255),
  /// );
  /// ```
  AnsiColourRgb opacity(
    double amount, {
    AnsiInk over = const AnsiColourRgb(0, 0, 0),
  }) {
    assert(amount >= 0 && amount <= 1, 'amount must be 0-1');

    final AnsiColourRgb front = toRgb();
    final AnsiColourRgb back = over.toRgb();
    int mix(int f, int b) => ((f * amount) + (b * (1 - amount))).round();

    return AnsiColourRgb(
      mix(front.red, back.red),
      mix(front.green, back.green),
      mix(front.blue, back.blue),
    );
  }
}
