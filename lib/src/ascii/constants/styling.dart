part of '../ascii.dart';

/// Makes text bold (or brighter).
///
/// SGR code 1. Some terminals show it as a brighter colour instead of a
/// heavier font. Turn it off with [RESET_BOLD_AND_DIM].
const String BOLD = '${CSI}1$SGR';

/// Makes text dim (faint).
///
/// SGR code 2. Lowers the text's brightness. Turn it off with
/// [RESET_BOLD_AND_DIM].
const String DIM = '${CSI}2$SGR';

/// Turns off [BOLD] and [DIM].
///
/// SGR code 22. Both are cleared together because terminals track them as
/// one "intensity" setting.
const String RESET_BOLD_AND_DIM = '${CSI}22$SGR';

/// Switches back to the default font.
///
/// SGR code 10. Undoes any of the `ALTERNATIVE_FONT_*` codes.
const String PRIMARY_FONT = '${CSI}10$SGR';

/// Switches to alternative font 1.
///
/// SGR code 11. Very few terminals support alternative fonts; most ignore
/// this code. Switch back with [PRIMARY_FONT].
const String ALTERNATIVE_FONT_1 = '${CSI}11$SGR';

/// Switches to alternative font 2.
///
/// SGR code 12. Rarely supported; most terminals ignore it. Switch back with
/// [PRIMARY_FONT].
const String ALTERNATIVE_FONT_2 = '${CSI}12$SGR';

/// Switches to alternative font 3.
///
/// SGR code 13. Rarely supported; most terminals ignore it. Switch back with
/// [PRIMARY_FONT].
const String ALTERNATIVE_FONT_3 = '${CSI}13$SGR';

/// Switches to alternative font 4.
///
/// SGR code 14. Rarely supported; most terminals ignore it. Switch back with
/// [PRIMARY_FONT].
const String ALTERNATIVE_FONT_4 = '${CSI}14$SGR';

/// Switches to alternative font 5.
///
/// SGR code 15. Rarely supported; most terminals ignore it. Switch back with
/// [PRIMARY_FONT].
const String ALTERNATIVE_FONT_5 = '${CSI}15$SGR';

/// Switches to alternative font 6.
///
/// SGR code 16. Rarely supported; most terminals ignore it. Switch back with
/// [PRIMARY_FONT].
const String ALTERNATIVE_FONT_6 = '${CSI}16$SGR';

/// Switches to alternative font 7.
///
/// SGR code 17. Rarely supported; most terminals ignore it. Switch back with
/// [PRIMARY_FONT].
const String ALTERNATIVE_FONT_7 = '${CSI}17$SGR';

/// Switches to alternative font 8.
///
/// SGR code 18. Rarely supported; most terminals ignore it. Switch back with
/// [PRIMARY_FONT].
const String ALTERNATIVE_FONT_8 = '${CSI}18$SGR';

/// Switches to alternative font 9.
///
/// SGR code 19. Rarely supported; most terminals ignore it. Switch back with
/// [PRIMARY_FONT].
const String ALTERNATIVE_FONT_9 = '${CSI}19$SGR';

/// Makes text italic.
///
/// SGR code 3. Widely supported, though some terminals show it as inverse
/// instead. Turn it off with [RESET_ITALIC].
const String ITALIC = '${CSI}3$SGR';

/// Switches to a blackletter (Fraktur) font.
///
/// SGR code 20. Almost no terminals support it. Turn it off with
/// [RESET_ITALIC], which clears italic and Fraktur together.
const String FRAKTUR = '${CSI}20$SGR';

/// Turns off [ITALIC] and [FRAKTUR].
///
/// SGR code 23.
const String RESET_ITALIC = '${CSI}23$SGR';

/// Underlines text with a single straight line.
///
/// SGR code 4. Colour the line with [ULCO] or [AsciiInk.underline]. Turn it
/// off with [RESET_UNDERLINE].
const String UNDERLINE = '${CSI}4$SGR';

/// Underlines text with a double line.
///
/// SGR code 21. Some older terminals treat this code as "bold off" instead,
/// so check it in the terminals you target. Turn it off with
/// [RESET_UNDERLINE].
const String DOUBLY_UNDERLINE = '${CSI}21$SGR';

/// Underlines text with a wavy line, like a spell-check mark.
///
/// SGR code `4:3`. An extension supported by kitty, WezTerm, VTE-based
/// terminals and others; elsewhere it may show as a plain underline or not at
/// all. Turn it off with [RESET_UNDERLINE].
const String CURLY_UNDERLINE = '${CSI}4:3$SGR';

/// Underlines text with a dotted line.
///
/// SGR code `4:4`. Same support as [CURLY_UNDERLINE]. Turn it off with
/// [RESET_UNDERLINE].
const String DOTTED_UNDERLINE = '${CSI}4:4$SGR';

/// Underlines text with a dashed line.
///
/// SGR code `4:5`. Same support as [CURLY_UNDERLINE]. Turn it off with
/// [RESET_UNDERLINE].
const String DASHED_UNDERLINE = '${CSI}4:5$SGR';

/// Turns off every underline style.
///
/// SGR code 24. Clears [UNDERLINE], [DOUBLY_UNDERLINE] and the curly, dotted
/// and dashed variants. The underline colour stays set; clear it with
/// [RESET_UNDERLINE_COLOUR].
const String RESET_UNDERLINE = '${CSI}24$SGR';

/// Makes text blink slowly.
///
/// SGR code 5. Many terminals ignore blinking or let users turn it off.
/// Turn it off with [RESET_BLINK].
const String BLINK = '${CSI}5$SGR';

/// Makes text blink quickly.
///
/// SGR code 6. Rarely supported; terminals that do support it often blink at
/// the same speed as [BLINK]. Turn it off with [RESET_BLINK].
const String BLINK_RAPID = '${CSI}6$SGR';

/// Turns off [BLINK] and [BLINK_RAPID].
///
/// SGR code 25.
const String RESET_BLINK = '${CSI}25$SGR';

/// Turns on proportional spacing.
///
/// SGR code 26. Meant to drop the fixed-width grid; almost no terminals
/// support it. Turn it off with [RESET_PROPORTIONAL_SPACING].
const String PROPORTIONAL_SPACING = '${CSI}26$SGR';

/// Turns off [PROPORTIONAL_SPACING].
///
/// SGR code 50.
const String RESET_PROPORTIONAL_SPACING = '${CSI}50$SGR';

/// Swaps the text and background colours.
///
/// SGR code 7. Handy for highlights because it works with whatever colours
/// the terminal theme uses. Turn it off with [RESET_INVERSE].
const String INVERSE = '${CSI}7$SGR';

/// Turns off [INVERSE].
///
/// SGR code 27.
const String RESET_INVERSE = '${CSI}27$SGR';

/// Hides text while still taking up its space.
///
/// SGR code 8. The text is still there, so it can be selected and copied.
/// Don't rely on it to hide secrets. Turn it off with [RESET_INVISIBLE].
const String INVISIBLE = '${CSI}8$SGR';

/// Turns off [INVISIBLE].
///
/// SGR code 28.
const String RESET_INVISIBLE = '${CSI}28$SGR';

/// Draws a line through the middle of text.
///
/// SGR code 9. Turn it off with [RESET_STRIKETHROUGH].
const String STRIKETHROUGH = '${CSI}9$SGR';

/// Turns off [STRIKETHROUGH].
///
/// SGR code 29.
const String RESET_STRIKETHROUGH = '${CSI}29$SGR';

/// Draws a box around text.
///
/// SGR code 51. Almost no terminals support it. Turn it off with
/// [RESET_FRAME_AND_ENCIRCLE].
const String FRAME = '${CSI}51$SGR';

/// Draws a circle around text.
///
/// SGR code 52. Almost no terminals support it. Turn it off with
/// [RESET_FRAME_AND_ENCIRCLE].
const String ENCIRCLE = '${CSI}52$SGR';

/// Turns off [FRAME] and [ENCIRCLE].
///
/// SGR code 54.
const String RESET_FRAME_AND_ENCIRCLE = '${CSI}54$SGR';

/// Draws a line above text.
///
/// SGR code 53. Supported by many modern terminals. Turn it off with
/// [RESET_OVERLINE].
const String OVERLINE = '${CSI}53$SGR';

/// Turns off [OVERLINE].
///
/// SGR code 55.
const String RESET_OVERLINE = '${CSI}55$SGR';

/// Ideogram underline (or right-side line).
///
/// SGR code 60. Meant for CJK text layout; almost no terminals support it.
/// Turn it off with [RESET_IDEOGRAM].
const String IDEOGRAM_UNDERLINE = '${CSI}60$SGR';

/// Ideogram double underline (or double right-side line).
///
/// SGR code 61. Rarely supported. Turn it off with [RESET_IDEOGRAM].
const String IDEOGRAM_DOUBLY_UNDERLINE = '${CSI}61$SGR';

/// Ideogram overline (or left-side line).
///
/// SGR code 62. Rarely supported. Turn it off with [RESET_IDEOGRAM].
const String IDEOGRAM_OVERLINE = '${CSI}62$SGR';

/// Ideogram double overline (or double left-side line).
///
/// SGR code 63. Rarely supported. Turn it off with [RESET_IDEOGRAM].
const String IDEOGRAM_DOUBLY_OVERLINE = '${CSI}63$SGR';

/// Ideogram stress marking.
///
/// SGR code 64. Rarely supported. Turn it off with [RESET_IDEOGRAM].
const String IDEOGRAM_STRESS = '${CSI}64$SGR';

/// Turns off every ideogram style.
///
/// SGR code 65. Clears codes 60 to 64.
const String RESET_IDEOGRAM = '${CSI}65$SGR';

/// Shows text as superscript.
///
/// SGR code 73. Supported by mintty and only a few other terminals. Turn it
/// off with [RESET_SUPER_AND_SUBSCRIPT].
const String SUPERSCRIPT = '${CSI}73$SGR';

/// Shows text as subscript.
///
/// SGR code 74. Same limited support as [SUPERSCRIPT]. Turn it off with
/// [RESET_SUPER_AND_SUBSCRIPT].
const String SUBSCRIPT = '${CSI}74$SGR';

/// Turns off [SUPERSCRIPT] and [SUBSCRIPT].
///
/// SGR code 75.
const String RESET_SUPER_AND_SUBSCRIPT = '${CSI}75$SGR';

/// Sets the text colour back to the terminal default.
///
/// SGR code 39. Undoes any `*_FG` code or [AsciiInk.fg] without touching
/// other styles.
const String RESET_FG = '${CSI}39$SGR';

/// Sets the background colour back to the terminal default.
///
/// SGR code 49. Undoes any `*_BG` code or [AsciiInk.bg] without touching
/// other styles.
const String RESET_BG = '${CSI}49$SGR';

/// Sets the underline colour back to the default (the text colour).
///
/// SGR code 59. Undoes [ULCO] or [AsciiInk.underline]. The underline itself
/// stays on; turn that off with [RESET_UNDERLINE].
const String RESET_UNDERLINE_COLOUR = '${CSI}59$SGR';
