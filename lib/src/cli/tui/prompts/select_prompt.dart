// Adapted from terminice (MIT), https://github.com/jozzdart/terminice
import '../../../../cmdline.dart';

/// Pick one option from a list.
///
/// {@category cli}
class SelectPrompt<T> extends ListPrompt<T, T> {
  /// Whether [PromptMode.unattended] may take the starting option.
  final bool hasDefault;

  /// Creates a list asking [question]. See [ListPrompt] for the options.
  SelectPrompt(
    super.question,
    super.options, {
    super.format,
    super.note,
    super.start,
    super.pageSize,
    this.hasDefault = false,
  });

  @override
  List<KeyHint> get keys => const [
    ('↑↓', 'move'),
    ('enter', 'pick'),
    ('esc', 'cancel'),
  ];

  @override
  KeyResult onKey(KeyPress press) {
    if (press.key == Key.enter) return KeyResult.done;

    return navigate(press) ? KeyResult.handled : KeyResult.ignored;
  }

  @override
  T get result => options[cursor.index];

  @override
  String describe(T value) {
    final index = options[cursor.index] == value
        ? cursor.index
        : options.indexOf(value);

    return labels[index].plain;
  }

  @override
  T fallback() {
    PromptRunner.say(
      '${theme.glyphs.question.foreground(theme.hint)} '
      '${question.bold.foreground(theme.question)}',
    );
    printNumbered();
    final start = cursor.index;
    final index = PromptLine.run<int>(
      'Number',
      hint: '(${start + 1})',
      shown: (index) => labels[index].plain,
      check: (typed) {
        if (typed.isEmpty) return (value: start, problem: null);
        final index = (int.tryParse(typed) ?? 0) - 1;
        final ok = index >= 0 && index < labels.length;

        return (
          value: ok ? index : null,
          problem: ok ? null : 'Type a number from 1 to ${labels.length}',
        );
      },
    );

    return options[index];
  }

  @override
  T? get unattended => hasDefault ? options[cursor.index] : null;
}
