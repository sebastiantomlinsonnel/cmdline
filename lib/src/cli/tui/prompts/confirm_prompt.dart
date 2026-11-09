// Adapted from terminice (MIT), https://github.com/jozzdart/terminice
import '../../../../cmdline.dart';

/// A yes or no question, picked with the arrows or the y and n keys.
///
/// {@category cli}
class ConfirmPrompt extends PromptView<bool> {
  /// Picked at the start, or null for neither.
  final bool? defaultValue;

  /// The label for yes.
  final String yes;

  /// The label for no.
  final String no;

  bool? _choice;

  /// Creates a yes or no question.
  ConfirmPrompt(
    super.question, {
    this.defaultValue,
    this.yes = 'Yes',
    this.no = 'No',
  }) : _choice = defaultValue;

  String _option(String label, {required bool picked}) => picked
      ? '${theme.pointer} $label'.bold.foreground(theme.highlight)
      : muted('${' ' * theme.pointer.width} $label');

  @override
  String inline() =>
      '${_option(yes, picked: _choice == true)}  ${_option(no, picked: _choice == false)}';

  @override
  List<KeyHint> get keys => const [
    ('←→', 'choose'),
    ('y/n', 'answer'),
    ('enter', 'submit'),
  ];

  @override
  KeyResult onKey(KeyPress press) {
    final letter = press.char.toLowerCase();
    if (press.key == Key.char && (letter == 'y' || letter == 'n')) {
      _choice = letter == 'y';

      return KeyResult.done;
    }
    switch (press.key) {
      case Key.left || Key.right || Key.tab || Key.up || Key.down:
        _choice = _choice == null ? press.key != Key.right : !_choice!;

        return KeyResult.handled;
      case Key.enter when _choice == null:
        error = 'Pick ${yes.toLowerCase()} or ${no.toLowerCase()}';

        return KeyResult.handled;
      case Key.enter:
        return KeyResult.done;
      default:
        return KeyResult.ignored;
    }
  }

  @override
  bool get result => _choice ?? false;

  @override
  String describe(bool value) => value ? yes : no;

  @override
  String get fallbackHint => switch (defaultValue) {
    true => '[Y/n]',
    false => '[y/N]',
    null => '[y/n]',
  };

  @override
  ({bool? value, String? problem}) parse(String typed) {
    final answer = switch (typed.toLowerCase()) {
      'y' || 'yes' => true,
      'n' || 'no' => false,
      '' => defaultValue,
      _ => null,
    };

    return (value: answer, problem: answer == null ? 'Please type y or n' : null);
  }

  @override
  bool? get unattended => defaultValue;
}
