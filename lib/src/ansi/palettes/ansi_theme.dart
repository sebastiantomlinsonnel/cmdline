import 'dart:io';

import 'package:cmdline/cmdline.dart';

/// The colours and symbols shared by prompts, menus, tables and file helpers.
///
/// Everything in `lib/src/cli` reads [AnsiTheme.current], so swapping it
/// changes the look of the whole toolkit at once:
///
/// ```dart
/// AnsiTheme.current = const AnsiTheme(
///   question: AnsiColour(13),
///   box: BoxChars.doubleLine,
/// );
///
/// // Or change just a few things:
/// AnsiTheme.current = AnsiTheme.current.copyWith(glyphs: PromptGlyphs.ascii);
/// ```
///
/// Prompts and widgets also use [glyphs] for their symbols, and show a dim
/// line of key hints when [showKeys] is on.
///
/// Use [paint] or [say] to print styled text, so colour is dropped when the
/// terminal can't show it or the user set `NO_COLOR`.
///
/// {@category ansi}
class AnsiTheme {
  /// The colour of questions in prompts like `Prompts.ask`.
  final AnsiInk question;

  /// The colour of the user's answer after it is picked.
  final AnsiInk answer;

  /// The colour of hints like default values and `[Y/n]`.
  final AnsiInk hint;

  /// The colour of error lines.
  final AnsiInk error;

  /// The colour of success lines.
  final AnsiInk success;

  /// The colour of the highlighted row in lists and menus.
  final AnsiInk highlight;

  /// The colour of ticked items, like checked boxes and switches that are on.
  final AnsiInk checked;

  /// The colour of keys in the key hints, like `enter` and `esc`.
  final AnsiInk key;

  /// The colour of information, like notes and info messages.
  final AnsiInk info;

  /// The colour of warnings.
  final AnsiInk warn;

  /// The colour of things that are there but not important, like empty
  /// checkboxes, scroll arrows and disabled options.
  final AnsiInk muted;

  /// The colour of box and table lines.
  final AnsiInk border;

  /// The line characters for boxes, tables and trees.
  final BoxChars box;

  /// The symbol in front of the highlighted row in lists and menus.
  final String pointer;

  /// The symbol in front of success lines.
  final String tick;

  /// The symbol in front of error lines.
  final String cross;

  /// The other symbols used by prompts and widgets.
  final PromptGlyphs glyphs;

  /// Whether prompts show a dim line of key hints, like `↑↓ move`.
  final bool showKeys;

  /// The theme used by every helper. Swap it to restyle everything.
  static AnsiTheme current = const AnsiTheme();

  static bool? _useColour;

  /// Creates a theme. Anything left out keeps its default.
  const AnsiTheme({
    this.question = const AnsiColour(14),
    this.answer = const AnsiColour(10),
    this.hint = const AnsiColour.grey(12),
    this.error = const AnsiColour(9),
    this.success = const AnsiColour(10),
    this.highlight = const AnsiColour(14),
    this.checked = const AnsiColour(10),
    this.key = const AnsiColour(14),
    this.info = const AnsiColour(12),
    this.warn = const AnsiColour(11),
    this.muted = const AnsiColour.grey(8),
    this.border = const AnsiColour.grey(10),
    this.box = BoxChars.rounded,
    this.pointer = ARROW,
    this.tick = TICK,
    this.cross = CROSS,
    this.glyphs = PromptGlyphs.unicode,
    this.showKeys = true,
  });

  /// A copy of this theme with some parts swapped.
  AnsiTheme copyWith({
    AnsiInk? question,
    AnsiInk? answer,
    AnsiInk? hint,
    AnsiInk? error,
    AnsiInk? success,
    AnsiInk? highlight,
    AnsiInk? checked,
    AnsiInk? key,
    AnsiInk? info,
    AnsiInk? warn,
    AnsiInk? muted,
    AnsiInk? border,
    BoxChars? box,
    String? pointer,
    String? tick,
    String? cross,
    PromptGlyphs? glyphs,
    bool? showKeys,
  }) => AnsiTheme(
    question: question ?? this.question,
    answer: answer ?? this.answer,
    hint: hint ?? this.hint,
    error: error ?? this.error,
    success: success ?? this.success,
    highlight: highlight ?? this.highlight,
    checked: checked ?? this.checked,
    key: key ?? this.key,
    info: info ?? this.info,
    warn: warn ?? this.warn,
    muted: muted ?? this.muted,
    border: border ?? this.border,
    box: box ?? this.box,
    pointer: pointer ?? this.pointer,
    tick: tick ?? this.tick,
    cross: cross ?? this.cross,
    glyphs: glyphs ?? this.glyphs,
    showKeys: showKeys ?? this.showKeys,
  );

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
  /// With colour on, a [RESET] always closes the line.
  static void say(String text) {
    if (useColour) {
      stdout.writeln('${Ansi(text)}$RESET');
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
