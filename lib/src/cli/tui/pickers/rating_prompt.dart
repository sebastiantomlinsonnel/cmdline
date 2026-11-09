// Adapted from terminice (MIT), https://github.com/jozzdart/terminice
import '../../../../cmdline.dart';

/// Pick a score out of [max] stars.
///
/// Left and right change it, and number keys pick a score straight away.
///
/// {@category cli}
class RatingPrompt extends PromptView<int> {
  /// The most stars.
  final int max;

  /// Words for each score, like `['Bad', 'Okay', 'Great']`, shown dim.
  final List<String> labels;

  /// The score at the start.
  final int start;

  int _value;

  /// Creates a rating asking [question].
  RatingPrompt(
    super.question, {
    this.max = 5,
    int? start,
    this.labels = const [],
  }) : start = (start ?? (max + 1) ~/ 2).clamp(1, max),
       _value = (start ?? (max + 1) ~/ 2).clamp(1, max);

  String _stars(int value) {
    final glyphs = theme.glyphs;

    return '${(glyphs.star * value).foreground(theme.warn)}'
        '${muted(glyphs.starEmpty * (max - value))}';
  }

  @override
  String inline() {
    final label = _value <= labels.length
        ? '  ${muted(labels[_value - 1])}'
        : '';

    return '${_stars(_value)} ${'$_value/$max'.bold}$label';
  }

  @override
  List<KeyHint> get keys => [
    ('←→', 'change'),
    ('1-${max < 10 ? max : 9}', 'pick'),
    ('enter', 'done'),
    ('esc', 'cancel'),
  ];

  @override
  KeyResult onKey(KeyPress press) {
    final digit = press.key == Key.char ? int.tryParse(press.char) : null;
    if (digit != null && digit >= 1 && digit <= max) {
      _value = digit;

      return KeyResult.done;
    }

    switch (press.key) {
      case Key.left || Key.down:
        _value = (_value - 1).clamp(1, max);
      case Key.right || Key.up:
        _value = (_value + 1).clamp(1, max);
      case Key.home:
        _value = 1;
      case Key.end:
        _value = max;
      case Key.enter:
        return KeyResult.done;
      default:
        return KeyResult.ignored;
    }

    return KeyResult.handled;
  }

  @override
  int get result => _value;

  @override
  String describe(int value) => '${_stars(value)} $value/$max';

  @override
  String get fallbackHint => '(1-$max, $start)';

  @override
  ({int? value, String? problem}) parse(String typed) {
    final value = typed.isEmpty ? start : int.tryParse(typed);
    if (value == null || value < 1 || value > max) {
      return (value: null, problem: 'Type a number from 1 to $max');
    }

    return (value: value, problem: null);
  }

  @override
  int? get unattended => start;
}
