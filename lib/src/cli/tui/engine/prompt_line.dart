import '../../../../cmdline.dart';

/// What a prompt's check makes of the typed text.
///
/// Either a `value` to give back, or a `problem` to show before asking again.
typedef PromptCheck<T> = ({T? value, String? problem}) Function(String typed);

/// Asks one question on one line until the answer passes a check.
///
/// This is how prompts ask in [PromptMode.line], when there is no live
/// screen. When the screen can move the cursor, a wrong answer shows a themed
/// error line under the question and the question is redrawn in place. Once
/// answered, the line is redrawn with a tick and the answer.
///
/// {@category cli}
abstract final class PromptLine {
  /// Shows [question] (with an optional dim [hint]) until [check] accepts.
  ///
  /// [shown] turns the accepted value into the text echoed after the
  /// question. With [hidden], typing isn't shown on screen. If input ends,
  /// [check] gets an empty string, and if that isn't accepted a
  /// [PromptCancelled] is thrown.
  static T run<T>(
    String question, {
    required PromptCheck<T> check,
    required String Function(T value) shown,
    String hint = '',
    bool hidden = false,
  }) {
    final terminal = Terminal.current;
    final theme = AnsiTheme.current;
    final fancy = terminal.supportsAnsi && terminal.hasInput;
    final text = question.bold.foreground(theme.question);
    final hintText = hint.isEmpty ? '' : ' ${hint.foreground(theme.hint)}';
    final asked = '${theme.glyphs.question.foreground(theme.hint)} $text$hintText ';

    var showingProblem = false;
    while (true) {
      terminal.write(AnsiTheme.paint(asked));
      final typed = _readLine(terminal, hidden: hidden);
      if (typed != null && !terminal.hasInput) {
        // Piped input isn't echoed, so show what was read, like a transcript.
        final echoed = hidden ? theme.glyphs.mask * typed.length : typed;
        terminal.write('${AnsiTheme.paint(echoed)}\n');
      }
      final result = check(typed?.trim() ?? '');

      // Wipe the old error line under the question.
      if (fancy && showingProblem) terminal.write('\r$CLEAR_TO_SCREEN_END');

      final value = result.value;
      if (result.problem == null && value is T) {
        final done = PromptRunner.answeredLine(question, shown(value));
        if (fancy) {
          terminal.write('${cursorUp()}\r$CLEAR_LINE');
          PromptRunner.say(done);
        } else if (typed == null) {
          // Input ended, so the answer didn't end the line.
          terminal.write('\n');
        }

        return value;
      }
      if (typed == null) {
        if (!fancy) terminal.write('\n');
        throw PromptCancelled(question, 'input ended');
      }

      final problem = theme.errorLine(result.problem ?? 'Try again');
      if (fancy) {
        // Show the error under the question, then go back up to ask again.
        terminal.write(
          '${AnsiTheme.paint(problem)}${cursorUp()}\r$CLEAR_LINE',
        );
        showingProblem = true;
      } else {
        PromptRunner.say(problem);
      }
    }
  }

  /// Reads one line, hiding what is typed if [hidden] is true.
  ///
  /// Gives back null when input has ended.
  static String? _readLine(Terminal terminal, {required bool hidden}) {
    if (!hidden || !terminal.hasInput) return terminal.readLine();

    final echo = terminal.echoMode;
    terminal.echoMode = false;
    try {
      return terminal.readLine();
    } finally {
      terminal.echoMode = echo;
      // Enter wasn't shown either, so move to the next line ourselves.
      terminal.write('\n');
    }
  }
}
