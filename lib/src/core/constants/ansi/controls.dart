part of 'ansi_constants.dart';

/// The escape character that starts every terminal control sequence.
///
/// Byte `0x1B`. On its own it does nothing visible; the characters after it
/// tell the terminal what to do. Most codes in this library start with [CSI],
/// which is this character followed by `[`.
const String ESC = '\x1B';

/// A line break.
///
/// Plain `\n`. Kept as a constant so multi-line output built from codes reads
/// the same way as the rest of the sequences.
const String NEWLINE = '\n';

/// The code point of the last ASCII character (DEL).
const int DEL = 0x7F;

/// The Control Sequence Introducer that starts most escape codes.
///
/// [ESC] followed by `[`. A full style code is `CSI`, then the parameters,
/// then a final letter, e.g. `${CSI}1$SGR` turns on bold.
const String CSI = '$ESC[';

/// Start of a 256-colour text (foreground) code; add an index and [SGR].
///
/// `${CSI}38;5;`. Append a palette index from 0 to 255 and [SGR] to finish it:
/// `'${FGCO}196$SGR'` makes the text bright red. The ready-made `*_FG`
/// constants and [AnsiColour.fg] do the same thing.
const String FGCO = '${CSI}38;5;';

/// Start of a 256-colour background code; add an index and [SGR].
///
/// `${CSI}48;5;`. Append a palette index from 0 to 255 and [SGR] to finish it:
/// `'${BGCO}21$SGR'` gives a blue background. The ready-made `*_BG` constants
/// and [AnsiColour.bg] do the same thing.
const String BGCO = '${CSI}48;5;';

/// Start of a 256-colour underline-colour code; add an index and [SGR].
///
/// `${CSI}58;5;`. Append a palette index from 0 to 255 and [SGR] to finish it.
/// It only shows while an underline style is on, and not every terminal
/// supports coloured underlines. [AnsiColour.underline] builds the same code.
const String ULCO = '${CSI}58;5;';

/// The final letter that ends a style (Select Graphic Rendition) code.
///
/// `m`. Every style and colour code in this library has the form
/// `CSI <parameters> SGR`, e.g. `${CSI}3$SGR` for italic.
const String SGR = 'm';

/// Turns off every style and colour.
///
/// `${CSI}0m`. Puts the terminal back to its default text. Printing helpers
/// such as [Ansi.toString], [AnsiPrinter] and [StringExtensions] add it at
/// the end so a style never leaks into the next line.
const String RESET = '${CSI}0$SGR';

/// Clears line
const String CLEAR_LINE = '\r\x1B[2K';

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

/// *Native only* Same function as running `clear` in pwsh
///
/// Does not work in most IDE terminals like Intellij
const String CLEAR = '$CLEAR_SCREEN$CURSOR_HOME';

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

/// Shows a busy animation on the tab and taskbar, for unknown progress.
///
/// `OSC 9;4;3`. Supported by Windows Terminal and ConEmu.
const String TASKBAR_BUSY = '${OSC}9;4;3;0$ST';

/// Removes the progress from the tab and taskbar.
///
/// `OSC 9;4;0`.
const String TASKBAR_CLEAR = '${OSC}9;4;0;0$ST';

/// The Operating System Command introducer that starts terminal extras.
///
/// [ESC] followed by `]`. Codes like [hyperlink] and [windowTitle] have the
/// form `OSC <number>;<data> ST`.
const String OSC = '$ESC]';

/// The String Terminator that ends an [OSC] code.
///
/// [ESC] followed by `\`.
const String ST = '$ESC\\';

/// Rings the terminal bell.
///
/// `\x07`. Depending on the settings this beeps, flashes the window or
/// marks the tab.
const String BELL = '\x07';
