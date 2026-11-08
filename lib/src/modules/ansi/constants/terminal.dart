import 'dart:convert';

import 'package:cmdline/cmdline.dart';

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

/// Shows a busy animation on the tab and taskbar, for unknown progress.
///
/// `OSC 9;4;3`. Supported by Windows Terminal and ConEmu.
const String TASKBAR_BUSY = '${OSC}9;4;3;0$ST';

/// Removes the progress from the tab and taskbar.
///
/// `OSC 9;4;0`.
const String TASKBAR_CLEAR = '${OSC}9;4;0;0$ST';

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
String copyToClipboard(String text) =>
    '${OSC}52;c;${base64Encode(utf8.encode(text))}$ST';
