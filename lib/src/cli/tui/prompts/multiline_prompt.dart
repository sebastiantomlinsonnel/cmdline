// Adapted from terminice (MIT), https://github.com/jozzdart/terminice
import 'dart:math' as math;

import '../../../../cmdline.dart';

/// A text box for several lines, like a commit message.
///
/// Enter starts a new line, the arrows move around, and Ctrl+D finishes.
/// In line mode, the answer ends at the first empty line.
///
/// {@category cli}
class MultilinePrompt extends PromptView<String> {
  /// The text in the box at the start.
  final String defaultValue;

  /// Whether an empty answer is refused.
  final bool required;

  final List<TextBuffer> _lines;
  int _row;

  /// Creates a multi-line box asking [question].
  MultilinePrompt(
    super.question, {
    this.defaultValue = '',
    this.required = false,
  }) : _lines = [for (final line in defaultValue.split('\n')) TextBuffer(line)],
       _row = defaultValue.split('\n').length - 1;

  String get _gutter => muted('${theme.box.vertical} ');

  @override
  String inline() => muted('(ctrl+d to finish)');

  @override
  List<String> body() => [for (final line in _lines) '$_gutter${line.text}'];

  @override
  CursorSpot? get bodyCursor =>
      (line: _row, column: _gutter.width + _lines[_row].beforeCursor.width);

  @override
  List<KeyHint> get keys => const [
    ('enter', 'new line'),
    ('ctrl+d', 'finish'),
    ('esc', 'cancel'),
  ];

  @override
  KeyResult onKey(KeyPress press) {
    final line = _lines[_row];
    switch (press.key) {
      case Key.ctrl when press.char == 'd':
        if (required && result.trim().isEmpty) {
          error = 'An answer is needed';

          return KeyResult.handled;
        }

        return KeyResult.done;
      case Key.enter:
        final rest = line.afterCursor;
        line.text = line.beforeCursor;
        _lines.insert(
          ++_row,
          TextBuffer(rest)..handle(const KeyPress(Key.home)),
        );
      case Key.backspace when line.cursor == 0 && _row > 0:
        final above = _lines[--_row];
        final join = graphemes(above.text).length;
        above.text = '${above.text}${line.text}';
        _lines.removeAt(_row + 1);
        _moveTo(above, join);
      case Key.delete when line.afterCursor.isEmpty && _row < _lines.length - 1:
        final cursor = line.cursor;
        line.text = '${line.text}${_lines.removeAt(_row + 1).text}';
        _moveTo(line, cursor);
      case Key.up when _row > 0:
        _row--;
        _moveTo(
          _lines[_row],
          math.min(line.cursor, graphemes(_lines[_row].text).length),
        );
      case Key.down when _row < _lines.length - 1:
        _row++;
        _moveTo(
          _lines[_row],
          math.min(line.cursor, graphemes(_lines[_row].text).length),
        );
      default:
        return line.handle(press) ? KeyResult.handled : KeyResult.ignored;
    }

    return KeyResult.handled;
  }

  /// Puts [buffer]'s cursor [at] characters from the start.
  static void _moveTo(TextBuffer buffer, int at) {
    buffer.handle(const KeyPress(Key.home));
    for (var i = 0; i < at; i++) {
      buffer.handle(const KeyPress(Key.right));
    }
  }

  @override
  String get result => _lines.map((line) => line.text).join('\n');

  @override
  String describe(String value) {
    final count = value.isEmpty ? 0 : value.split('\n').length;

    return count <= 1 ? value : '${value.split('\n').first}… ($count lines)';
  }

  @override
  String fallback() {
    PromptRunner.say(
      '${theme.glyphs.question.foreground(theme.hint)} '
      '${question.bold.foreground(theme.question)} '
      '${muted('(end with an empty line)')}',
    );
    final terminal = Terminal.current;
    while (true) {
      final lines = <String>[];
      var ended = false;
      while (true) {
        final line = terminal.readLine();
        if (line == null) ended = true;
        if (line == null || line.isEmpty) break;
        // Piped input isn't echoed, so show what was read.
        if (!terminal.hasInput)
          terminal.write(
            '${AnsiTheme.paint(muted('${theme.box.vertical} '))}$line\n',
          );
        lines.add(line);
      }
      final text = lines.isEmpty ? defaultValue : lines.join('\n');
      if (!required || text.trim().isNotEmpty) return text;
      if (ended) throw PromptCancelled(question, 'input ended');
      PromptRunner.say(theme.errorLine('An answer is needed'));
    }
  }

  @override
  String? get unattended =>
      required && defaultValue.trim().isEmpty ? null : defaultValue;
}
