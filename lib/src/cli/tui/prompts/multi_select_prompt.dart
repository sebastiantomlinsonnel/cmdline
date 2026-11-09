import '../../../../cmdline.dart';

/// Tick any number of options from a list.
///
/// Space ticks or unticks the highlighted option and `a` ticks or unticks
/// them all. Enter finishes, as long as the count is between [min] and
/// [max].
///
/// {@category cli}
class MultiSelectPrompt<T> extends ListPrompt<T, List<T>> {
  /// The fewest options that must be ticked.
  final int min;

  /// The most options that may be ticked, or null for no limit.
  final int? max;

  /// The indexes of the ticked options.
  final Set<int> ticked;

  /// Creates a checklist asking [question], with [ticked] options ticked at
  /// the start. See [ListPrompt] for the other options.
  MultiSelectPrompt(
    super.question,
    super.options, {
    super.format,
    super.note,
    super.pageSize,
    Set<int>? ticked,
    this.min = 0,
    this.max,
  }) : ticked = {...?ticked};

  @override
  String row(int index) {
    final on = ticked.contains(index);
    final box = on
        ? theme.glyphs.checked.foreground(theme.checked)
        : muted(theme.glyphs.unchecked);

    return '$box ${super.row(index)}';
  }

  @override
  String inline() => muted('${ticked.length} picked');

  @override
  List<KeyHint> get keys => const [
    ('↑↓', 'move'),
    ('space', 'tick'),
    ('a', 'all'),
    ('enter', 'done'),
    ('esc', 'cancel'),
  ];

  @override
  KeyResult onKey(KeyPress press) {
    switch (press.key) {
      case Key.space:
        final index = cursor.index;
        if (!ticked.remove(index)) {
          if (max != null && ticked.length >= max!) {
            error = 'Pick at most $max';
          } else {
            ticked.add(index);
          }
        }

        return KeyResult.handled;
      case Key.char when press.char == 'a':
        if (ticked.length == options.length) {
          ticked.clear();
        } else if (max == null || options.length <= max!) {
          ticked.addAll(List.generate(options.length, (i) => i));
        } else {
          error = 'Pick at most $max';
        }

        return KeyResult.handled;
      case Key.enter:
        final problem = _problem(ticked.length);
        if (problem != null) {
          error = problem;

          return KeyResult.handled;
        }

        return KeyResult.done;
      default:
        return navigate(press) ? KeyResult.handled : KeyResult.ignored;
    }
  }

  String? _problem(int count) {
    if (count < min) return 'Pick at least $min';
    if (max != null && count > max!) return 'Pick at most $max';

    return null;
  }

  @override
  List<T> get result => [
    for (var i = 0; i < options.length; i++)
      if (ticked.contains(i)) options[i],
  ];

  @override
  String describe(List<T> value) => value.isEmpty
      ? 'none'
      : [for (final option in value) labels[options.indexOf(option)].plain]
            .join(', ');

  @override
  List<T> fallback() {
    PromptRunner.say(
      '${theme.glyphs.question.foreground(theme.hint)} '
      '${question.bold.foreground(theme.question)}',
    );
    printNumbered();
    final start = (ticked.toList()..sort()).map((i) => '${i + 1}').join(',');

    return PromptLine.run<List<T>>(
      'Numbers',
      hint: start.isEmpty ? '(like 1,3-5)' : '($start)',
      shown: describe,
      check: (typed) {
        final picked = _parseNumbers(typed.isEmpty ? start : typed);
        if (picked == null) {
          return (
            value: null,
            problem: 'Type numbers from 1 to ${options.length}, like 1,3-5',
          );
        }
        final problem = _problem(picked.length);

        return (
          value: problem == null ? [for (final i in picked) options[i]] : null,
          problem: problem,
        );
      },
    );
  }

  /// Reads `1,3-5` style input into sorted indexes, or null if it's wrong.
  List<int>? _parseNumbers(String typed) {
    final picked = <int>{};
    for (final part
        in typed.split(RegExp(r'[,\s]+')).where((p) => p.isNotEmpty)) {
      final ends = part.split('-');
      final from = int.tryParse(ends.first);
      final to = int.tryParse(ends.last);
      if (from == null || to == null || ends.length > 2) return null;
      for (var n = from; n <= to; n++) {
        if (n < 1 || n > options.length) return null;
        picked.add(n - 1);
      }
    }

    return picked.toList()..sort();
  }

  @override
  List<T>? get unattended => _problem(ticked.length) == null ? result : null;
}
