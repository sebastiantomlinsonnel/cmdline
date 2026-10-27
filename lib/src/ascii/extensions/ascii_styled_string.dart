import 'package:cmdline/ascii.dart';

/// How much of [text] is the run of codes a chain has already put at its
/// front, so the next one can be slid in behind them rather than ahead of
/// them.
///
/// Counts whole `CSI`…`SGR` sequences and stops at the first thing that is not
/// one, which is where the text itself begins.
int _openingCodesLength(String text) {
  int at = 0;

  while (text.startsWith(CSI, at)) {
    int scan = at + CSI.length;
    while (scan < text.length && _isParameterByte(text.codeUnitAt(scan))) {
      scan++;
    }
    if (!text.startsWith(SGR, scan)) break;
    at = scan + SGR.length;
  }

  return at;
}

/// Whether [unit] is one of the bytes a colour or style code is spelled with —
/// a digit, a `;` or a `:`.
bool _isParameterByte(int unit) =>
    (unit >= 0x30 && unit <= 0x39) || unit == 0x3A || unit == 0x3B;

/// Styling a string by chaining onto it, instead of gluing codes around it by
/// hand.
///
/// ```dart
/// print(
///   'ready'
///       .foreground(const AsciiColour.rgb(5, 2, 0)) // the 6x6x6 cube
///       .background(const AsciiColourRgb(0x33, 0x66, 0x99)) // 24-bit
///       .underlineColour(const AsciiColour.gray(12)) // one of the 24 greys
///       .underline,
/// );
/// ```
///
/// Each link adds its code to the run in front of the string and closes the
/// whole with [reset] — and because it only adds that [reset] when the string
/// does not already end in one, a chain of any length still ends with exactly
/// one.
///
/// Codes come out in the order they were chained, which is the order a
/// terminal is likeliest to honour. Most read them as flags and would not care,
/// but the ones that resolve a style the moment it arrives do: a terminal that
/// implements [dim] by mixing the foreground into the background computes that
/// mix when it sees the code, so a colour arriving afterwards replaces the
/// result and the text comes out at full strength. Chain the colour first and
/// the dim last, as the sentence reads.
///
/// What the trailing [reset] also means is that a styled string is finished.
/// Chaining onto `'a'.bold + 'b'` styles nothing further — the [reset] from
/// `.bold` sits in the middle, and `.foreground` would wrap both halves and
/// paint only up to it. Style each piece, then join.
extension AsciiStyledString on String {
  /// Slides [code] in after any codes already at the front, and closes with a
  /// single [reset].
  String _wrap(String code) {
    final String inner = endsWith(reset)
        ? substring(0, length - reset.length)
        : this;
    final int opening = _openingCodesLength(inner);

    return '${inner.substring(0, opening)}$code'
        '${inner.substring(opening)}$reset';
  }

  /// Paints the text, from either colour table.
  ///
  /// ```dart
  /// 'warning'.foreground(colours.high_yellow);
  /// 'warning'.foreground(const AsciiColourRgb.hex(0xFFCC00));
  /// ```
  String foreground(AsciiInk colour) => _wrap(colour.fg);

  /// Paints the background behind the text.
  String background(AsciiInk colour) => _wrap(colour.bg);

  /// Paints the underline, leaving the text its own colour.
  ///
  /// Draws nothing on its own — chain [underline] (or one of the other
  /// underline shapes) as well, in either order.
  String underlineColour(AsciiInk colour) => _wrap(colour.underline);

  /// [underlineColour] under the other spelling.
  String underlineColor(AsciiInk colour) => underlineColour(colour);

  /// Opens with a code this extension has no name for, for anything
  /// hand-rolled out of [CSI] and [SGR].
  ///
  /// ```dart
  /// 'sideways'.styled('${CSI}73$SGR');
  /// ```
  String styled(String code) => _wrap(code);

  /// Bold, or increased intensity — [BOLD].
  String get bold => _wrap(BOLD);

  /// Dim, or decreased intensity — [DIM].
  ///
  /// The least dependable code in the set. Plenty of terminals ignore it, and
  /// several of the ones that honour it do so only where the text is left the
  /// default colour. Where it does nothing, reach for a darker colour instead
  /// — [AsciiInk.opacity] mixes one for you.
  String get dim => _wrap(DIM);

  /// Italic — [ITALIC].
  String get italic => _wrap(ITALIC);

  /// Fraktur (Gothic) — [FRAKTUR]. Honoured by very little.
  String get fraktur => _wrap(FRAKTUR);

  /// Underline — [UNDERLINE].
  String get underline => _wrap(UNDERLINE);

  /// Double underline — [DOUBLY_UNDERLINE].
  String get doublyUnderline => _wrap(DOUBLY_UNDERLINE);

  /// Curly (wavy) underline — [CURLY_UNDERLINE].
  String get curlyUnderline => _wrap(CURLY_UNDERLINE);

  /// Dotted underline — [DOTTED_UNDERLINE].
  String get dottedUnderline => _wrap(DOTTED_UNDERLINE);

  /// Dashed underline — [DASHED_UNDERLINE].
  String get dashedUnderline => _wrap(DASHED_UNDERLINE);

  /// A line above the text — [OVERLINE].
  String get overline => _wrap(OVERLINE);

  /// Blink, under 150 per minute — [BLINK].
  String get blink => _wrap(BLINK);

  /// Blink, 150 per minute or more — [BLINK_RAPID].
  String get blinkRapid => _wrap(BLINK_RAPID);

  /// Swaps foreground and background — [INVERSE].
  String get inverse => _wrap(INVERSE);

  /// Hides the text, which is still there to select and copy — [INVISIBLE].
  String get invisible => _wrap(INVISIBLE);

  /// Strikethrough — [STRIKETHROUGH].
  String get strikethrough => _wrap(STRIKETHROUGH);

  /// Draws a frame around the text — [FRAME].
  String get frame => _wrap(FRAME);

  /// Draws a circle around the text — [ENCIRCLE].
  String get encircle => _wrap(ENCIRCLE);

  /// Proportional spacing — [PROPORTIONAL_SPACING].
  String get proportionalSpacing => _wrap(PROPORTIONAL_SPACING);

  /// Superscript — [SUPERSCRIPT].
  String get superscript => _wrap(SUPERSCRIPT);

  /// Subscript — [SUBSCRIPT].
  String get subscript => _wrap(SUBSCRIPT);

  /// Ideogram underline, or a line down the right side —
  /// [IDEOGRAM_UNDERLINE].
  String get ideogramUnderline => _wrap(IDEOGRAM_UNDERLINE);

  /// Ideogram double underline — [IDEOGRAM_DOUBLY_UNDERLINE].
  String get ideogramDoublyUnderline => _wrap(IDEOGRAM_DOUBLY_UNDERLINE);

  /// Ideogram overline, or a line down the left side — [IDEOGRAM_OVERLINE].
  String get ideogramOverline => _wrap(IDEOGRAM_OVERLINE);

  /// Ideogram double overline — [IDEOGRAM_DOUBLY_OVERLINE].
  String get ideogramDoublyOverline => _wrap(IDEOGRAM_DOUBLY_OVERLINE);

  /// Ideogram stress marking — [IDEOGRAM_STRESS].
  String get ideogramStress => _wrap(IDEOGRAM_STRESS);

  /// First alternative font — [ALTERNATIVE_FONT_1].
  String get alternativeFont1 => _wrap(ALTERNATIVE_FONT_1);

  /// Second alternative font — [ALTERNATIVE_FONT_2].
  String get alternativeFont2 => _wrap(ALTERNATIVE_FONT_2);

  /// Third alternative font — [ALTERNATIVE_FONT_3].
  String get alternativeFont3 => _wrap(ALTERNATIVE_FONT_3);

  /// Fourth alternative font — [ALTERNATIVE_FONT_4].
  String get alternativeFont4 => _wrap(ALTERNATIVE_FONT_4);

  /// Fifth alternative font — [ALTERNATIVE_FONT_5].
  String get alternativeFont5 => _wrap(ALTERNATIVE_FONT_5);

  /// Sixth alternative font — [ALTERNATIVE_FONT_6].
  String get alternativeFont6 => _wrap(ALTERNATIVE_FONT_6);

  /// Seventh alternative font — [ALTERNATIVE_FONT_7].
  String get alternativeFont7 => _wrap(ALTERNATIVE_FONT_7);

  /// Eighth alternative font — [ALTERNATIVE_FONT_8].
  String get alternativeFont8 => _wrap(ALTERNATIVE_FONT_8);

  /// Ninth alternative font — [ALTERNATIVE_FONT_9].
  String get alternativeFont9 => _wrap(ALTERNATIVE_FONT_9);
}
