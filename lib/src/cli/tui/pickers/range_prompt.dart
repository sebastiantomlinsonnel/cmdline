// Adapted from terminice (MIT), https://github.com/jozzdart/terminice
import '../../../../cmdline.dart';

/// A picked range of whole numbers, both ends included.
typedef IntRange = ({int start, int end});

/// Pick a range on a track with two handles, like a price filter.
///
/// Left and right move the active handle and Tab swaps handles.
///
/// {@category cli}
class RangePrompt extends PromptView<IntRange> {
  /// The smallest value.
  final int min;

  /// The largest value.
  final int max;

  /// How far one arrow press moves.
  final int step;

  /// How many columns wide the track is.
  final int width;

  /// Text after each value, like `%`.
  final String unit;

  /// The range at the start.
  final IntRange initial;

  int _start;
  int _end;
  bool _movingEnd = false;

  /// Creates a range slider asking [question].
  RangePrompt(
    super.question, {
    this.min = 0,
    this.max = 100,
    this.step = 1,
    this.width = 30,
    this.unit = '',
    IntRange? initial,
  }) : initial = initial ?? (start: min, end: max),
       _start = (initial?.start ?? min).clamp(min, max),
       _end = (initial?.end ?? max).clamp(min, max) {
    if (max <= min) throw ArgumentError('max must be more than min');
  }

  int _column(int value) => ((value - min) / (max - min) * (width - 1)).round();

  @override
  String inline() {
    final glyphs = theme.glyphs;
    final from = _column(_start);
    final to = _column(_end);
    final out = StringBuffer();
    for (var i = 0; i < width; i++) {
      final active = (i == to && _movingEnd) || (i == from && !_movingEnd);
      if (i == from || i == to) {
        out.write(active
            ? glyphs.knob.bold.foreground(theme.highlight)
            : glyphs.knob.foreground(theme.highlight));
      } else if (i > from && i < to) {
        out.write(glyphs.trackFill.foreground(theme.highlight));
      } else {
        out.write(muted(glyphs.trackEmpty));
      }
    }
    String value(int n, {required bool active}) =>
        active ? '$n$unit'.bold.underline : '$n$unit';

    return '$out ${value(_start, active: !_movingEnd)} – ${value(_end, active: _movingEnd)}';
  }

  @override
  List<KeyHint> get keys => const [
    ('←→', 'move'),
    ('tab', 'other end'),
    ('enter', 'pick'),
    ('esc', 'cancel'),
  ];

  @override
  KeyResult onKey(KeyPress press) {
    final delta = switch (press.key) {
      Key.left || Key.down => -step,
      Key.right || Key.up => step,
      Key.pageDown => -((max - min) / 10).ceil(),
      Key.pageUp => ((max - min) / 10).ceil(),
      _ => 0,
    };
    if (delta != 0) {
      if (_movingEnd) {
        _end = (_end + delta).clamp(_start, max);
      } else {
        _start = (_start + delta).clamp(min, _end);
      }

      return KeyResult.handled;
    }

    return switch (press.key) {
      Key.tab || Key.backTab => (_movingEnd = !_movingEnd, KeyResult.handled).$2,
      Key.enter => KeyResult.done,
      _ => KeyResult.ignored,
    };
  }

  @override
  IntRange get result => (start: _start, end: _end);

  @override
  String describe(IntRange value) => '${value.start}$unit – ${value.end}$unit';

  @override
  String get fallbackHint => '($min-$max, like ${initial.start}-${initial.end})';

  @override
  ({IntRange? value, String? problem}) parse(String typed) {
    if (typed.isEmpty) return (value: initial, problem: null);
    final match = RegExp(r'^\s*(-?\d+)\s*(?:-|–|to|\.\.)\s*(-?\d+)\s*$').firstMatch(typed);
    final from = int.tryParse(match?.group(1) ?? '');
    final to = int.tryParse(match?.group(2) ?? '');
    if (from == null || to == null || from > to || from < min || to > max) {
      return (value: null, problem: 'Type two numbers from $min to $max, like $min-$max');
    }

    return (value: (start: from, end: to), problem: null);
  }

  @override
  IntRange? get unattended => initial;
}
