// Adapted from terminice (MIT), https://github.com/jozzdart/terminice
import 'dart:io';

/// The keyboard and screen that prompts and widgets talk to.
///
/// Everything interactive reads keys and writes output through
/// [Terminal.current], which is the real console by default. Swap it for a
/// fake one (like `MockTerminal` from `package:cmdline/testing.dart`) to drive
/// prompts from tests.
///
/// {@category cli}
abstract class Terminal {
  /// Creates a terminal.
  const Terminal();

  /// The terminal used by every prompt and widget.
  static Terminal current = const StdTerminal();

  /// Runs [body] with [terminal] as [current], then puts the old one back.
  static T use<T>(Terminal terminal, T Function() body) {
    final previous = current;
    current = terminal;
    try {
      return body();
    } finally {
      current = previous;
    }
  }

  /// Whether keys come from a person at a keyboard (not a pipe or file).
  bool get hasInput;

  /// Whether output goes to a screen (not a pipe or file).
  bool get hasOutput;

  /// Whether the screen understands escape codes for moving the cursor.
  bool get supportsAnsi;

  /// How many columns wide the screen is.
  int get columns;

  /// How many rows tall the screen is.
  int get rows;

  /// Whether typed keys are shown on screen by the terminal itself.
  bool get echoMode;

  set echoMode(bool value);

  /// Whether input arrives a whole line at a time, after Enter.
  bool get lineMode;

  set lineMode(bool value);

  /// Reads one byte of input, waiting for it. Gives back -1 at the end.
  int readByte();

  /// Reads one line of input, waiting for Enter. Gives back null at the end.
  String? readLine();

  /// Writes [text] to the screen as it is.
  void write(String text);
}

/// The real console: `stdin` and `stdout`.
///
/// {@category cli}
class StdTerminal extends Terminal {
  /// The width used when the size can't be read.
  static const int fallbackColumns = 80;

  /// The height used when the size can't be read.
  static const int fallbackRows = 24;

  /// Creates the console terminal.
  const StdTerminal();

  @override
  bool get hasInput => _safe(() => stdin.hasTerminal, false);

  @override
  bool get hasOutput => _safe(() => stdout.hasTerminal, false);

  @override
  bool get supportsAnsi => hasOutput && _safe(() => stdout.supportsAnsiEscapes, false);

  @override
  int get columns =>
      hasOutput ? _safe(() => stdout.terminalColumns, fallbackColumns) : fallbackColumns;

  @override
  int get rows =>
      hasOutput ? _safe(() => stdout.terminalLines, fallbackRows) : fallbackRows;

  @override
  bool get echoMode => _safe(() => stdin.echoMode, true);

  @override
  set echoMode(bool value) => _safe(() => stdin.echoMode = value, null);

  @override
  bool get lineMode => _safe(() => stdin.lineMode, true);

  @override
  set lineMode(bool value) => _safe(() => stdin.lineMode = value, null);

  @override
  int readByte() => stdin.readByteSync();

  @override
  String? readLine() => stdin.readLineSync();

  @override
  void write(String text) => stdout.write(text);

  /// The result of [read], or [fallback] if it throws (no console attached).
  static T _safe<T>(T Function() read, T fallback) {
    try {
      return read();
    } catch (_) {
      return fallback;
    }
  }
}
