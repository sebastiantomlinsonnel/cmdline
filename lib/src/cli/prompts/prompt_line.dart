import 'dart:io';

import 'package:cmdline/cmdline.dart';

/// What a prompt's check makes of the typed text.
///
/// Either a [value] to give back, or a [problem] to show before asking again.
typedef PromptCheck<T> = ({T? value, String? problem}) Function(String typed);

/// Asks one question on one line until the answer passes a check.
///
/// Used by [ask], [confirm] and the plain [menu]. With colour on, a wrong
/// answer shows a themed error line under the question, and the question is
/// redrawn in place. Once answered, the line is redrawn with a tick and the
/// answer in the theme's answer colour.
class PromptLine {
  const PromptLine._();

  /// Shows [question] (with an optional dim [hint]) until [check] accepts.
  ///
  /// [shown] turns the accepted value into the text echoed after the
  /// question. With [hidden], typing isn't shown on screen. If input ends
  /// (stdin is closed), [check] gets an empty string, and if that isn't
  /// accepted a [StdinException] is thrown.
  static T run<T>(
    String question, {
    required PromptCheck<T> check,
    required String Function(T value) shown,
    String hint = '',
    bool hidden = false,
  }) {
    final theme = CliTheme.current;
    final fancy = CliTheme.useColour && stdout.hasTerminal;
    final text = question.bold.foreground(theme.question);
    final hintText = hint.isEmpty ? '' : ' ${hint.dim.foreground(theme.hint)}';
    final asked = '${'?'.foreground(theme.hint)} $text$hintText ';

    var showingProblem = false;
    while (true) {
      CliTheme.write(asked);
      final typed = _readLine(hidden: hidden);
      final result = check(typed?.trim() ?? '');

      // Wipe the old error line under the question.
      if (fancy && showingProblem) stdout.write('\r$CLEAR_TO_SCREEN_END');

      final value = result.value;
      if (result.problem == null && value is T) {
        if (fancy) {
          final done =
              '${theme.tick.foreground(theme.success)} $text '
              '${shown(value).foreground(theme.answer)}';
          stdout.write('${cursorUp()}\r$CLEAR_LINE$done$RESET\n');
        }

        return value;
      }
      if (typed == null) {
        throw const StdinException('Input ended before an answer was given');
      }

      final problem = theme.errorLine(result.problem ?? 'Try again');
      if (fancy) {
        // Show the error under the question, then go back up to ask again.
        stdout.write('$problem${cursorUp()}\r$CLEAR_LINE');
        showingProblem = true;
      } else {
        CliTheme.say(problem);
      }
    }
  }

  /// Reads one line from stdin, hiding what is typed if [hidden] is true.
  ///
  /// Gives back null when stdin has closed.
  static String? _readLine({required bool hidden}) {
    if (!hidden || !stdin.hasTerminal) return stdin.readLineSync();

    final echo = stdin.echoMode;
    stdin.echoMode = false;
    try {
      return stdin.readLineSync();
    } finally {
      stdin.echoMode = echo;
      // Enter wasn't shown either, so move to the next line ourselves.
      stdout.writeln();
    }
  }
}
