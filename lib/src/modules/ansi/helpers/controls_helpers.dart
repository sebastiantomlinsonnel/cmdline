import 'dart:convert';

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

/// Makes [text] a clickable link that opens [url].
///
/// `OSC 8`. Works in Windows Terminal, iTerm2, kitty, WezTerm, GNOME
/// Terminal and most modern terminals. Others just show [text].
///
/// ```dart
/// print(hyperlink('https://dart.dev', 'Dart docs'));
/// ```
String hyperlink(String url, String text) =>
    '${OSC}8;;$url$ST$text${OSC}8;;$ST';

/// Sets the title of the terminal window or tab.
///
/// `OSC 2`. Supported almost everywhere.
String windowTitle(String title) => '${OSC}2;$title$ST';

/// Shows [percent] (0 to 100) as progress on the terminal tab and taskbar.
///
/// `OSC 9;4;1`. Supported by Windows Terminal and ConEmu; other terminals
/// ignore it. Clear it with [TASKBAR_CLEAR] when done.
String taskbarProgress(int percent) => '${OSC}9;4;1;$percent$ST';

/// Like [taskbarProgress], but shown in red to say something failed.
///
/// `OSC 9;4;2`.
String taskbarError(int percent) => '${OSC}9;4;2;$percent$ST';

/// Like [taskbarProgress], but shown in yellow to say it is paused.
///
/// `OSC 9;4;4`.
String taskbarPaused(int percent) => '${OSC}9;4;4;$percent$ST';

/// Pops up a desktop notification with [message].
///
/// `OSC 9`. Supported by iTerm2, WezTerm, kitty, ghostty and a few others;
/// the rest ignore it. Windows Terminal reads `OSC 9` as other commands, so
/// don't rely on this there.
String notify(String message) => '${OSC}9;$message$ST';

/// Copies [text] to the user's clipboard.
///
/// `OSC 52`. The text is sent as base64. Supported by Windows Terminal,
/// iTerm2, kitty, WezTerm and others; some ask the user first or turn it off
/// by default for safety.
String copyToClipboard(String text) {
  return '${OSC}52;c;${base64Encode(utf8.encode(text))}$ST';
}
