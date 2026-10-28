import 'package:cmdline/cmdline.dart';

/// Moves the cursor up by [lines] rows.
///
/// `CSI n A`. Stops at the top of the screen.
String cursorUp([int lines = 1]) => '$CSI${lines}A';

/// Moves the cursor down by [lines] rows.
///
/// `CSI n B`. Stops at the bottom of the screen.
String cursorDown([int lines = 1]) => '$CSI${lines}B';

/// Moves the cursor right by [columns].
///
/// `CSI n C`. Stops at the edge of the screen.
String cursorRight([int columns = 1]) => '$CSI${columns}C';

/// Moves the cursor left by [columns].
///
/// `CSI n D`. Stops at the edge of the screen.
String cursorLeft([int columns = 1]) => '$CSI${columns}D';

/// Moves the cursor to the start of a line [lines] rows below.
///
/// `CSI n E`. Like [cursorDown], but also goes back to the first column.
String cursorToLineBelow([int lines = 1]) => '$CSI${lines}E';

/// Moves the cursor to the start of a line [lines] rows above.
///
/// `CSI n F`. Like [cursorUp], but also goes back to the first column.
/// Handy for redrawing the last few lines of output.
String cursorToLineAbove([int lines = 1]) => '$CSI${lines}F';

/// Moves the cursor to [column] on the current line.
///
/// `CSI n G`. Columns start at 1.
String cursorToColumn(int column) => '$CSI${column}G';

/// Moves the cursor to [row] and [column] on the screen.
///
/// `CSI row;column H`. Both start at 1, so `cursorTo(1, 1)` is the top left.
String cursorTo(int row, int column) => '$CSI$row;${column}H';

/// Moves the cursor to the top left of the screen.
///
/// `CSI H`. Same as `cursorTo(1, 1)`.
const String CURSOR_HOME = '${CSI}H';

/// Remembers where the cursor is, to come back with [RESTORE_CURSOR].
///
/// `ESC 7`. Only one position is remembered; saving again replaces it.
const String SAVE_CURSOR = '${ESC}7';

/// Moves the cursor back to where [SAVE_CURSOR] left it.
///
/// `ESC 8`.
const String RESTORE_CURSOR = '${ESC}8';

/// Hides the cursor.
///
/// `CSI ?25l`. Stops it flickering during animations. Always show it again
/// with [SHOW_CURSOR] before the program ends.
const String HIDE_CURSOR = '$CSI?25l';

/// Shows the cursor again after [HIDE_CURSOR].
///
/// `CSI ?25h`.
const String SHOW_CURSOR = '$CSI?25h';

/// Puts the cursor back to the shape the user's terminal normally uses.
///
/// `CSI 0 SP q`. The cursor shape codes are supported by most modern
/// terminals, including Windows Terminal; older ones ignore them.
const String CURSOR_DEFAULT = '${CSI}0 q';

/// A blinking block cursor.
///
/// `CSI 1 SP q`.
const String CURSOR_BLOCK_BLINKING = '${CSI}1 q';

/// A steady block cursor.
///
/// `CSI 2 SP q`.
const String CURSOR_BLOCK = '${CSI}2 q';

/// A blinking underline cursor.
///
/// `CSI 3 SP q`. Not the same as the [UNDERLINE] text style.
const String CURSOR_UNDERLINE_BLINKING = '${CSI}3 q';

/// A steady underline cursor.
///
/// `CSI 4 SP q`. Not the same as the [UNDERLINE] text style.
const String CURSOR_UNDERLINE = '${CSI}4 q';

/// A blinking thin bar cursor, like in most text editors.
///
/// `CSI 5 SP q`.
const String CURSOR_BAR_BLINKING = '${CSI}5 q';

/// A steady thin bar cursor.
///
/// `CSI 6 SP q`.
const String CURSOR_BAR = '${CSI}6 q';
