import 'dart:math' as math;

import '../../../../cmdline.dart';

/// What a prompt wants to happen after a key press.
///
/// {@category cli}
enum KeyResult {
  /// The key changed something; draw again.
  handled,

  /// The key meant nothing here.
  ignored,

  /// The answer is ready; close the prompt.
  done,

  /// The user gave up; close the prompt without an answer.
  cancel,
}

/// A key and what it does, shown in the dim key hints under a prompt.
typedef KeyHint = (String keys, String action);

/// The base of every interactive prompt.
///
/// A prompt draws itself as text lines, reacts to key presses and, once
/// done, gives back its [result]. [PromptRunner] does the rest: raw mode,
/// redrawing, the question line, errors, key hints and the line and
/// unattended fallbacks.
///
/// To make your own, extend this and fill in the parts that matter:
///
/// ```dart
/// class Counter extends PromptView<int> {
///   int count = 0;
///   Counter() : super('Count');
///
///   @override
///   String inline() => '$count'.bold;
///
///   @override
///   KeyResult onKey(KeyPress press) => switch (press.key) {
///     Key.up => (count++, KeyResult.handled).$2,
///     Key.enter => KeyResult.done,
///     _ => KeyResult.ignored,
///   };
///
///   @override
///   int get result => count;
/// }
///
/// final n = PromptRunner.run(Counter());
/// ```
///
/// {@category cli}
abstract class PromptView<T> {
  /// The question at the top of the prompt.
  final String question;

  /// A problem to show under the prompt, like a failed check. Cleared on
  /// every key press.
  String? error;

  /// Creates a prompt asking [question].
  PromptView(this.question);

  /// The theme in use.
  AnsiTheme get theme => AnsiTheme.current;

  /// The text after the question, on the same line. Defaults to nothing.
  String inline() => '';

  /// The lines under the question line. Defaults to none.
  List<String> body() => const [];

  /// Where the blinking cursor goes in [inline], in screen columns; null
  /// hides it. Text inputs use this.
  int? get inlineCursor => null;

  /// Where the blinking cursor goes in [body], if anywhere. Used when
  /// [inlineCursor] is null.
  CursorSpot? get bodyCursor => null;

  /// The keys shown in the hints line.
  List<KeyHint> get keys => const [];

  /// Reacts to [press] and says what should happen next.
  ///
  /// Esc, Ctrl+C and the end of input cancel the prompt, unless this
  /// handles them first.
  KeyResult onKey(KeyPress press);

  /// The answer, read once [onKey] gives back [KeyResult.done].
  T get result;

  /// How [value] is shown after the question once answered.
  String describe(T value) => '$value';

  /// Asks the question without a live screen, one typed line at a time.
  ///
  /// Used in [PromptMode.line]. Defaults to [PromptLine] with [parse].
  T fallback() => PromptLine.run<T>(
    question,
    hint: fallbackHint,
    shown: describe,
    check: parse,
  );

  /// The dim hint shown in line mode, like `(1-5)` or `[y/N]`.
  String get fallbackHint => '';

  /// Turns a typed line into an answer, for line mode.
  ///
  /// Gives back the value, or a problem to show before asking again.
  ({T? value, String? problem}) parse(String typed) =>
      (value: null, problem: 'This prompt needs a terminal');

  /// The answer used in [PromptMode.unattended], or null if there isn't one.
  T? get unattended => null;

  /// How many list rows fit under the prompt, leaving room for [reserved]
  /// other lines.
  int pageSizeFor(int count, {int reserved = 4, int? max}) {
    final room = math.max(Terminal.current.rows - reserved, 3);

    return math.min(count, math.min(room, max ?? room));
  }

  /// [text] in the theme's [AnsiTheme.muted] colour.
  String muted(String text) => text.foreground(theme.muted);

  /// [text] as the highlighted row: the pointer, bold, in the highlight.
  String pointed(String text) =>
      '${theme.pointer} $text'.bold.foreground(theme.highlight);

  /// [text] as a normal row, lined up with [pointed] rows.
  String unpointed(String text) => '${' ' * theme.pointer.width} $text';

  /// A scroll hint line, like `↑ 3 more`, or null when nothing is hidden.
  String? moreLine(int hidden, {required bool above}) {
    if (hidden <= 0) return null;
    final arrow = above ? theme.glyphs.moreAbove : theme.glyphs.moreBelow;

    return muted('${' ' * theme.pointer.width} $arrow $hidden more');
  }
}
