// Adapted from terminice (MIT), https://github.com/jozzdart/terminice
import '../../../../cmdline.dart';

/// A list of on/off switches, like settings.
///
/// Space flips the highlighted switch, right turns it on and left turns it
/// off, and `a` flips them all. Enter finishes. Works like
/// [MultiSelectPrompt] with switches drawn instead of checkboxes.
///
/// {@category cli}
class TogglePrompt extends MultiSelectPrompt<String> {
  /// Creates switches for [names], with the names in [on] switched on.
  TogglePrompt(super.question, super.options, {super.note, Set<int>? on})
    : super(ticked: on);

  @override
  String row(int index) {
    final on = ticked.contains(index);
    final glyphs = theme.glyphs;
    final state = on
        ? glyphs.toggleOn.foreground(theme.checked)
        : muted(glyphs.toggleOff);
    final note = notes[index];
    final label = note.isEmpty
        ? labels[index]
        : '${labels[index]}  ${muted(note)}';

    return '$state  $label';
  }

  @override
  String inline() => muted('${ticked.length} of ${options.length} on');

  @override
  List<KeyHint> get keys => const [
    ('↑↓', 'move'),
    ('space ←→', 'switch'),
    ('enter', 'done'),
    ('esc', 'cancel'),
  ];

  @override
  KeyResult onKey(KeyPress press) {
    switch (press.key) {
      case Key.right:
        ticked.add(cursor.index);

        return KeyResult.handled;
      case Key.left:
        ticked.remove(cursor.index);

        return KeyResult.handled;
      default:
        return super.onKey(press);
    }
  }

  @override
  String describe(List<String> value) =>
      value.isEmpty ? 'all off' : '${value.join(', ')} on';
}
