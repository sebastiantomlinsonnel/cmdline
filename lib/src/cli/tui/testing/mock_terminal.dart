// Adapted from terminice (MIT), https://github.com/jozzdart/terminice
import 'dart:convert';

import '../../../../cmdline.dart';

/// A pretend terminal for tests: scripted keys in, captured output out.
///
/// Queue up what the "user" types with [type], [press] and [line], then run
/// prompts inside [run]. Everything they draw lands in [output], and
/// [screen] replays it to show what the user would see at the end.
///
/// ```dart
/// final terminal = MockTerminal()
///   ..press(Key.down)
///   ..press(Key.enter);
/// final colour = terminal.run(() => Prompts.menu('Colour', ['Red', 'Blue']));
/// expect(colour, 'Blue');
/// expect(terminal.screen.last, contains('Blue'));
/// ```
///
/// {@category cli}
class MockTerminal extends Terminal {
  final List<int> _bytes = [];
  final List<String?> _lines = [];
  final StringBuffer _output = StringBuffer();

  @override
  bool hasInput;

  @override
  bool hasOutput;

  @override
  bool supportsAnsi;

  @override
  int columns;

  @override
  int rows;

  @override
  bool echoMode = true;

  @override
  bool lineMode = true;

  /// Creates a terminal [columns] wide and [rows] tall.
  ///
  /// Set [interactive] to false to act like piped input, so prompts ask in
  /// [PromptMode.line] and read the queued [line]s.
  MockTerminal({this.columns = 80, this.rows = 24, bool interactive = true})
    : hasInput = interactive,
      hasOutput = interactive,
      supportsAnsi = interactive;

  /// Everything written so far, escape codes and all.
  String get output => _output.toString();

  /// Queues [text] as typed characters.
  void type(String text) => _bytes.addAll(utf8.encode(text));

  /// Queues a special key, like [Key.down] or [Key.enter].
  void press(Key key, {int times = 1}) {
    final bytes = switch (key) {
      Key.enter => [13],
      Key.escape => [27, 27],
      Key.tab => [9],
      Key.backTab => utf8.encode('\x1B[Z'),
      Key.backspace => [127],
      Key.delete => utf8.encode('\x1B[3~'),
      Key.insert => utf8.encode('\x1B[2~'),
      Key.up => utf8.encode('\x1B[A'),
      Key.down => utf8.encode('\x1B[B'),
      Key.right => utf8.encode('\x1B[C'),
      Key.left => utf8.encode('\x1B[D'),
      Key.home => utf8.encode('\x1B[H'),
      Key.end => utf8.encode('\x1B[F'),
      Key.pageUp => utf8.encode('\x1B[5~'),
      Key.pageDown => utf8.encode('\x1B[6~'),
      Key.space => [32],
      Key.interrupt => [3],
      Key.endOfInput || Key.char || Key.ctrl || Key.unknown =>
        throw ArgumentError.value(key, 'key', 'Use type() or ctrl()'),
    };
    for (var i = 0; i < times; i++) {
      _bytes.addAll(bytes);
    }
  }

  /// Queues Ctrl and [letter], like `ctrl('d')`.
  void ctrl(String letter) => _bytes.add(letter.codeUnitAt(0) - 96);

  /// Queues raw input bytes, for escape sequences [press] doesn't cover.
  void bytes(List<int> bytes) => _bytes.addAll(bytes);

  /// Queues a whole typed line, for prompts in [PromptMode.line].
  void line(String text) => _lines.add(text);

  /// Runs [body] with this as [Terminal.current] and the prompt mode
  /// worked out from it.
  T run<T>(T Function() body) {
    final previous = PromptMode.forced;
    PromptMode.current = interactive ? PromptMode.rich : PromptMode.line;
    try {
      return Terminal.use(this, body);
    } finally {
      PromptMode.current = previous;
    }
  }

  /// Whether this acts like a real keyboard and screen.
  bool get interactive => hasInput && supportsAnsi;

  @override
  int readByte() => _bytes.isEmpty ? -1 : _bytes.removeAt(0);

  @override
  String? readLine() {
    if (_lines.isNotEmpty) return _lines.removeAt(0);
    if (_bytes.isEmpty) return null;
    // Fall back to typed bytes up to Enter.
    final end = _bytes.indexOf(13);
    final taken = end < 0 ? List.of(_bytes) : _bytes.sublist(0, end);
    _bytes.removeRange(0, end < 0 ? _bytes.length : end + 1);

    return utf8.decode(taken);
  }

  @override
  void write(String text) => _output.write(text);

  /// Forgets the captured output.
  void clearOutput() => _output.clear();

  /// The screen as the user would see it now, one string per row.
  ///
  /// Replays [output] onto a grid [columns] wide, following the cursor
  /// moves and clears that prompts use. Styles are dropped.
  List<String> get screen => ScreenReplay(columns).play(output);
}

/// Replays terminal output onto a grid of plain text rows.
///
/// Understands the cursor moves and clears that prompts and widgets use:
/// up, down, left, right, to column, carriage return, line feed, clear line
/// and clear to end of screen. Other codes are skipped.
///
/// {@category cli}
class ScreenReplay {
  /// How many columns wide the screen is.
  final int columns;

  final List<List<String>> _rows = [[]];
  int _row = 0;
  int _column = 0;

  /// Creates a replay [columns] wide.
  ScreenReplay(this.columns);

  /// Replays [output] and gives back the rows, without trailing spaces.
  List<String> play(String output) {
    final codes = RegExp(
      r'\x1B\[([0-9;?]*)([A-Za-z])|\x1B\][^\x07\x1B]*(?:\x07|\x1B\\)|\x1B.',
    );
    var at = 0;
    for (final match in codes.allMatches(output)) {
      _text(output.substring(at, match.start));
      _code(match.group(1) ?? '', match.group(2) ?? '');
      at = match.end;
    }
    _text(output.substring(at));
    final rows = [for (final row in _rows) row.join().trimRight()];
    while (rows.isNotEmpty && rows.last.isEmpty) {
      rows.removeLast();
    }

    return rows;
  }

  void _text(String text) {
    for (final char in graphemes(text)) {
      if (char == '\n' || char == '\r\n') {
        _row++;
        _column = 0;
        _ensureRow();
      } else if (char == '\r') {
        _column = 0;
      } else {
        if (_column >= columns) {
          _row++;
          _column = 0;
          _ensureRow();
        }
        final row = _rows[_row];
        while (row.length <= _column) {
          row.add(' ');
        }
        row[_column] = char;
        _column += graphemeWidth(char).clamp(1, 2);
      }
    }
  }

  void _code(String params, String letter) {
    final n = int.tryParse(params.split(';').first) ?? 1;
    switch (letter) {
      case 'A':
        _row = (_row - n).clamp(0, _rows.length - 1);
      case 'B':
        _row += n;
        _ensureRow();
      case 'C':
        _column += n;
      case 'D':
        _column = (_column - n).clamp(0, columns);
      case 'G':
        _column = n - 1;
      case 'K':
        if (params == '2') {
          _rows[_row] = [];
        } else {
          final row = _rows[_row];
          if (row.length > _column) row.removeRange(_column, row.length);
        }
      case 'J':
        final row = _rows[_row];
        if (row.length > _column) row.removeRange(_column, row.length);
        _rows.removeRange(_row + 1, _rows.length);
    }
  }

  void _ensureRow() {
    while (_rows.length <= _row) {
      _rows.add([]);
    }
  }
}
