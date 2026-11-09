// Adapted from terminice (MIT), https://github.com/jozzdart/terminice
import '../../../../cmdline.dart';

/// Pick a whole number on a track, like a volume.
///
/// Left and right move by [step], Page Up/Down by a tenth of the range, and
/// Home/End jump to the ends.
///
/// {@category cli}
class SliderPrompt extends PromptView<int> {
  /// The smallest value.
  final int min;

  /// The largest value.
  final int max;

  /// How far one arrow press moves.
  final int step;

  /// How many columns wide the track is.
  final int width;

  /// Text after the value, like `%`.
  final String unit;

  /// The value at the start.
  final int start;

  int _value;

  /// Creates a slider asking [question].
  SliderPrompt(
    super.question, {
    this.min = 0,
    this.max = 100,
    this.step = 1,
    this.width = 30,
    this.unit = '',
    int? start,
  }) : start = (start ?? min).clamp(min, max),
       _value = (start ?? min).clamp(min, max) {
    if (max <= min) throw ArgumentError('max must be more than min');
  }

  /// A track [width] wide with a knob at [fraction] (0 to 1).
  static String track(
    double fraction,
    int width,
    AnsiTheme theme, {
    int? from,
  }) {
    final glyphs = theme.glyphs;
    final knob = (fraction.clamp(0.0, 1.0) * (width - 1)).round();
    final start = from ?? 0;
    final out = StringBuffer();
    for (var i = 0; i < width; i++) {
      if (i == knob) {
        out.write(glyphs.knob.bold.foreground(theme.highlight));
      } else if (i >= start && i < knob) {
        out.write(glyphs.trackFill.foreground(theme.highlight));
      } else {
        out.write(glyphs.trackEmpty.foreground(theme.muted));
      }
    }

    return out.toString();
  }

  double get _fraction => (_value - min) / (max - min);

  @override
  String inline() => '${track(_fraction, width, theme)} ${'$_value$unit'.bold}';

  @override
  List<KeyHint> get keys => const [
    ('←→', 'move'),
    ('pgup/pgdn', 'jump'),
    ('enter', 'pick'),
    ('esc', 'cancel'),
  ];

  @override
  KeyResult onKey(KeyPress press) {
    final big = ((max - min) / 10).ceil();
    final moved = switch (press.key) {
      Key.left || Key.down => _value - step,
      Key.right || Key.up => _value + step,
      Key.pageDown => _value - big,
      Key.pageUp => _value + big,
      Key.home => min,
      Key.end => max,
      _ => null,
    };
    if (press.key == Key.enter) return KeyResult.done;
    if (moved == null) return KeyResult.ignored;
    _value = moved.clamp(min, max);

    return KeyResult.handled;
  }

  @override
  int get result => _value;

  @override
  String describe(int value) => '$value$unit';

  @override
  String get fallbackHint => '($min-$max, $start)';

  @override
  ({int? value, String? problem}) parse(String typed) {
    final value = typed.isEmpty ? start : int.tryParse(typed);
    if (value == null || value < min || value > max) {
      return (value: null, problem: 'Type a number from $min to $max');
    }

    return (value: value, problem: null);
  }

  @override
  int? get unattended => start;
}
