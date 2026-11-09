// Adapted from terminice (MIT), https://github.com/jozzdart/terminice
import '../../../../cmdline.dart';

/// Runs a [PromptView]: shows it, feeds it keys and gives back its answer.
///
/// Picks how to ask from [PromptMode.current]:
/// * [PromptMode.rich]: a live prompt redrawn on every key press.
/// * [PromptMode.line]: the prompt's [PromptView.fallback], typed answers.
/// * [PromptMode.unattended]: the prompt's [PromptView.unattended] answer.
///
/// In every mode the prompt ends with one `✔ question answer` line. A
/// cancelled prompt throws [PromptCancelled].
///
/// {@category cli}
abstract final class PromptRunner {
  /// Asks [view] and gives back its answer.
  static T run<T>(PromptView<T> view) {
    switch (PromptMode.current) {
      case PromptMode.unattended:
        final value = view.unattended;
        if (value == null) {
          throw PromptCancelled(view.question, 'no default when unattended');
        }
        say(answeredLine(view.question, view.describe(value)));

        return value;
      case PromptMode.line:
        return view.fallback();
      case PromptMode.rich:
        return _live(view);
    }
  }

  /// Prints [line] on [terminal] (or [Terminal.current]), without styles if
  /// colour is off.
  static void say(String line, [Terminal? terminal]) {
    final text = AnsiTheme.useColour ? '$line$RESET' : line.plain;
    (terminal ?? Terminal.current).write('$text\n');
  }

  /// The line left behind by an answered prompt: tick, question, answer.
  static String answeredLine(String question, String answer) {
    final theme = AnsiTheme.current;

    return '${theme.tick.foreground(theme.success)} '
        '${question.bold.foreground(theme.question)} '
        '${answer.foreground(theme.answer)}';
  }

  /// The line left behind by a cancelled prompt.
  static String cancelledLine(String question) {
    final theme = AnsiTheme.current;

    return '${theme.cross.foreground(theme.error)} '
        '${question.bold.foreground(theme.question)} '
        '${'cancelled'.foreground(theme.muted)}';
  }

  /// The dim key hints line, like `↑↓ move  enter pick  esc cancel`.
  static String keysLine(List<KeyHint> keys) {
    final theme = AnsiTheme.current;

    return keys
        .map(
          (hint) => '${hint.$1.foreground(theme.key)} '
              '${hint.$2.foreground(theme.muted)}',
        )
        .join('  ');
  }

  /// The rich, redrawn prompt.
  static T _live<T>(PromptView<T> view) {
    final terminal = Terminal.current;
    final reader = KeyReader(terminal);
    final region = LiveRegion(terminal);
    final echo = terminal.echoMode;
    final lineMode = terminal.lineMode;
    // Windows needs echo off before line mode can be turned off.
    terminal
      ..echoMode = false
      ..lineMode = false;
    try {
      while (true) {
        _draw(view, region);
        final press = reader.read();
        view.error = null;
        var outcome = view.onKey(press);
        if (outcome == KeyResult.ignored &&
            (press.key == Key.escape ||
                press.key == Key.interrupt ||
                press.key == Key.endOfInput)) {
          outcome = KeyResult.cancel;
        }
        if (outcome == KeyResult.done) {
          final value = view.result;
          region.finish([answeredLine(view.question, view.describe(value))]);

          return value;
        }
        if (outcome == KeyResult.cancel) {
          region.finish([cancelledLine(view.question)]);
          final reason = switch (press.key) {
            Key.interrupt => 'interrupted',
            Key.endOfInput => 'input ended',
            _ => 'cancelled',
          };
          throw PromptCancelled(view.question, reason);
        }
      }
    } finally {
      if (!region.isEmpty) region.clear();
      // Line mode must come back before echo on Windows.
      terminal
        ..lineMode = lineMode
        ..echoMode = echo;
    }
  }

  /// Draws the whole prompt: question line, body, error and key hints.
  static void _draw<T>(PromptView<T> view, LiveRegion region) {
    final theme = AnsiTheme.current;
    final head =
        '${theme.glyphs.question.foreground(theme.hint)} '
        '${view.question.bold.foreground(theme.question)} ';
    final inline = view.inline();
    final body = view.body();
    final error = view.error;
    final keys = view.keys;
    final lines = [
      '$head$inline',
      ...body,
      if (error != null) theme.errorLine(error),
      if (theme.showKeys && keys.isNotEmpty) keysLine(keys),
    ];

    final inlineCursor = view.inlineCursor;
    final bodyCursor = view.bodyCursor;
    final CursorSpot? cursor = inlineCursor != null
        ? (line: 0, column: head.width + inlineCursor)
        : bodyCursor == null
        ? null
        : (line: bodyCursor.line + 1, column: bodyCursor.column);
    region.draw(lines, cursor: cursor);
  }
}
