import 'package:cmdline/cmdline.dart';

/// *Native only* Same function as running `clear` in pwsh
///
/// Does not work in most IDE terminals like Intellij
const String CLEAR = '$CLEAR_SCREEN${CSI}0;${0}H';

/// Clears everything on the screen.
///
/// `CSI 2J`. The cursor doesn't move, so add [CURSOR_HOME] to start again
/// at the top left. The scrollback is kept; see [CLEAR_SCROLLBACK].
const String CLEAR_SCREEN = '${CSI}2J';

/// Clears the scrollback (the lines above the screen).
///
/// `CSI 3J`. Use with [CLEAR_SCREEN] for a fully empty terminal.
const String CLEAR_SCROLLBACK = '${CSI}3J';

/// Clears from the cursor to the end of the screen.
///
/// `CSI 0J`.
const String CLEAR_TO_SCREEN_END = '${CSI}0J';

/// Clears from the start of the screen to the cursor.
///
/// `CSI 1J`.
const String CLEAR_TO_SCREEN_START = '${CSI}1J';

/// Clears from the cursor to the end of the line.
///
/// `CSI 0K`. For the whole line, see [CLEAR_LINE].
const String CLEAR_TO_LINE_END = '${CSI}0K';

/// Clears from the start of the line to the cursor.
///
/// `CSI 1K`.
const String CLEAR_TO_LINE_START = '${CSI}1K';

/// Scrolls the screen content up by [lines], adding blank lines at the bottom.
///
/// `CSI n S`. The cursor doesn't move.
String scrollUp([int lines = 1]) => '$CSI${lines}S';

/// Scrolls the screen content down by [lines], adding blank lines at the top.
///
/// `CSI n T`. The cursor doesn't move.
String scrollDown([int lines = 1]) => '$CSI${lines}T';

/// Limits scrolling to the rows from [top] to [bottom].
///
/// `CSI top;bottom r`. Rows start at 1. Lines outside the region stay put,
/// which is how apps keep a fixed header or footer. Undo it with
/// [RESET_SCROLL_REGION].
String scrollRegion(int top, int bottom) => '$CSI$top;${bottom}r';

/// Lets the whole screen scroll again after [scrollRegion].
///
/// `CSI r`.
const String RESET_SCROLL_REGION = '${CSI}r';

/// Switches to a separate, empty screen, like vim or less do.
///
/// `CSI ?1049h`. What was on the normal screen comes back untouched with
/// [ALTERNATE_SCREEN_OFF]. Always switch back before the program ends.
const String ALTERNATE_SCREEN_ON = '$CSI?1049h';

/// Goes back to the normal screen after [ALTERNATE_SCREEN_ON].
///
/// `CSI ?1049l`.
const String ALTERNATE_SCREEN_OFF = '$CSI?1049l';

/// Starts a redraw that the terminal shows all at once.
///
/// `CSI ?2026h`. Write your changes, then [SYNC_END]; the terminal holds the
/// picture until then, so there's no flicker. Supported by Windows Terminal,
/// kitty, WezTerm, iTerm2 and others; older terminals ignore it safely.
const String SYNC_START = '$CSI?2026h';

/// Ends a redraw started with [SYNC_START] and shows it.
///
/// `CSI ?2026l`.
const String SYNC_END = '$CSI?2026l';
