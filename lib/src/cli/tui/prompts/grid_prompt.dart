// Adapted from terminice (MIT), https://github.com/jozzdart/terminice
import 'dart:math' as math;

import '../../../../cmdline.dart';

/// Pick one option from a grid, moving in all four directions.
///
/// Good for short options like sizes, emoji or regions. Columns fit the
/// screen unless [columns] is given.
///
/// {@category cli}
class GridPrompt<T> extends PromptView<T> {
  /// The options in the grid, row by row.
  final List<T> options;

  /// The text shown for each option.
  final List<String> labels;

  /// Whether [PromptMode.unattended] may take the starting option.
  final bool hasDefault;

  late final int _columns;
  late final int _cell;
  int _index;

  /// Creates a grid asking [question].
  GridPrompt(
    super.question,
    this.options, {
    String Function(T option)? format,
    int? columns,
    int start = 0,
    this.hasDefault = false,
  }) : labels = [for (final option in options) format?.call(option) ?? '$option'],
       _index = start {
    if (options.isEmpty) throw ArgumentError.value(options, 'options', 'Empty');
    _cell = labels.map((label) => label.width).fold(0, math.max) + 2;
    final fit = math.max((Terminal.current.columns - 2) ~/ (_cell + theme.pointer.width), 1);
    _columns = math.max(math.min(columns ?? fit, options.length), 1);
  }

  int get _rows => (options.length + _columns - 1) ~/ _columns;

  @override
  List<String> body() => [
    for (var row = 0; row < _rows; row++)
      [
        for (var column = 0; column < _columns; column++)
          if (row * _columns + column < options.length)
            _cellText(row * _columns + column),
      ].join(),
  ];

  String _cellText(int index) {
    final label = labels[index].padWidth(_cell);

    return index == _index ? pointed(label) : unpointed(label);
  }

  @override
  List<KeyHint> get keys => const [
    ('←↑↓→', 'move'),
    ('enter', 'pick'),
    ('esc', 'cancel'),
  ];

  @override
  KeyResult onKey(KeyPress press) {
    final count = options.length;
    switch (press.key) {
      case Key.left:
        _index = (_index - 1) % count;
      case Key.right || Key.tab:
        _index = (_index + 1) % count;
      case Key.up:
        _index = _index - _columns < 0 ? _index : _index - _columns;
      case Key.down:
        _index = _index + _columns >= count ? _index : _index + _columns;
      case Key.home:
        _index = 0;
      case Key.end:
        _index = count - 1;
      case Key.enter:
        return KeyResult.done;
      default:
        return KeyResult.ignored;
    }

    return KeyResult.handled;
  }

  @override
  T get result => options[_index];

  @override
  String describe(T value) => labels[options.indexOf(value)].plain;

  @override
  T fallback() => SelectPrompt<T>(
    question,
    options,
    format: (option) => labels[options.indexOf(option)],
    start: _index,
  ).fallback();

  @override
  T? get unattended => hasDefault ? options[_index] : null;
}
