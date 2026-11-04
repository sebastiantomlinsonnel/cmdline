import 'dart:io';

import 'package:cmdline/cmdline.dart';

/// The colours and symbols shared by prompts, menus, tables and file helpers.
///
/// Everything in `lib/src/cli` reads [CliTheme.current], so swapping it
/// changes the look of the whole toolkit at once:
///
/// ```dart
/// CliTheme.current = const CliTheme(
///   question: AsciiColour(13),
///   box: BoxChars.doubleLine,
/// );
/// ```
///
/// Use [paint] or [say] to print styled text, so colour is dropped when the
/// terminal can't show it or the user set `NO_COLOR`.
class CliTheme {
  /// The colour of questions in [ask], [confirm] and [menu].
  final AsciiInk question;

  /// The colour of the user's answer after it is picked.
  final AsciiInk answer;

  /// The colour of hints like default values and `[Y/n]`.
  final AsciiInk hint;

  /// The colour of error lines.
  final AsciiInk error;

  /// The colour of success lines.
  final AsciiInk success;

  /// The colour of the picked row in a [menu].
  final AsciiInk highlight;

  /// The colour of box and table lines.
  final AsciiInk border;

  /// The line characters for boxes, tables and trees.
  final BoxChars box;

  /// The symbol in front of the picked [menu] row.
  final String pointer;

  /// The symbol in front of success lines.
  final String tick;

  /// The symbol in front of error lines.
  final String cross;

  /// The theme used by every helper. Swap it to restyle everything.
  static CliTheme current = const CliTheme();

  static bool? _useColour;

  /// Creates a theme. Anything left out keeps its default.
  const CliTheme({
    this.question = const AsciiColour(14),
    this.answer = const AsciiColour(10),
    this.hint = const AsciiColour.grey(12),
    this.error = const AsciiColour(9),
    this.success = const AsciiColour(10),
    this.highlight = const AsciiColour(14),
    this.border = const AsciiColour.grey(10),
    this.box = BoxChars.rounded,
    this.pointer = ARROW,
    this.tick = TICK,
    this.cross = CROSS,
  });

  /// Whether helpers print colours and styles.
  ///
  /// Worked out the first time it is read: off when the `NO_COLOR` variable
  /// is set or the output can't show escape codes (for example when piped to
  /// a file). Set it yourself to force it either way.
  static bool get useColour => _useColour ??= _detectColour();

  static set useColour(bool value) => _useColour = value;

  /// [text] as it should be printed: unchanged with colour, plain without.
  static String paint(String text) => useColour ? text : text.plain;

  /// Prints [text] on its own line, dropping the colour if it is turned off.
  ///
  /// With colour on it goes through [Ansi.output], so a [RESET] always
  /// closes the line.
  static void say(String text) {
    if (useColour) {
      Ansi(text).output();
    } else {
      stdout.writeln(text.plain);
    }
  }

  /// Prints [text] without a line break, dropping the colour if it is off.
  ///
  /// For prompts and redraws, where the cursor must stay on the line.
  static void write(String text) => stdout.write(paint(text));

  /// [message] as an error line: the [cross] symbol and text in [error].
  String errorLine(String message) => '$cross $message'.foreground(error);

  /// [message] as a success line: the [tick] symbol and text in [success].
  String successLine(String message) => '$tick $message'.foreground(success);

  /// Checks `NO_COLOR` and whether stdout understands escape codes.
  static bool _detectColour() {
    if ((Platform.environment['NO_COLOR'] ?? '').isNotEmpty) return false;
    try {
      return stdout.supportsAnsiEscapes;
    } catch (_) {
      return false;
    }
  }
}
