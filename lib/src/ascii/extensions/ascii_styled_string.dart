import 'package:cmdline/ascii.dart';

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

bool _isParameterByte(int unit) =>
    (unit >= 0x30 && unit <= 0x39) || unit == 0x3A || unit == 0x3B;

extension AsciiStyledString on String {
  String _wrap(String code) {
    final String inner = endsWith(RESET)
        ? substring(0, length - RESET.length)
        : this;
    final int opening = _openingCodesLength(inner);

    return '${inner.substring(0, opening)}$code'
        '${inner.substring(opening)}$RESET';
  }

  String foreground(AsciiInk colour) => _wrap(colour.fg);

  String background(AsciiInk colour) => _wrap(colour.bg);

  String underlineColour(AsciiInk colour) => _wrap(colour.underline);

  String underlineColor(AsciiInk colour) => underlineColour(colour);

  String styled(String code) => _wrap(code);

  String get bold => _wrap(BOLD);

  String get dim => _wrap(DIM);

  String get italic => _wrap(ITALIC);

  String get fraktur => _wrap(FRAKTUR);

  String get underline => _wrap(UNDERLINE);

  String get doublyUnderline => _wrap(DOUBLY_UNDERLINE);

  String get curlyUnderline => _wrap(CURLY_UNDERLINE);

  String get dottedUnderline => _wrap(DOTTED_UNDERLINE);

  String get dashedUnderline => _wrap(DASHED_UNDERLINE);

  String get overline => _wrap(OVERLINE);

  String get blink => _wrap(BLINK);

  String get blinkRapid => _wrap(BLINK_RAPID);

  String get inverse => _wrap(INVERSE);

  String get invisible => _wrap(INVISIBLE);

  String get strikethrough => _wrap(STRIKETHROUGH);

  String get frame => _wrap(FRAME);

  String get encircle => _wrap(ENCIRCLE);

  String get proportionalSpacing => _wrap(PROPORTIONAL_SPACING);

  String get superscript => _wrap(SUPERSCRIPT);

  String get subscript => _wrap(SUBSCRIPT);

  String get ideogramUnderline => _wrap(IDEOGRAM_UNDERLINE);

  String get ideogramDoublyUnderline => _wrap(IDEOGRAM_DOUBLY_UNDERLINE);

  String get ideogramOverline => _wrap(IDEOGRAM_OVERLINE);

  String get ideogramDoublyOverline => _wrap(IDEOGRAM_DOUBLY_OVERLINE);

  String get ideogramStress => _wrap(IDEOGRAM_STRESS);

  String get alternativeFont1 => _wrap(ALTERNATIVE_FONT_1);

  String get alternativeFont2 => _wrap(ALTERNATIVE_FONT_2);

  String get alternativeFont3 => _wrap(ALTERNATIVE_FONT_3);

  String get alternativeFont4 => _wrap(ALTERNATIVE_FONT_4);

  String get alternativeFont5 => _wrap(ALTERNATIVE_FONT_5);

  String get alternativeFont6 => _wrap(ALTERNATIVE_FONT_6);

  String get alternativeFont7 => _wrap(ALTERNATIVE_FONT_7);

  String get alternativeFont8 => _wrap(ALTERNATIVE_FONT_8);

  String get alternativeFont9 => _wrap(ALTERNATIVE_FONT_9);
}
