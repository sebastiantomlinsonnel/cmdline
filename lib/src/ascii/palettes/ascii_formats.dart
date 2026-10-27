import 'package:cmdline/ascii.dart';

/// Every text style, ready to drop into a string.
///
/// ```dart
/// print('${formats.bold}loud${formats.resetBoldAndDim} quiet$reset');
/// ```
///
/// Also reachable as `Ascii.format`, and as the SCREAMING_CASE constants at
/// the bottom of this file if you would rather not go through an object.
///
/// Terminal support varies. Bold, dim, italic, underline, inverse and
/// strikethrough are safe nearly everywhere; the fonts, the ideogram marks and
/// the frame/encircle group are honoured by almost nothing.
const AsciiFormats formats = AsciiFormats();

/// The text styles, grouped on one object so they can be reached by name.
///
/// See [formats] for the shared instance — there is no reason to build
/// another.
class AsciiFormats {
  const AsciiFormats();

  /// Clears every colour and style. Same string as the top-level [reset].
  final String reset = RESET;

  /// Bold, or increased intensity. Cleared by [resetBoldAndDim].
  final String bold = BOLD;

  /// Dim, or decreased intensity. Cleared by [resetBoldAndDim].
  final String dim = DIM;

  /// Clears [bold] and [dim] together — ANSI gives them one reset, not two.
  final String resetBoldAndDim = RESET_BOLD_AND_DIM;

  /// The terminal's default font. Clears [alternativeFont1] and friends.
  final String primaryFont = PRIMARY_FONT;

  /// First alternative font. Cleared by [primaryFont].
  final String alternativeFont1 = ALTERNATIVE_FONT_1;

  /// Second alternative font. Cleared by [primaryFont].
  final String alternativeFont2 = ALTERNATIVE_FONT_2;

  /// Third alternative font. Cleared by [primaryFont].
  final String alternativeFont3 = ALTERNATIVE_FONT_3;

  /// Fourth alternative font. Cleared by [primaryFont].
  final String alternativeFont4 = ALTERNATIVE_FONT_4;

  /// Fifth alternative font. Cleared by [primaryFont].
  final String alternativeFont5 = ALTERNATIVE_FONT_5;

  /// Sixth alternative font. Cleared by [primaryFont].
  final String alternativeFont6 = ALTERNATIVE_FONT_6;

  /// Seventh alternative font. Cleared by [primaryFont].
  final String alternativeFont7 = ALTERNATIVE_FONT_7;

  /// Eighth alternative font. Cleared by [primaryFont].
  final String alternativeFont8 = ALTERNATIVE_FONT_8;

  /// Ninth alternative font. Cleared by [primaryFont].
  final String alternativeFont9 = ALTERNATIVE_FONT_9;

  /// Italic. Cleared by [resetItalic].
  final String italic = ITALIC;

  /// Fraktur (Gothic). Cleared by [resetItalic] — ANSI shares one reset
  /// between the two.
  final String fraktur = FRAKTUR;

  /// Clears [italic] and [fraktur] together.
  final String resetItalic = RESET_ITALIC;

  /// Underline. Cleared by [resetUnderline].
  final String underline = UNDERLINE;

  /// Double underline. Cleared by [resetUnderline].
  ///
  /// Some terminals — the Linux console before 4.17 among them — read this as
  /// "not bold" instead.
  final String doublyUnderline = DOUBLY_UNDERLINE;

  /// Curly (wavy) underline, the one spell checkers draw. Cleared by
  /// [resetUnderline].
  ///
  /// A sub-parameter of [underline] rather than a code of its own, so a
  /// terminal that does not know it usually falls back to a plain underline.
  final String curlyUnderline = CURLY_UNDERLINE;

  /// Dotted underline. Cleared by [resetUnderline]. See [curlyUnderline] on
  /// support.
  final String dottedUnderline = DOTTED_UNDERLINE;

  /// Dashed underline. Cleared by [resetUnderline]. See [curlyUnderline] on
  /// support.
  final String dashedUnderline = DASHED_UNDERLINE;

  /// Clears every underline style, whatever its shape.
  final String resetUnderline = RESET_UNDERLINE;

  /// Blink, under 150 per minute. Cleared by [resetBlink].
  final String blink = BLINK;

  /// Blink, 150 per minute or more. Cleared by [resetBlink].
  final String blinkRapid = BLINK_RAPID;

  /// Clears [blink] and [blinkRapid].
  final String resetBlink = RESET_BLINK;

  /// Proportional spacing. Cleared by [resetProportionalSpacing].
  final String proportionalSpacing = PROPORTIONAL_SPACING;

  /// Clears [proportionalSpacing].
  final String resetProportionalSpacing = RESET_PROPORTIONAL_SPACING;

  /// Swaps foreground and background. Cleared by [resetInverse].
  final String inverse = INVERSE;

  /// Clears [inverse].
  final String resetInverse = RESET_INVERSE;

  /// Hides the text — still selectable and still copied, just not drawn.
  /// Cleared by [resetInvisible].
  final String invisible = INVISIBLE;

  /// Clears [invisible].
  final String resetInvisible = RESET_INVISIBLE;

  /// Strikethrough. Cleared by [resetStrikethrough].
  final String strikethrough = STRIKETHROUGH;

  /// Clears [strikethrough].
  final String resetStrikethrough = RESET_STRIKETHROUGH;

  /// Draws a frame around the text. Cleared by [resetFrameAndEncircle].
  final String frame = FRAME;

  /// Draws a circle around the text. Cleared by [resetFrameAndEncircle].
  final String encircle = ENCIRCLE;

  /// Clears [frame] and [encircle] together.
  final String resetFrameAndEncircle = RESET_FRAME_AND_ENCIRCLE;

  /// A line above the text. Cleared by [resetOverline].
  final String overline = OVERLINE;

  /// Clears [overline].
  final String resetOverline = RESET_OVERLINE;

  /// Ideogram underline, or a line down the right side. Cleared by
  /// [resetIdeogram].
  final String ideogramUnderline = IDEOGRAM_UNDERLINE;

  /// Ideogram double underline. Cleared by [resetIdeogram].
  final String ideogramDoublyUnderline = IDEOGRAM_DOUBLY_UNDERLINE;

  /// Ideogram overline, or a line down the left side. Cleared by
  /// [resetIdeogram].
  final String ideogramOverline = IDEOGRAM_OVERLINE;

  /// Ideogram double overline. Cleared by [resetIdeogram].
  final String ideogramDoublyOverline = IDEOGRAM_DOUBLY_OVERLINE;

  /// Ideogram stress marking. Cleared by [resetIdeogram].
  final String ideogramStress = IDEOGRAM_STRESS;

  /// Clears every ideogram mark.
  final String resetIdeogram = RESET_IDEOGRAM;

  /// Superscript. Cleared by [resetSuperAndSubscript].
  final String superscript = SUPERSCRIPT;

  /// Subscript. Cleared by [resetSuperAndSubscript].
  final String subscript = SUBSCRIPT;

  /// Clears [superscript] and [subscript] together.
  final String resetSuperAndSubscript = RESET_SUPER_AND_SUBSCRIPT;
}

//
// The same styles as bare constants. These are what the [AsciiFormats] fields
// above are built from, so the two can never drift apart.
//

/// Clears every colour and style — SGR 0.
const String RESET = reset;

/// Bold, or increased intensity — SGR 1.
const String BOLD = '${CSI}1$SGR';

/// Dim, or decreased intensity — SGR 2.
const String DIM = '${CSI}2$SGR';

/// Clears [BOLD] and [DIM] — SGR 22.
const String RESET_BOLD_AND_DIM = '${CSI}22$SGR';

/// The terminal's default font — SGR 10.
const String PRIMARY_FONT = '${CSI}10$SGR';

/// First alternative font — SGR 11.
const String ALTERNATIVE_FONT_1 = '${CSI}11$SGR';

/// Second alternative font — SGR 12.
const String ALTERNATIVE_FONT_2 = '${CSI}12$SGR';

/// Third alternative font — SGR 13.
const String ALTERNATIVE_FONT_3 = '${CSI}13$SGR';

/// Fourth alternative font — SGR 14.
const String ALTERNATIVE_FONT_4 = '${CSI}14$SGR';

/// Fifth alternative font — SGR 15.
const String ALTERNATIVE_FONT_5 = '${CSI}15$SGR';

/// Sixth alternative font — SGR 16.
const String ALTERNATIVE_FONT_6 = '${CSI}16$SGR';

/// Seventh alternative font — SGR 17.
const String ALTERNATIVE_FONT_7 = '${CSI}17$SGR';

/// Eighth alternative font — SGR 18.
const String ALTERNATIVE_FONT_8 = '${CSI}18$SGR';

/// Ninth alternative font — SGR 19.
const String ALTERNATIVE_FONT_9 = '${CSI}19$SGR';

/// Italic — SGR 3.
const String ITALIC = '${CSI}3$SGR';

/// Fraktur (Gothic) — SGR 20.
const String FRAKTUR = '${CSI}20$SGR';

/// Clears [ITALIC] and [FRAKTUR] — SGR 23.
const String RESET_ITALIC = '${CSI}23$SGR';

/// Underline — SGR 4.
const String UNDERLINE = '${CSI}4$SGR';

/// Double underline — SGR 21.
const String DOUBLY_UNDERLINE = '${CSI}21$SGR';

/// Curly (wavy) underline — SGR 4:3.
const String CURLY_UNDERLINE = '${CSI}4:3$SGR';

/// Dotted underline — SGR 4:4.
const String DOTTED_UNDERLINE = '${CSI}4:4$SGR';

/// Dashed underline — SGR 4:5.
const String DASHED_UNDERLINE = '${CSI}4:5$SGR';

/// Clears every underline style — SGR 24.
const String RESET_UNDERLINE = '${CSI}24$SGR';

/// Blink, under 150 per minute — SGR 5.
const String BLINK = '${CSI}5$SGR';

/// Blink, 150 per minute or more — SGR 6.
const String BLINK_RAPID = '${CSI}6$SGR';

/// Clears [BLINK] and [BLINK_RAPID] — SGR 25.
const String RESET_BLINK = '${CSI}25$SGR';

/// Proportional spacing — SGR 26.
const String PROPORTIONAL_SPACING = '${CSI}26$SGR';

/// Clears [PROPORTIONAL_SPACING] — SGR 50.
const String RESET_PROPORTIONAL_SPACING = '${CSI}50$SGR';

/// Swaps foreground and background — SGR 7.
const String INVERSE = '${CSI}7$SGR';

/// Clears [INVERSE] — SGR 27.
const String RESET_INVERSE = '${CSI}27$SGR';

/// Hides the text — SGR 8.
const String INVISIBLE = '${CSI}8$SGR';

/// Clears [INVISIBLE] — SGR 28.
const String RESET_INVISIBLE = '${CSI}28$SGR';

/// Strikethrough — SGR 9.
const String STRIKETHROUGH = '${CSI}9$SGR';

/// Clears [STRIKETHROUGH] — SGR 29.
const String RESET_STRIKETHROUGH = '${CSI}29$SGR';

/// Draws a frame around the text — SGR 51.
const String FRAME = '${CSI}51$SGR';

/// Draws a circle around the text — SGR 52.
const String ENCIRCLE = '${CSI}52$SGR';

/// Clears [FRAME] and [ENCIRCLE] — SGR 54.
const String RESET_FRAME_AND_ENCIRCLE = '${CSI}54$SGR';

/// A line above the text — SGR 53.
const String OVERLINE = '${CSI}53$SGR';

/// Clears [OVERLINE] — SGR 55.
const String RESET_OVERLINE = '${CSI}55$SGR';

/// Ideogram underline — SGR 60.
const String IDEOGRAM_UNDERLINE = '${CSI}60$SGR';

/// Ideogram double underline — SGR 61.
const String IDEOGRAM_DOUBLY_UNDERLINE = '${CSI}61$SGR';

/// Ideogram overline — SGR 62.
const String IDEOGRAM_OVERLINE = '${CSI}62$SGR';

/// Ideogram double overline — SGR 63.
const String IDEOGRAM_DOUBLY_OVERLINE = '${CSI}63$SGR';

/// Ideogram stress marking — SGR 64.
const String IDEOGRAM_STRESS = '${CSI}64$SGR';

/// Clears every ideogram mark — SGR 65.
const String RESET_IDEOGRAM = '${CSI}65$SGR';

/// Superscript — SGR 73.
const String SUPERSCRIPT = '${CSI}73$SGR';

/// Subscript — SGR 74.
const String SUBSCRIPT = '${CSI}74$SGR';

/// Clears [SUPERSCRIPT] and [SUBSCRIPT] — SGR 75.
const String RESET_SUPER_AND_SUBSCRIPT = '${CSI}75$SGR';
