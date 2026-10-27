part of '../ascii.dart';

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

/// Text back to the terminal's default colour — SGR 39.
const String RESET_FG = '${CSI}39$SGR';

/// Background back to the terminal's default — SGR 49.
const String RESET_BG = '${CSI}49$SGR';

/// Underline back to the text's own colour, underline still on — SGR 59.
const String RESET_UNDERLINE_COLOUR = '${CSI}59$SGR';
