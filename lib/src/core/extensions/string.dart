import 'dart:convert';
import 'dart:typed_data';

import 'package:cmdline/cmdline.dart';

/// Extensions for working with Strings
extension StringsExtension on String {
  /// Puts [code] after this string's leading style codes and ends with [RESET].
  ///
  /// A trailing [RESET] from an earlier call is removed first, so chaining
  /// never leaves a reset in the middle of the text.
  String _wrap(String code) {
    final String inner = endsWith(RESET)
        ? substring(0, length - RESET.length)
        : this;
    final int opening = _openingCodesLength(inner);

    return '${inner.substring(0, opening)}$code'
        '${inner.substring(opening)}$RESET';
  }

  /// Sets the text colour.
  ///
  /// Works with any [AnsiInk]: a palette [AnsiColour] or a true-colour
  /// [AnsiColourRgb]. Uses [AnsiInk.fg].
  String foreground(AnsiInk colour) => _wrap(colour.fg);

  /// Sets the background colour.
  ///
  /// Works with any [AnsiInk]. Uses [AnsiInk.bg].
  String background(AnsiInk colour) => _wrap(colour.bg);

  /// Sets the underline colour.
  ///
  /// Only visible together with an underline style such as [underline] or
  /// [curlyUnderline]. Uses [AnsiInk.underline].
  String underlineColour(AnsiInk colour) => _wrap(colour.underline);

  /// American spelling of [underlineColour].
  ///
  /// Does exactly the same thing.
  String underlineColor(AnsiInk colour) => underlineColour(colour);

  /// Makes this text a clickable link that opens [url].
  ///
  /// Uses [hyperlink]. Terminals without link support just show the text.
  /// Add styles before the link, e.g. `'docs'.underline.link(url)`.
  String link(String url) => hyperlink(url, this);

  /// Applies any escape code you pass in.
  ///
  /// For codes without their own getter, or ones you build yourself, e.g.
  /// `'x'.styled('${FGCO}208$SGR')`. [code] should be a complete style
  /// sequence ending in [SGR].
  String styled(String code) => _wrap(code);

  /// The text with every escape code removed, just as you see it.
  ///
  /// Use it to save styled text to a file, measure its real length, or
  /// compare it with other text.
  ///
  /// ```dart
  /// 'Done'.bold.foreground(const AnsiColour(10)).plain; // 'Done'
  /// ```
  String get plain => Ansi(this).plain;

  /// Makes the text bold (or brighter, depending on the terminal).
  ///
  /// Uses [BOLD].
  String get bold => _wrap(BOLD);

  /// Makes the text dim (faint).
  ///
  /// Uses [DIM].
  String get dim => _wrap(DIM);

  /// Makes the text italic.
  ///
  /// Uses [ITALIC].
  String get italic => _wrap(ITALIC);

  /// Shows the text in a blackletter (Fraktur) font.
  ///
  /// Uses [FRAKTUR]. Almost no terminals support it.
  String get fraktur => _wrap(FRAKTUR);

  /// Underlines the text with a single line.
  ///
  /// Uses [UNDERLINE]. Colour the line with [underlineColour].
  String get underline => _wrap(UNDERLINE);

  /// Underlines the text with a double line.
  ///
  /// Uses [DOUBLY_UNDERLINE]. Some older terminals read this as "bold off".
  String get doublyUnderline => _wrap(DOUBLY_UNDERLINE);

  /// Underlines the text with a wavy line.
  ///
  /// Uses [CURLY_UNDERLINE]. Supported by kitty, WezTerm, VTE-based terminals
  /// and some others.
  String get curlyUnderline => _wrap(CURLY_UNDERLINE);

  /// Underlines the text with a dotted line.
  ///
  /// Uses [DOTTED_UNDERLINE]. Same support as [curlyUnderline].
  String get dottedUnderline => _wrap(DOTTED_UNDERLINE);

  /// Underlines the text with a dashed line.
  ///
  /// Uses [DASHED_UNDERLINE]. Same support as [curlyUnderline].
  String get dashedUnderline => _wrap(DASHED_UNDERLINE);

  /// Draws a line above the text.
  ///
  /// Uses [OVERLINE].
  String get overline => _wrap(OVERLINE);

  /// Makes the text blink slowly.
  ///
  /// Uses [BLINK]. Many terminals ignore it or let users disable it.
  String get blink => _wrap(BLINK);

  /// Makes the text blink quickly.
  ///
  /// Uses [BLINK_RAPID]. Rarely supported; often looks the same as [blink].
  String get blinkRapid => _wrap(BLINK_RAPID);

  /// Swaps the text and background colours.
  ///
  /// Uses [INVERSE].
  String get inverse => _wrap(INVERSE);

  /// Hides the text but keeps its space.
  ///
  /// Uses [INVISIBLE]. The text can still be selected and copied.
  String get invisible => _wrap(INVISIBLE);

  /// Draws a line through the text.
  ///
  /// Uses [STRIKETHROUGH].
  String get strikethrough => _wrap(STRIKETHROUGH);

  /// Draws a box around the text.
  ///
  /// Uses [FRAME]. Almost no terminals support it.
  String get frame => _wrap(FRAME);

  /// Draws a circle around the text.
  ///
  /// Uses [ENCIRCLE]. Almost no terminals support it.
  String get encircle => _wrap(ENCIRCLE);

  /// Turns on proportional spacing.
  ///
  /// Uses [PROPORTIONAL_SPACING]. Almost no terminals support it.
  String get proportionalSpacing => _wrap(PROPORTIONAL_SPACING);

  /// Shows the text as superscript.
  ///
  /// Uses [SUPERSCRIPT]. Supported by mintty and few others.
  String get superscript => _wrap(SUPERSCRIPT);

  /// Shows the text as subscript.
  ///
  /// Uses [SUBSCRIPT]. Supported by mintty and few others.
  String get subscript => _wrap(SUBSCRIPT);

  /// Ideogram underline (or right-side line).
  ///
  /// Uses [IDEOGRAM_UNDERLINE]. Meant for CJK layout; rarely supported.
  String get ideogramUnderline => _wrap(IDEOGRAM_UNDERLINE);

  /// Ideogram double underline (or double right-side line).
  ///
  /// Uses [IDEOGRAM_DOUBLY_UNDERLINE]. Rarely supported.
  String get ideogramDoublyUnderline => _wrap(IDEOGRAM_DOUBLY_UNDERLINE);

  /// Ideogram overline (or left-side line).
  ///
  /// Uses [IDEOGRAM_OVERLINE]. Rarely supported.
  String get ideogramOverline => _wrap(IDEOGRAM_OVERLINE);

  /// Ideogram double overline (or double left-side line).
  ///
  /// Uses [IDEOGRAM_DOUBLY_OVERLINE]. Rarely supported.
  String get ideogramDoublyOverline => _wrap(IDEOGRAM_DOUBLY_OVERLINE);

  /// Ideogram stress marking.
  ///
  /// Uses [IDEOGRAM_STRESS]. Rarely supported.
  String get ideogramStress => _wrap(IDEOGRAM_STRESS);

  /// Shows the text in alternative font 1.
  ///
  /// Uses [ALTERNATIVE_FONT_1]. Most terminals ignore alternative fonts.
  String get alternativeFont1 => _wrap(ALTERNATIVE_FONT_1);

  /// Shows the text in alternative font 2.
  ///
  /// Uses [ALTERNATIVE_FONT_2]. Most terminals ignore alternative fonts.
  String get alternativeFont2 => _wrap(ALTERNATIVE_FONT_2);

  /// Shows the text in alternative font 3.
  ///
  /// Uses [ALTERNATIVE_FONT_3]. Most terminals ignore alternative fonts.
  String get alternativeFont3 => _wrap(ALTERNATIVE_FONT_3);

  /// Shows the text in alternative font 4.
  ///
  /// Uses [ALTERNATIVE_FONT_4]. Most terminals ignore alternative fonts.
  String get alternativeFont4 => _wrap(ALTERNATIVE_FONT_4);

  /// Shows the text in alternative font 5.
  ///
  /// Uses [ALTERNATIVE_FONT_5]. Most terminals ignore alternative fonts.
  String get alternativeFont5 => _wrap(ALTERNATIVE_FONT_5);

  /// Shows the text in alternative font 6.
  ///
  /// Uses [ALTERNATIVE_FONT_6]. Most terminals ignore alternative fonts.
  String get alternativeFont6 => _wrap(ALTERNATIVE_FONT_6);

  /// Shows the text in alternative font 7.
  ///
  /// Uses [ALTERNATIVE_FONT_7]. Most terminals ignore alternative fonts.
  String get alternativeFont7 => _wrap(ALTERNATIVE_FONT_7);

  /// Shows the text in alternative font 8.
  ///
  /// Uses [ALTERNATIVE_FONT_8]. Most terminals ignore alternative fonts.
  String get alternativeFont8 => _wrap(ALTERNATIVE_FONT_8);

  /// Shows the text in alternative font 9.
  ///
  /// Uses [ALTERNATIVE_FONT_9]. Most terminals ignore alternative fonts.
  String get alternativeFont9 => _wrap(ALTERNATIVE_FONT_9);

  /// A list of every character
  List<String> get characters => this.split('');

  /// Get a list of every word
  List<String> get words => this.split(' ');

  /// Splits text into lines
  List<String> get lines => const LineSplitter().convert(this);

  /// Gets the character at [index]
  String getChar(int index) => characters.elementAt(index);

  /// Encode as utf8
  Uint8List get utf8Encode => utf8.encode(this);

  /// Whether the string parses as a number.
  ///
  /// Parsing uses [double.tryParse]. `Infinity` and `NaN` are not treated as
  /// numbers. Returns false for null.
  bool isNumeric() {
    if (this == double.infinity.toString() || this == double.nan.toString()) {
      return false;
    }
    return double.tryParse(this) != null;
  }

  /// Whether the string only contains ASCII characters.
  ///
  /// Returns false for null and true for an empty string.
  bool isAscii() {
    for (final s in graphemes(this)) {
      final runes = s.runes;
      if (runes.length != 1) {
        return false;
      }
      final c = runes.first;
      if (c < 0 || c > DEL) {
        return false;
      }
    }
    return true;
  }

  /// Whether this string only contains the digits 0-9.
  ///
  /// Returns false for null and true for an empty string.
  bool isDigits() {
    for (var i = 0; i < this.length; i++) {
      if (!'0123456789'.contains(this[i])) {
        return false;
      }
    }
    return true;
  }

  /// Whether this string contains no upper case letters.
  ///
  /// Returns true for null and for an empty string. A non-ASCII character
  /// counts as upper case when it equals its own [String.toUpperCase], so
  /// caseless characters such as CJK make this return false.
  bool isLowerCase() {
    if (this.isEmpty) return true;

    for (final s in graphemes(this)) {
      final runes = s.runes;
      if (runes.length == 1) {
        final c = runes.first;
        if (c <= DEL) {
          if (asciiFlags(c) & UPPER_MASK != 0) {
            return false;
          }
        } else if (s == s.toUpperCase()) {
          return false;
        }
      }
    }

    return true;
  }

  /// Whether [character] is visible when printed to the console.
  ///
  /// Control, format, separator, unassigned, private use and surrogate code
  /// points are not printable. Returns false for null and for values outside
  /// the Unicode range 0..0x10FFFF.
  bool isPrintable(int? character) {
    if (character == null) {
      return false;
    }
    return !isNonPrintable(character);
  }

  /// Whether every character in [string] is whitespace.
  ///
  /// Whitespace matches the set used by [String.trim], which includes
  /// Unicode spaces as well as space, tab and newline. Returns true for an
  /// empty string.
  bool isWhitespace(String string) {
    for (final element in string.runes) {
      if (!isWhitespaceRune(element)) {
        return false;
      }
    }
    return true;
  }

  /// Whether [rune] is a whitespace character.
  ///
  /// Whitespace matches the set used by [String.trim], which includes
  /// Unicode spaces as well as space, tab and newline.
  bool isWhitespaceRune(int rune) =>
      (rune >= 0x0009 && rune <= 0x000D) ||
      rune == 0x0020 ||
      rune == 0x0085 ||
      rune == 0x00A0 ||
      rune == 0x1680 ||
      rune == 0x180E ||
      (rune >= 0x2000 && rune <= 0x200A) ||
      rune == 0x2028 ||
      rune == 0x2029 ||
      rune == 0x202F ||
      rune == 0x205F ||
      rune == 0x3000 ||
      rune == 0xFEFF;
}
/// Counts how many characters at the start of [text] are style codes.
///
/// Skips over each leading `CSI <digits, ':' or ';'> m` sequence and stops at
/// the first character that isn't part of one. Returns 0 when [text] doesn't
/// start with a style code. [StringExtensions] uses it to add new codes after
/// the existing ones, so chained styles stay grouped at the front.
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

/// Whether [unit] can appear inside a style code's parameters.
///
/// True for the digits `0`-`9`, `:` and `;`, which are the only characters
/// used between [CSI] and [SGR] in this library's codes.
bool _isParameterByte(int unit) =>
    (unit >= 0x30 && unit <= 0x39) || unit == 0x3A || unit == 0x3B;
