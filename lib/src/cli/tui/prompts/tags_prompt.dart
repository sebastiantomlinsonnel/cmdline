import '../../../../cmdline.dart';

/// Type a list of short words, like labels or package names.
///
/// Enter or a comma adds what is typed as a tag, Backspace in an empty box
/// removes the last one, and Tab finishes the word from [suggestions]. Enter
/// in an empty box finishes.
///
/// {@category cli}
class TagsPrompt extends PromptView<List<String>> {
  /// Words offered while typing.
  final List<String> suggestions;

  /// Whether words that aren't in [suggestions] are allowed.
  final bool allowNew;

  /// The fewest tags needed.
  final int min;

  /// The tags at the start.
  final List<String> initial;

  final List<String> _tags;
  final TextBuffer _input = TextBuffer();
  int _pick = 0;

  /// Creates a tag box asking [question].
  TagsPrompt(
    super.question, {
    this.suggestions = const [],
    this.allowNew = true,
    this.min = 0,
    this.initial = const [],
  }) : _tags = [...initial];

  List<String> get _matches {
    final typed = _input.text.trim().toLowerCase();

    return [
      for (final word in suggestions)
        if (!_tags.contains(word) &&
            (typed.isEmpty || word.toLowerCase().startsWith(typed)))
          word,
    ];
  }

  String _chip(String tag) => '[$tag]'.foreground(theme.highlight);

  @override
  String inline() {
    final chips = _tags.map(_chip).join(' ');

    return chips.isEmpty ? _input.text : '$chips ${_input.text}';
  }

  @override
  int? get inlineCursor {
    final chips = _tags.map(_chip).join(' ');

    return (chips.isEmpty ? 0 : chips.width + 1) + _input.beforeCursor.width;
  }

  @override
  List<String> body() {
    final matches = _matches;
    if (matches.isEmpty || (_input.isEmpty && suggestions.length > 8))
      return const [];
    final shown = matches.take(6).toList();
    final pick = _pick.clamp(0, shown.length - 1);

    return [
      '  ${[for (var i = 0; i < shown.length; i++) i == pick ? shown[i].bold.foreground(theme.highlight) : muted(shown[i])].join('  ')}',
    ];
  }

  @override
  List<KeyHint> get keys => [
    ('enter', _input.isEmpty ? 'done' : 'add'),
    if (_matches.isNotEmpty) ('tab', 'complete'),
    ('bksp', 'remove'),
    ('esc', 'cancel'),
  ];

  bool _add(String word) {
    final tag = word.trim();
    if (tag.isEmpty) return false;
    if (!allowNew && !suggestions.contains(tag)) {
      error = '"$tag" isn\'t one of the choices';

      return false;
    }
    if (!_tags.contains(tag)) _tags.add(tag);
    _input.clear();
    _pick = 0;

    return true;
  }

  @override
  KeyResult onKey(KeyPress press) {
    switch (press.key) {
      case Key.enter when _input.text.trim().isEmpty:
        if (_tags.length < min) {
          error = 'Add at least $min';

          return KeyResult.handled;
        }

        return KeyResult.done;
      case Key.enter:
        _add(_input.text);
      case Key.char when press.char == ',':
        _add(_input.text);
      case Key.tab:
        final matches = _matches;
        if (matches.isEmpty) return KeyResult.ignored;
        _add(matches[_pick.clamp(0, matches.length - 1)]);
      case Key.left || Key.right when _input.isEmpty && _matches.isNotEmpty:
        _pick = (_pick + (press.key == Key.right ? 1 : -1)).clamp(0, 5);
      case Key.backspace when _input.isEmpty && _tags.isNotEmpty:
        _tags.removeLast();
      default:
        if (!_input.handle(press)) return KeyResult.ignored;
        _pick = 0;
    }

    return KeyResult.handled;
  }

  @override
  List<String> get result => List.unmodifiable(_tags);

  @override
  String describe(List<String> value) =>
      value.isEmpty ? 'none' : value.join(', ');

  @override
  String get fallbackHint =>
      initial.isEmpty ? '(comma separated)' : '(${initial.join(', ')})';

  @override
  ({List<String>? value, String? problem}) parse(String typed) {
    final tags = typed.isEmpty
        ? initial
        : [
            for (final word in typed.split(','))
              if (word.trim().isNotEmpty) word.trim(),
          ];
    if (!allowNew) {
      final unknown = tags.where((tag) => !suggestions.contains(tag));
      if (unknown.isNotEmpty) {
        return (value: null, problem: 'Pick from: ${suggestions.join(', ')}');
      }
    }
    if (tags.length < min) return (value: null, problem: 'Add at least $min');

    return (value: tags.toSet().toList(), problem: null);
  }

  @override
  List<String>? get unattended => initial.length >= min ? initial : null;
}
