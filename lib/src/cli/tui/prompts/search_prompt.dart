// Adapted from terminice (MIT), https://github.com/jozzdart/terminice
import '../../../../cmdline.dart';

/// How well a search matched some text, and which characters matched.
typedef FuzzyMatch = ({int score, List<int> positions});

/// Fuzzy matching, like a code editor's file finder.
///
/// The letters of the query must appear in the text in order, but not next
/// to each other: `gco` matches `git checkout`. Matches score higher when
/// letters are next to each other or start words.
///
/// {@category cli}
abstract final class Fuzzy {
  static const int _hit = 1;
  static const int _nextToLast = 5;
  static const int _wordStart = 8;
  static const int _textStart = 10;

  /// How well [query] matches [text], or null if it doesn't. Case is
  /// ignored. An empty query matches everything with a score of 0.
  static FuzzyMatch? match(String query, String text) {
    if (query.isEmpty) return (score: 0, positions: const []);
    final chars = graphemes(text.plain.toLowerCase()).toList();
    final wanted = graphemes(query.toLowerCase())
        .where((c) => c != ' ')
        .toList();
    final positions = <int>[];
    var score = 0;
    var at = 0;
    for (final char in wanted) {
      while (at < chars.length && chars[at] != char) {
        at++;
      }
      if (at == chars.length) return null;
      score += _hit;
      if (positions.isNotEmpty && positions.last == at - 1)
        score += _nextToLast;
      if (at == 0) {
        score += _textStart;
      } else if (const [' ', '-', '_', '/', '.', ':'].contains(chars[at - 1])) {
        score += _wordStart;
      }
      positions.add(at++);
    }

    // Shorter texts win ties.
    return (score: score * 100 - chars.length, positions: positions);
  }

  /// [text] with the characters at [positions] drawn with [style].
  static String highlight(
    String text,
    List<int> positions,
    String Function(String) style,
  ) {
    if (positions.isEmpty) return text;
    final wanted = positions.toSet();
    final out = StringBuffer();
    var index = 0;
    for (final char in graphemes(text.plain)) {
      out.write(wanted.contains(index++) ? style(char) : char);
    }

    return out.toString();
  }
}

/// Pick one option by typing to filter the list, like a command palette.
///
/// Typing narrows the list with [Fuzzy] matching, best match first; the
/// arrows move through what is left and Enter picks.
///
/// {@category cli}
class SearchPrompt<T> extends PromptView<T> {
  /// The options to search.
  final List<T> options;

  /// The text shown for each option.
  final List<String> labels;

  /// Dim text after each option, which is searched too.
  final List<String> notes;

  /// The option to give back in [PromptMode.unattended], if any.
  final int? defaultIndex;

  final TextBuffer _query = TextBuffer();
  late final ListCursor _cursor;
  List<({int index, FuzzyMatch match})> _found = [];

  /// Creates a searchable list asking [question].
  SearchPrompt(
    super.question,
    this.options, {
    String Function(T option)? format,
    String Function(T option)? note,
    this.defaultIndex,
    int? pageSize,
  }) : labels = [
         for (final option in options) format?.call(option) ?? '$option',
       ],
       notes = [for (final option in options) note?.call(option) ?? ''] {
    if (options.isEmpty) throw ArgumentError.value(options, 'options', 'Empty');
    _cursor = ListCursor(
      0,
      pageSize: pageSize ?? pageSizeFor(options.length, reserved: 5),
    );
    _filter();
  }

  void _filter() {
    final query = _query.text.trim();
    _found = [
      for (var i = 0; i < options.length; i++)
        if (Fuzzy.match(query, '${labels[i]} ${notes[i]}') case final match?)
          (index: i, match: match),
    ];
    if (query.isNotEmpty) {
      _found.sort((a, b) => b.match.score.compareTo(a.match.score));
    }
    _cursor.resize(_found.length, reset: true);
  }

  String _row(({int index, FuzzyMatch match}) found) {
    final label = labels[found.index].plain;
    final inLabel = found.match.positions
        .where((p) => p < label.length)
        .toList();
    final shown = Fuzzy.highlight(label, inLabel, (c) => c.bold.underline);
    final note = notes[found.index];

    return note.isEmpty ? shown : '$shown  ${muted(note)}';
  }

  @override
  String inline() => _query.isEmpty ? muted('type to search') : _query.text;

  @override
  int? get inlineCursor => _query.beforeCursor.width;

  @override
  List<String> body() {
    if (_found.isEmpty) return [muted('  No matches')];
    final columns = Terminal.current.columns - 1;
    final above = moreLine(_cursor.top, above: true);
    final below = moreLine(_found.length - _cursor.bottom, above: false);

    return [
      ?above,
      for (var i = _cursor.top; i < _cursor.bottom; i++)
        (i == _cursor.index
                ? pointed(_row(_found[i]))
                : unpointed(_row(_found[i])))
            .fitWidth(columns),
      ?below,
    ];
  }

  @override
  List<KeyHint> get keys => const [
    ('type', 'filter'),
    ('↑↓', 'move'),
    ('enter', 'pick'),
    ('esc', 'cancel'),
  ];

  @override
  KeyResult onKey(KeyPress press) {
    if (press.key == Key.enter) {
      if (_found.isNotEmpty) return KeyResult.done;
      error = 'Nothing matches "${_query.text}"';

      return KeyResult.handled;
    }
    if (_cursor.handle(press)) return KeyResult.handled;
    if (press.key == Key.escape && !_query.isEmpty) {
      // The first Esc clears the search, the next one cancels.
      _query.clear();
      _filter();

      return KeyResult.handled;
    }
    if (!_query.handle(press)) return KeyResult.ignored;
    _filter();

    return KeyResult.handled;
  }

  @override
  T get result => options[_found[_cursor.index].index];

  @override
  String describe(T value) => labels[options.indexOf(value)].plain;

  @override
  T fallback() {
    while (true) {
      final query = PromptLine.run<String>(
        question,
        hint: '(search)',
        shown: (text) => text,
        check: (text) => (value: text, problem: null),
      );
      final matches = [
        for (var i = 0; i < options.length; i++)
          if (Fuzzy.match(query, '${labels[i]} ${notes[i]}') case final match?)
            (index: i, score: match.score),
      ]..sort((a, b) => b.score.compareTo(a.score));
      if (matches.isEmpty) {
        PromptRunner.say(theme.errorLine('Nothing matches "$query"'));
        continue;
      }
      if (matches.length == 1) return options[matches.single.index];

      return SelectPrompt<T>('Which one?', [
        for (final m in matches) options[m.index],
      ], format: (option) => labels[options.indexOf(option)]).fallback();
    }
  }

  @override
  T? get unattended => defaultIndex == null ? null : options[defaultIndex!];
}
