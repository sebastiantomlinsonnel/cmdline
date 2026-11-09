import '../../../../cmdline.dart';

/// Turns typed text into an answer, or a problem to show.
typedef TextParser<T> = ({T? value, String? problem}) Function(String text);

/// A one-line text box: free text, passwords and numbers.
///
/// Typing edits in place with the usual keys (see [TextBuffer]). An empty
/// box shows the default dim; Enter takes it and Tab puts it in the box to
/// edit. Enter runs the parser, and a problem shows under the box without
/// closing it.
///
/// {@category cli}
class TextPrompt<T> extends PromptView<T> {
  /// Turns the typed text into the answer.
  final TextParser<T> parser;

  /// Taken when Enter is pressed on an empty box.
  final String? defaultValue;

  /// Dim text shown in an empty box when there's no default.
  final String placeholder;

  /// Shows a mask instead of each typed character, for passwords. An empty
  /// mask shows nothing at all.
  final String? mask;

  /// Changes the text for up and down, like stepping a number. Gets the
  /// current text and +1 or -1, and gives back the new text.
  final String Function(String text, int direction)? stepper;

  /// How the answer is shown once accepted.
  final String Function(T value)? shown;

  final TextBuffer _buffer = TextBuffer();
  T? _result;

  /// Creates a text box asking [question].
  TextPrompt(
    super.question, {
    required this.parser,
    this.defaultValue,
    this.placeholder = '',
    this.mask,
    this.stepper,
    this.shown,
  });

  String _display(String text) {
    final mask = this.mask;
    if (mask == null) return text;

    return mask * graphemes(text).length;
  }

  @override
  String inline() {
    if (_buffer.isEmpty) {
      final ghost = defaultValue ?? placeholder;

      return ghost.isEmpty || mask != null ? '' : muted(ghost);
    }

    return _display(_buffer.text);
  }

  @override
  int? get inlineCursor => _display(_buffer.beforeCursor).width;

  @override
  List<KeyHint> get keys => [
    ('enter', 'submit'),
    if (stepper != null) ('↑↓', 'change'),
    if (defaultValue != null && mask == null && _buffer.isEmpty)
      ('tab', 'edit default'),
    ('esc', 'cancel'),
  ];

  @override
  KeyResult onKey(KeyPress press) {
    switch (press.key) {
      case Key.enter:
        final typed = _buffer.isEmpty ? defaultValue ?? '' : _buffer.text;
        final parsed = parser(typed);
        if (parsed.problem != null || parsed.value is! T) {
          error = parsed.problem ?? 'Try again';

          return KeyResult.handled;
        }
        _result = parsed.value;

        return KeyResult.done;
      case Key.tab when _buffer.isEmpty && defaultValue != null && mask == null:
        _buffer.text = defaultValue ?? '';

        return KeyResult.handled;
      case Key.up || Key.down when stepper != null:
        final current = _buffer.isEmpty ? defaultValue ?? '' : _buffer.text;
        _buffer.text = stepper!(current, press.key == Key.up ? 1 : -1);

        return KeyResult.handled;
      default:
        return _buffer.handle(press) ? KeyResult.handled : KeyResult.ignored;
    }
  }

  @override
  T get result => _result as T;

  @override
  String describe(T value) => shown?.call(value) ?? _display('$value');

  @override
  String get fallbackHint {
    final value = defaultValue;

    return value == null || value.isEmpty || mask != null ? '' : '($value)';
  }

  @override
  ({T? value, String? problem}) parse(String typed) =>
      parser(typed.isEmpty ? defaultValue ?? '' : typed);

  @override
  T fallback() => PromptLine.run<T>(
    question,
    hint: fallbackHint,
    shown: describe,
    check: parse,
    hidden: mask != null,
  );

  @override
  T? get unattended {
    final parsed = parser(defaultValue ?? '');

    return parsed.problem == null ? parsed.value : null;
  }
}
