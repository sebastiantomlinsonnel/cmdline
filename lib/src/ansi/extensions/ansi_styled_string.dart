import 'package:cmdline/cmdline.dart';

/// Counts how many characters at the start of [text] are style codes.
///
/// Skips over each leading `CSI <digits, ':' or ';'> m` sequence and stops at
/// the first character that isn't part of one. Returns 0 when [text] doesn't
/// start with a style code. [AnsiStyledString] uses it to add new codes after
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

/// Whether [unit] is the letter that ends a [CSI] code, like `m` or `H`.
///
/// True for the characters from `@` to `~`.
bool _isFinalByte(int unit) => unit >= 0x40 && unit <= 0x7E;

/// Adds colours and text styles to any [String], and chains them together.
///
/// Every getter and method returns a new string with the style code at the
/// front and a single [RESET] at the end. Chaining works because each call
/// removes the previous trailing [RESET] and slots its code in next to the
/// earlier ones:
///
/// ```dart
/// print('Done'.bold.foreground(const AnsiColour(10)));
/// // -> ESC[1m ESC[38;5;10m Done ESC[0m  (without the spaces)
/// ```
///
/// Many styles depend on the terminal; see the matching constants (such as
/// [CURLY_UNDERLINE] or [FRAME]) for how widely each is supported.
extension AnsiStyledString on String {
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
  String get plain {
    final result = StringBuffer();
    int at = 0;

    while (at < length) {
      // Normal text is kept as it is.
      if (!startsWith(ESC, at)) {
        result.write(this[at]);
        at++;
        continue;
      }

      if (startsWith(CSI, at)) {
        // Styles, cursor moves and so on: ESC [ ... then one letter.
        at += CSI.length;
        while (at < length && !_isFinalByte(codeUnitAt(at))) {
          at++;
        }
        at++; // Skip the final letter too.
      } else if (startsWith(OSC, at)) {
        // Links, window titles and so on: ESC ] ... then BELL or ST.
        at += OSC.length;
        while (at < length && !startsWith(BELL, at) && !startsWith(ST, at)) {
          at++;
        }
        at += startsWith(ST, at) ? ST.length : BELL.length;
      } else {
        // Any other code: ESC and the one character after it.
        at += 2;
      }
    }

    return result.toString();
  }

  /// The text with its escape codes shown as readable text.
  ///
  /// Handy for checking which codes a string really holds. Each escape
  /// character is shown as `ESC` and each bell as `BELL`.
  ///
  /// ```dart
  /// print('Hi'.bold.visible); // ESC[1mHiESC[0m
  /// ```
  String get visible => replaceAll(ESC, 'ESC').replaceAll(BELL, 'BELL');

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
}
